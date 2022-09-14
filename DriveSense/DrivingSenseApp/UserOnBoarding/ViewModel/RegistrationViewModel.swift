//
//  RegistrationViewModel.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import Foundation
class RegistrationViewModel: ObservableObject {
    @Published var instructor: Instructor
    @Published var loading = false
    @Published var error = ""
    @Published var navigation = NavigationModel.none
    @Published var type = RegistertionTypeError.none
    
    enum RegistertionTypeError {
        case invalidName
        case invalidEmail
        case invalidPassword
        case invalidAddress
        case invalidPostCode
        case invalidADINo
        case invalidexprie
        case serverRespons
        case none
    }
    
    init () {
        instructor = .init()
    }
    
    //MARK: perfrom Registertion Action
    func RegisterNewUser() {
        
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
}
struct ApprovedDrivingInstuctor: Codable, Equatable {
    var no: String
    var expiryDate: Date
    init () {
        no = ""
        expiryDate = .now
    }
}
