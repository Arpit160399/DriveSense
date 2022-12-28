//
//  FetchCandidateUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//
import Combine
import Foundation
class FetchCandidateUseCase: UseCase {
    
    private var task = Set<AnyCancellable>()
    
    private var remoteApi: InstructorRemoteApi
    private var actionDispatcher: ActionDispatcher
    private var forPageNumber: Int
    
    init(remoteApi: InstructorRemoteApi,
         actionDispatcher: ActionDispatcher,
         page: Int) {
        self.actionDispatcher = actionDispatcher
        self.remoteApi = remoteApi
        self.forPageNumber = page
    }
    
    func start() {
        let page = forPageNumber
        let action = SignedInAction.FetchingCandidateList()
        actionDispatcher.dispatch(action)
        remoteApi
           .getCandidates(page: page)
           .sink { (completion: Subscribers.Completion<NetworkError>) in
               if case .failure(let error) = completion {
                   var errorMessage = ErrorMessage(title: "Error Occurred",
                             message: "Failed to fetch all enrolled Candidates")
                   if case NetworkError.serverWith(let res) = error {
                       errorMessage.message = res.message
                   }
                   let action = SignedInAction
                       .FinishedCandidateFetchingWithError(error: errorMessage)
                   self.actionDispatcher.dispatch(action)
               }
               
           } receiveValue: { list in
               let action = SignedInAction
                   .FetchedCandidateList(list: list,
                                         forPage: page)
               self.actionDispatcher.dispatch(action)
           }.store(in: &task)

    }
    
}

protocol FetchCandidateUseCaseFactory {
    func makeFetchCandidateUseCase(pageNumber: Int) -> UseCase
}
