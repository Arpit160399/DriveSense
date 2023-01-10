//
//  SettingsPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/10/22.
//

import Combine
import Foundation

class SettingsPresenter: ObservableObject {
    
    @Published var state: SettingsState
    
    @Published var toggleSensorData: Bool {
        didSet {
            toggleSensorDataCollection()
        }
    }
    
    private var user: InstructorModel
    
    private var actionDispatcher: ActionDispatcher
    
    /// Use case
    private let signoutUseCaseFactory: SignoutUsecaseFactory
    
    init(state: SettingsState,
         user: InstructorModel,
         actionDispatcher: ActionDispatcher,
         signoutUseCseFactory: SignoutUsecaseFactory) {
        self.state = state
        self.toggleSensorData = state.enableSensorDataCollection
        self.user = user
        self.signoutUseCaseFactory = signoutUseCseFactory
        self.actionDispatcher = actionDispatcher
    }
    
    func getInstructor() -> InstructorModel {
        return user
    }
    
    func send(_ action: Action) {
        actionDispatcher.dispatch(action)
    }
    
    func toggleSensorDataCollection() {
        UserDefaults.standard.set(toggleSensorData, forKey: ConstantValue.EnableSensorKey)
    }
    
    func signOutUser() {
        let useCase = signoutUseCaseFactory.makeSignoutUseCase()
        useCase.start()
    }
    
}
