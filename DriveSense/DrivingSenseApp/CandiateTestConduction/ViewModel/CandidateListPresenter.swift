//
//  CandidateListPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Foundation
class CandidateListPresenter: ObservableObject {
    
      @Published var candidates: [CandidatesModel]
      @Published var navigationMode: NavigationModel = .none
      @Published var state: SignedInState
      private let actionDispatcher: ActionDispatcher
      private let fetchCandidateListUseCaseFactory: FetchCandidateUseCaseFactory
    
    init(state: SignedInState,
         actionDispatcher: ActionDispatcher,
         fetchCandidateListFactory: FetchCandidateUseCaseFactory) {
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.fetchCandidateListUseCaseFactory = fetchCandidateListFactory
        candidates = state.candidates
      }

     func send(action: Action) {
         actionDispatcher.dispatch(action)
    }
    
    func getCandidatesList(fromPage: Int) {
       let usecase = fetchCandidateListUseCaseFactory
            .makeFetchCandidateUseCase(pageNumber: fromPage)
        usecase.start()
    }
    
    private func navigateTo() {
        let newView = state.candidatesViewState
        switch newView {
        case .detailCandidateView:
            print("pop")
        case .addCandidate(let addCandidateState):
            print("go away")
        default:
            break
        }
    }
    
}
