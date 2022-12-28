//
//  AssessmentDataLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 05/11/22.
//
import Combine
import Foundation
class DriverSenseAssessmentDataLayer: AssessmentDataLayer {
    
    // MARK: - property
    private let remoteApi: AssessmentRemoteApi
    private let candidateLocalStore: CandidatePersistenceLayer
    private let assessmentLocalStore: AssessmentPersistenceLayer
    private let candidate: CandidatesModel
    
    // MARK: - methods
    init(candidate: CandidatesModel,
         candidateCache: CandidatePersistenceLayer,
         assessmentCache: AssessmentPersistenceLayer,
         remoteApi: AssessmentRemoteApi)
    {
        self.candidate = candidate
        self.candidateLocalStore = candidateCache
        self.assessmentLocalStore = assessmentCache
        self.remoteApi = remoteApi
    }
    
    func getAssessment(page: Int) -> AnyPublisher<[AssessmentModel], Error> {
        getCacheAssessment()
            .flatMap { (assessments: [AssessmentModel]) in
                if assessments.isEmpty {
                    return self.getAssessmentFromRemote(page: page)
                } else {
                    // TODO: - separate the synchronisation operation
                    // uploading if there is any unsynchronised data
                    let task = self.getAssessmentFromRemote(page: page)
                    return self.upload(assessments: assessments)
                        .flatMap { (_: [AssessmentModel]) -> AnyPublisher<[AssessmentModel], Error> in
                            // fetching new assessment list from server
                            return  self.clearCandidateCache()
                                  .flatMap { () -> AnyPublisher<[AssessmentModel], Error> in
                                      return task
                                  }.eraseToAnyPublisher()
                        }.tryCatch({ error -> AnyPublisher<[AssessmentModel], Error> in
                            print(error)
                            return task
                        }).eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    // TODO: improve performance of given function
    private func upload(assessments: [AssessmentModel]) -> AnyPublisher<[AssessmentModel], Error> {
        let initial = remoteApi.upload(assessment: assessments[0])
        let remaining = Array(assessments.dropFirst())
        let limit = 100
        let bufferSize = assessments.count % limit
        // creating pipeline stream for uploading every assessment
        let task = remaining.reduce(initial) { publishers, assessment in
            publishers.merge(with: remoteApi.upload(assessment: assessment))
                .eraseToAnyPublisher()
        }
        
        return task
            // For safety placing an limit to buffer size
            .collect(bufferSize)
            .mapError { $0 as Error }
            .flatMap { (assessments: [AssessmentModel]) -> AnyPublisher<[AssessmentModel], Error> in
                let initial = self.uploadSensor(forAssessment: assessments[0])
                let remaining = Array(assessments.dropFirst())
                // creating pipeline stream for uploading every sensor values for given assessment
                let task = remaining.reduce(initial) { combine, model in
                    combine.merge(with: self.uploadSensor(forAssessment: model)).eraseToAnyPublisher()
                }.eraseToAnyPublisher()
                
                return task
                     // setting up buffer size limit

                    .flatMap { (model: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> in
                        // clearing assessment model from cache
                      return  self.clearAssessmentCache(model)
                            .map { () -> AssessmentModel in
                                    return model
                            }.eraseToAnyPublisher()
                    }
                    .collect(bufferSize)
                    .eraseToAnyPublisher()
                
            }.eraseToAnyPublisher()
    }
    
    fileprivate func manageCacheFor(sensor: [SensorModel],assessment: AssessmentModel)
          -> AnyPublisher<AssessmentModel,Error> {
        return remoteApi
              // uploading sensor value in a batch
            .sendSensor(values: sensor, for: assessment)
            .mapError { $0 as Error }
            .flatMap({ (model: [SensorModel]) -> AnyPublisher<AssessmentModel,Error> in
                // clearing cache with uploaded sensor values
                return self.clearCache(sensor: model,forAssessment: assessment)
                .map({ () -> AssessmentModel in
                    return assessment
                }).eraseToAnyPublisher()
            }).eraseToAnyPublisher()
    }
    
    private func uploadSensor(forAssessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        let sensorLocalStore = CoreDateSensorPersistencelayer(assessment: forAssessment)
        let task = sensorLocalStore.count()
            .flatMap { (size: Int) -> AnyPublisher<AssessmentModel, Error> in
                guard size > 0 else {
                    // TODO: find any approach to handle case of object not found
//                    let error = CoreDataError.objectNotFound as Error
                    return Just<AssessmentModel>(forAssessment)
                        .setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                let limit = min(40,size),range = Int(size / limit)
                // Fetching all sensor value in batch from the cache
                let initial = sensorLocalStore.fetch(page: 1, limit: limit, id: nil)
                guard range > 2 else {
                    return initial
                        .flatMap { (sensorData: [SensorModel]) -> AnyPublisher<AssessmentModel, Error> in
                            // uploading sensor value to the server and clearing the cache
                            self.manageCacheFor(sensor: sensorData,assessment: forAssessment)
                        }.eraseToAnyPublisher()
                }
                let task = (2 ..< range).reduce(initial) { combine, page in
                    combine.merge(with: sensorLocalStore
                        .fetch(page: page, limit: limit, id: nil)).eraseToAnyPublisher()
                }
                return task
                    .flatMap { (sensorData: [SensorModel]) -> AnyPublisher<AssessmentModel, Error> in
                        // uploading sensor value to the server and clearing the cache
                        self.manageCacheFor(sensor: sensorData,assessment: forAssessment)
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
        return task
    }
    
    private func getAssessmentFromRemote(page: Int) -> AnyPublisher<[AssessmentModel], Error> {
        return remoteApi.getAssessmentFor(candidate: candidate, page: page)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func update(feedback: FeedbackModel, forAssessment: AssessmentModel) -> AnyPublisher<FeedbackModel, Error> {
        let sensorLocalStore = CoreDateSensorPersistencelayer(assessment: forAssessment)
        return sensorLocalStore.update(feedback: feedback)
    }
    
    func collect(sensor: SensorModel, forAssessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        let sensorLocalStore = CoreDateSensorPersistencelayer(assessment: forAssessment)
        return sensorLocalStore
            .create(sensor: sensor)
            .flatMap { (_: SensorModel) -> AnyPublisher<AssessmentModel, Error> in
                Publishers
                // fetching computation value from cache
                    .Zip(sensorLocalStore.getAvgSpeed(),
                         sensorLocalStore.getTotalDistance())
                    .flatMap { (avgSpeed: Double, totalDistance: Double) -> AnyPublisher<AssessmentModel, Error> in
                        // Accordingly updating the assessment model
                        var assessment = forAssessment
                        assessment.avgSpeed = avgSpeed
                        assessment.totalDistance = totalDistance
                        assessment.endedAt = sensor.time
                        return self.assessmentLocalStore.update(assessment: assessment)
                    }.eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
    func create(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        let (limit,page) = (10,1)
        // fetching one candidate with given ID
//        var assessment = assessment
        return candidateLocalStore
            .fetch(page: page, limit: limit, id: candidate.id)
            .flatMap { (candidates: [CandidatesModel]) -> AnyPublisher<AssessmentModel, Error> in
                if !candidates.isEmpty {
                    return self.store(assessment: assessment)
                } else {
                    return self.candidateLocalStore.create(candidate: self.candidate)
                        .flatMap { _ -> AnyPublisher<AssessmentModel, Error> in
                           // storing assessment related to that candidate into the cache 
                            self.store(assessment: assessment)
                        }.eraseToAnyPublisher()
                }
            }.eraseToAnyPublisher()
    }
    
    private func store(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel, Error> {
        return assessmentLocalStore.create(assessment: assessment)
    }
    
    private func getCacheAssessment() -> AnyPublisher<[AssessmentModel], Error> {
        let page = 1 , limit = 10
        return assessmentLocalStore.fetch(page: page, limit: limit, id: nil)
    }
    
    private func clearCache(sensor: [SensorModel],
                            forAssessment: AssessmentModel) -> AnyPublisher<Void,Error> {
        let sensorLocalStore = CoreDateSensorPersistencelayer(assessment: forAssessment)
        return sensorLocalStore.remove(sensor: sensor)
    }
    
    private func clearAssessmentCache(_ asssessment: AssessmentModel) -> AnyPublisher<Void,Error> {
        let assessmentLocalStore = assessmentLocalStore.remove(assessment: asssessment)
        return assessmentLocalStore
    }
    
    private func clearCandidateCache() -> AnyPublisher<Void, Error> {
        return candidateLocalStore.remove(candidate: candidate)
    }
}
