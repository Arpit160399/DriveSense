//
//  AddNewCandidate.swift
//  DriveSense
//
//  Created by Arpit Singh on 21/09/22.
//

import Foundation
struct AddCandidateState: Equatable {
     var errorToPresent = Set<ErrorMessage>()
     var loading: Bool
     var candidate: Candidate
}
struct Candidate: Equatable {
    var name: String
    var dob: Date
    var postcode: String
    var address1: String
    var address2: String
    
    init() {
        name = ""
        dob = Date()
        postcode = ""
        address1 = ""
        address2 = ""
    }
    
    init(name: String, dob: Date, postcode: String, address1: String, address2: String) {
        self.name = name
        self.dob = dob
        self.postcode = postcode
        self.address1 = address1
        self.address2 = address2
    }
}
