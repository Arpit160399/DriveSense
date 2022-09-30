//
//  RegistrationViewModel.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import Foundation
class RegistrationPresenter : ObservableObject {
    @Published var instructor: Instructor
    @Published var showError = false
    @Published var password: Secret = ""
    
    @Published var state: RegisterState
    let actionDispatcher: ActionDispatcher
    let makeSignUpUseCaseFactor: SignUpUseCaseFactory
    
    init (state: RegisterState,
          actionDispatcher: ActionDispatcher,
          makeSignUpUseCaseFactor: SignUpUseCaseFactory) {
          instructor = .init()
        self.state = state
        self.actionDispatcher = actionDispatcher
        self.makeSignUpUseCaseFactor = makeSignUpUseCaseFactor
        showError = !state.errorToPresent.isEmpty
    }
    
    //MARK: perfrom Registertion Action
    func RegisterNewUser() {
        var model = instructor.convertToModel()
        model.password = password
        let useCase = makeSignUpUseCaseFactor
            .makeSignUpUseCase(newInstructor: model)
        useCase.start()
    }
    
    func send(action: Action) {
        actionDispatcher.dispatch(action)
    }
    
}

public struct Instructor: Codable, Equatable {
    var name: String
    var email: String
    var postCode: String
    var address: String
    var ADI: ApprovedDrivingInstuctor
    init() {
        name = ""
        email = ""
        postCode = ""
        address = ""
        ADI = .init()
    }
    func convertToModel() -> InstructorModel {
        .init(id: UUID(),name: name,email: email,
              postcode: postCode,
              address: address,adi: ADI.convertToModel())
    }
}
struct ApprovedDrivingInstuctor: Codable, Equatable {
    var no: String
    var expiryDate: Date
    init () {
        no = ""
        expiryDate = .now
    }
    func convertToModel() -> ADIModel {
        return .init(no: no,
                     expiryDate: "\(expiryDate.timeIntervalSince1970)")
    }
}
