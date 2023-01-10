//
//  AddCandidatePresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/10/22.
//
import Foundation
class AddCandidatePresenter: ObservableObject {
    
    @Published var state: AddCandidateState
    @Published var candidate: Candidate
    @Published var showError: Bool = false
    private let actionDispatcher: ActionDispatcher
    
    /// Use Case
    private let makeEnrollCandidateUseCaseFactory: EnrollNewCandidateFactory
    
    init(state: AddCandidateState,
         makeEnrollCandidateUseCaseFactory: EnrollNewCandidateFactory,
         actionDispatcher: ActionDispatcher) {
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.candidate = state.candidate
        self.showError = !state.errorToPresent.isEmpty
        self.makeEnrollCandidateUseCaseFactory = makeEnrollCandidateUseCaseFactory
    }
    
    private func validateModel() {
        var errorMessage = ErrorMessage(title: "Waring", message: "")
        if candidate.name != "" {
            if candidate.postcode != "" {
                if candidate.address1 != "" {
                    let model = candidate.convertToModel()
                    let useCase = makeEnrollCandidateUseCaseFactory
                        .makeEnrollNewCandidateUseCase(candidate: model)
                    useCase.start()
                } else {
                    errorMessage.message = "Please enter an valid Address"
                    boardCastError(errorMessage)
                }
            } else {
                errorMessage.message = "Please enter an valid Postcode"
                boardCastError(errorMessage)
            }
        } else {
            errorMessage.message = "Please enter an valid name"
            boardCastError(errorMessage)
        }
    }
    
    func sendAction(_ action: Action) {
        actionDispatcher.dispatch(action)
    }
    
    func enrollCandidate() {
          validateModel()
    }
    
    private func boardCastError( _ error: ErrorMessage) {
        let action = AddCandidateAction.FinishedWithError(error: error)
        sendAction(action)
    }
    
}
