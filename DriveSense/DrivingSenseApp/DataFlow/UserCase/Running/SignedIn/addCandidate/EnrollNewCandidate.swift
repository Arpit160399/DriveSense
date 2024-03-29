//
//  EnrollNewCandidate.swift
//  DriveSense
//
//  Created by Arpit Singh on 15/09/22.
//
import Combine
import Foundation
class EnrollNewCandidates: UseCase {
    
    private var task = Set<AnyCancellable>()
    
    private let remoteApi: InstructorRemoteApi
    private let candidate: CandidatesModel
    private let actionDispatcher: ActionDispatcher
    
    init(actionDispatcher: ActionDispatcher,
         candidate: CandidatesModel,
         remoteApi: InstructorRemoteApi) {
        self.actionDispatcher = actionDispatcher
        self.remoteApi = remoteApi
        self.candidate = candidate
    }

    func start() {
        let action = AddCandidateAction.EnrollInProgress(candidate: candidate)
        actionDispatcher.dispatch(action)
        remoteApi.addNew(candidate: candidate)
            .sink { completion in
                if case .failure(let error) = completion {
                    var errorMessage = ErrorMessage(title: "Error", message: "Failed To enrol New candidate at the moment")
                    if case NetworkError.serverWith(let res)  = error {
                        errorMessage.message = res.message
                    }
                    let action = AddCandidateAction
                        .FinishedWithError(error: errorMessage)
                    self.actionDispatcher.dispatch(action)
                }
           } receiveValue: { candidateList in
               let action = AddCandidateAction
                   .SuccessFullEnrolled(candidateList: candidateList)
               self.actionDispatcher.dispatch(action)
           }.store(in: &task)
    }
}

protocol EnrollNewCandidateFactory {
    func makeEnrollNewCandidateUseCase(candidate: CandidatesModel) -> UseCase
}
