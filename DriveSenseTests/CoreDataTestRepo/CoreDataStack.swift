//
//  CoreDataStack.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 07/09/22.
//
import Combine
import Foundation

@testable import DriveSense
import XCTest
class CoreDataStack {
      private let contextManager: PersistentStoreCoordinator
      private var adi = ADIModel(no: "123456", expiryDate: "31/3/2022")
      private lazy var testInstuctor = InstructorModel(id: UUID(), name: "JAMES ROCK", email: "jame@gmail.com", postcode: "LH2234", address: "near the Hill up in the mountains", adi: adi, students: [], password: "12345")
      private lazy var testCandidates = CandidatesModel(id: UUID(), name: "TOM HANKS", dateOfBirth: 3404000, address: "new Boston near underground service", instructor: testInstuctor, assessment: [])
    private lazy var testFeedback = FeedbackModel(id: UUID(), control: .init(acceleration: "perfect",
    footBreak: "minor", steering: "minor", parkingBreak: "perfect", clutch: "perfect",
    gear: "perfect"), judgement: .init(overtaking: "perfect", meeting: "perfect", crossing: "minor"),
    junctions: .init(approachingSpeed: "minor", observation: "perfect", turingRight: "perfect",
    turingLeft: "perfect", cuttingCorner: "perfect"),positioning: .init(normalDriving: "minor",
    laneDiscipline: "perfect"), progress: .init(appropriatedSpeed: "perfect",
    undueHesitation: "perfect"),useofSpeed: "perfect", followingDistance: "perfect",
    reversePark: "perfect", moveOff: .init(safety: "minor", control: "minor"),
    totalFaults: 6, totalMajorFault: 0, totalMinorFault: 6)
      private lazy var testAssessment = AssessmentModel(id: UUID(), totalDistance: 23, avgSpeed: 120, conductedBy: testInstuctor, ofCandidate: testCandidates, feedback: testFeedback, sensor: [], timeStamp: 123450)
    
      private var testSensor: SensorModel = .init(id: UUID(), verdict: "straight driving", speed: 20, time: 800, direction: "forward", distance: 300, accelerometer: .init(x: 60, y: 45, z: 0), gps: .init(longitude: 3440, latitude: 4550), gyro: .init(x: 50, y: 60, z: 0),
        linearAccelerometer: .init(x: 40, y: 20, z: 0))
    
    
      init() throws {
          contextManager = PersistentStoreCoordinator(completion: { error in
              if error != nil {
                  XCTFail("Failed to generate Context")
              }
          })
      }
    
    private func createInstuctorObject(id: UUID? = nil) throws -> InstructorEntity {
        var newValue = testInstuctor
        let context = contextManager.viewContext
        let object = InstructorEntity(context: context)
        if id != nil {
          newValue.id = id
        }
         object.intoObject(from: newValue, context: context)
         if context.hasChanges {
                try context.save()
         }
        return object
    }
    
    private func createCandiatesFor(instuctor: InstructorEntity,
                                    id: UUID? = nil) throws -> CandidatesEntity {
        let context = contextManager.viewContext
        let object = CandidatesEntity(context: context)
        object.intoObject(from: testCandidates, context: context)
        if let id = id {
          object.id = id
        }
        instuctor.addToStudents(object)
        if context.hasChanges {
            try context.save()
        }
        return object
    }
    
    private func createAssessment(candidate: CandidatesEntity,
                                  id: UUID? = nil) throws -> AssessmentEntity {
        let context = contextManager.viewContext
        let object = AssessmentEntity(context: context)
        object.intoObject(from: testAssessment, context: context)
        if let id = id {
            object.id = id
        }
        candidate.addToAssessment(object)
        if context.hasChanges {
            try context.save()
        }
        return object
    }
    
    private func createSensor(assessment: AssessmentEntity,
                              id: UUID? = nil) throws -> SensorEntity {
        let context = contextManager.viewContext
        let object = SensorEntity(context: context)
        object.intoObject(from: testSensor, context: context)
        if let id = id {
            object.id = id
        }
        assessment.addToSensor(object)
        if context.hasChanges {
            try context.save()
        }
        return object
    }
    
    
    func getInstructorID() throws -> UUID {
        let id = try createInstuctorObject(id: UUID()).id
        return id
     }
    
     func createInstuctorTestRepo() -> (CoreDataInstructorPersistencelayer,InstructorModel) {
        return (CoreDataInstructorPersistencelayer(),testInstuctor)
     }
    
    func createCandiatesTestRepo() throws -> CandidateCoreDataTestResource {
        let instuctorEnitiy = try createInstuctorObject()
        let candiateEnitiy = try createCandiatesFor(instuctor: instuctorEnitiy,id: UUID())
        let repo = CoreDataCandidatesPersistenceLayer(instructor: instuctorEnitiy.toDomainModel())
        return CandidateCoreDataTestResource(candidate: testCandidates,
                                             fetchID: candiateEnitiy.id,
                                             repo: repo)
    }
    
    func createAssessementTestRepo() throws -> AssessmentCoreDataTestResource {
        let instuctorEnitiy = try createInstuctorObject()
        let candiateEnitiy = try createCandiatesFor(instuctor: instuctorEnitiy)
        let assessment = try createAssessment(candidate: candiateEnitiy,id: UUID())
        let repo = CoreDataAssessmentPersistencelayer(candidate: candiateEnitiy.toDomainModel())
        return AssessmentCoreDataTestResource(assessment: testAssessment,
                                              id: assessment.id ?? UUID(),
                                              repo: repo)
    }
    
    func createSensorTestRepo() throws -> SensorCoreDataTestResource {
        let instuctorEnitiy = try createInstuctorObject()
        let candiateEnitiy = try createCandiatesFor(instuctor: instuctorEnitiy)
        let assessment = try createAssessment(candidate: candiateEnitiy)
        let sensor = try createSensor(assessment: assessment,id: UUID())
        let repo = CoreDateSensorPersistencelayer(assessment: assessment.toDomainModel())
        return SensorCoreDataTestResource(sensor: testSensor, id: sensor.id,
                                          feedback: testFeedback,
                                          repo: repo)
    }
    
}

struct SensorCoreDataTestResource {
    var sensor: SensorModel
    var id: UUID
    var feedback: FeedbackModel
    var repo: CoreDateSensorPersistencelayer
}

struct AssessmentCoreDataTestResource {
    var assessment: AssessmentModel
    var id: UUID
    var repo: CoreDataAssessmentPersistencelayer
}

struct CandidateCoreDataTestResource {
    var candidate: CandidatesModel
    var fetchID: UUID
    var repo: CoreDataCandidatesPersistenceLayer
}
