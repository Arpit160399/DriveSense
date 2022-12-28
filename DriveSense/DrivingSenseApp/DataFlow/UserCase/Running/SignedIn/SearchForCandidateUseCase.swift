//
//  searchForCandidateUseCase.swift
//  DriveSense
//
//  Created by Arpit Singh on 10/10/22.
//

import Foundation
import Combine
class SearchForCandidateUseCase: UseCase {
    
    // MARK: - Properties
    private var task = Set<AnyCancellable>()
    
    private let query: String
    
    private let pageNumber: Int
    
    private let actionDispatcher: ActionDispatcher
    
    private let remoteAPi: InstructorRemoteApi
    
    // MARK: - methods
    init(query: String,
         actionDispatcher: ActionDispatcher,
         page: Int,
         remoteAPi: InstructorRemoteApi) {
        self.query = query
        self.actionDispatcher = actionDispatcher
        self.pageNumber = page
        self.remoteAPi = remoteAPi
    }
    
    func start() {
        let action = SignedInAction.FetchingCandidateList(forQuery: query)
        actionDispatcher.dispatch(action)
        let page = pageNumber,query = query
        remoteAPi.searchCandidateBy(name: query, page: page)
            .sink { completion in
                if case .failure(let error) = completion {
                    var errorMessage = ErrorMessage(title: "Error occured", message: "Unable to Search the candidate related to \(query)")
                    if case NetworkError.serverWith(let res) = error {
                        errorMessage.message = res.message
                    }
                    let action = SignedInAction
                    .PresentedCandiateFetchingError(error: errorMessage)
                    self.actionDispatcher.dispatch(action)
                }
            } receiveValue: { candidates in
                let action = SignedInAction.SearchForCandidateBy(name: query, candidates: candidates, pageNumber: page)
                self.actionDispatcher.dispatch(action)
            }.store(in: &task)
    }
    
}

protocol SearchForCandidateUseCaseFactory {
    func makeSearchForCandidateUserCase(query: String,page: Int) -> UseCase
}
