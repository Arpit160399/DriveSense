//
//  DataManager.swift
//  DriveSense
//
//  Created by Arpit Singh on 05/11/22.
//

import Foundation
class DataManager {
     
    
    init() {}
    
    
    func getAssessmentDataLayer(session: UserSession,candidate: CandidatesModel) -> AssessmentDataLayer {
        let candidateCache = CoreDataCandidatesPersistenceLayer(instructor: session.user)
        let assessmentCache = CoreDataAssessmentPersistencelayer(candidate: candidate)
        let remoteApi = DriveSenseAssessmentRemoteApi(userSession: session)
        let assessmentDataLayer = DriverSenseAssessmentDataLayer(candidate: candidate,
                    candidateCache: candidateCache,
                    assessmentCache: assessmentCache,
                    remoteApi: remoteApi)
        return assessmentDataLayer
    }
    
    func getInstructorDataLayer(session: UserSession) -> InstructorRemoteApi {
        let remoteApi = DriveSenseUserRemoteApi(userSession: session)
        return remoteApi
    }
    
    func getUserDataLayer() -> UserDataLayer {
        let remoteApi = DriveSenseRemoteAuth()
        let instructorCache = CoreDataInstructorPersistencelayer()
        let userDataLayer = DriverSenseUserDataLayer(remoteApi: remoteApi,
                                                     instructorCache: instructorCache)
        return userDataLayer
    }
    
}
