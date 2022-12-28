//
//  CandidateListPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//

import Combine
import SwiftUI
class CandidateListPresenter: ObservableObject {
    
      @Published var candidates: [CandidatesModel]
      @Published var navigationMode: NavigationModel = .none
      @Published var state: SignedInState
      @Published var showError = false
      @Published var query: String {
        didSet {
            subject.send(query)
        }
     }
      
      private var task = Set<AnyCancellable>()
      private var subject = PassthroughSubject<String,Never>()
    
      private let actionDispatcher: ActionDispatcher
    
      /// Use case Factory
      private let fetchCandidateListUseCaseFactory: FetchCandidateUseCaseFactory
      private let searchCandidateUserCaseFactory: SearchForCandidateUseCaseFactory
    
      /// Child  Views
      private let addCandidateFactory: (AddCandidateState) -> AddCandidateView
      private let settingsViewFactory: (SettingsState) -> SettingsView
      private let assessmentDetailFactory: (AssessmentListState,CandidatesModel) -> AssessmentListView
  
    
    init(state: SignedInState,
         actionDispatcher: ActionDispatcher,
         addCandidateFactory: @escaping (AddCandidateState) -> AddCandidateView,
         settingsViewFactory: @escaping (SettingsState) -> SettingsView,
         assessmentDetailFactory:@escaping (AssessmentListState,CandidatesModel) -> AssessmentListView,
         fetchCandidateListFactory: FetchCandidateUseCaseFactory,
         searchCandidateUserCaseFactory: SearchForCandidateUseCaseFactory) {
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.fetchCandidateListUseCaseFactory = fetchCandidateListFactory
        self.addCandidateFactory = addCandidateFactory
        self.assessmentDetailFactory = assessmentDetailFactory
        self.searchCandidateUserCaseFactory = searchCandidateUserCaseFactory
        self.candidates = Array(state.candidates)
        self.showError = !state.errorToPresent.isEmpty
        self.settingsViewFactory = settingsViewFactory
        self.query = state.searchText
//        $query
//        .debounce(for: .seconds(1), scheduler: RunLoop.main)
//        .sink { (output: String) in
//
//        }
//        .store(in: &task)
//
        subject
        .debounce(for: .seconds(1.2), scheduler: DispatchQueue.main)
        .sink { _ in
            self.getCandidatesList(fromPage: 0)
        }.store(in: &task)
        navigateTo()
      }

     func send(_ action: Action) {
         actionDispatcher.dispatch(action)
    }
    
    func enrollNewCandidate() {
        let action = SignedInAction.AddNewCandidate()
        send(action)
    }
    
    fileprivate func searchForCandidateBy(_ name: String,_ page: Int) {
        guard name != "" else {return}
        let useCase = searchCandidateUserCaseFactory
            .makeSearchForCandidateUserCase(query: name, page: page)
        useCase.start()
    }
    
    func getCandidatesList(fromPage: Int) {
        if query == "" {
            let usecase = fetchCandidateListUseCaseFactory
                .makeFetchCandidateUseCase(pageNumber: fromPage)
            usecase.start()
        } else {
            searchForCandidateBy(query,fromPage)
        }
    }
    
    private func navigateTo() {
        let newView = state.candidatesViewState
        switch newView {
        case .assessmentDetail(let assessmentState):
            let view = AnyView(assessmentDetailFactory(assessmentState,assessmentState.candidate))
            navigationMode = .init(isDisplayed: true,destination: view)
        case .addCandidate(let addCandidateState):
            navigationMode = .init(isDisplayed: false,
                                   destination: AnyView(addCandidateFactory(addCandidateState)),
                                   showModel: true)
        case .setting(let settingsState):
            navigationMode = .init(isDisplayed: true,
                                   destination: AnyView(settingsViewFactory(settingsState)))
        default:
            break
        }
    }
    
    func presentSetting() {
        let toggleState = UserDefaults.standard.bool(forKey: ConstantValue.EnableSensorKey)
        let action = SignedInAction.PresentSettings(toggleState: toggleState)
        actionDispatcher.dispatch(action)
    }

}
