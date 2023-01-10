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
        dob = Date(timeIntervalSince1970: ConstantValue.defaultDateOfBrith)
        postcode = ""
        address1 = ""
        address2 = ""
    }
    
    init(model: CandidatesModel) {
        self.name = model.name ?? ""
        self.dob = Date(timeIntervalSince1970: model.dateOfBirth ?? ConstantValue.defaultDateOfBrith)
        if let address = model.address?.split(separator: "\n") {
        self.postcode = String(address[address.count - 1])
        self.address1 = String(address[0])
        if address.count > 2 {
            self.address2 = String(address[1])
        } else {
            self.address2 = ""
        }
       } else {
           self.postcode = ""
           self.address1 = ""
           self.address2 = ""
      }
    }
    
    init(name: String, dob: Date, postcode: String, address1: String, address2: String) {
        self.name = name
        self.dob = dob
        self.postcode = postcode
        self.address1 = address1
        self.address2 = address2
    }
    
    func convertToModel() -> CandidatesModel {
        var model = CandidatesModel(id: UUID())
        model.address = address1
        if address2 != "" {
            model.address = "\(address1)\n\(address2)\n\(postcode)"
        } else {
            model.address = "\(address1)\n\(postcode)"
        }
        model.createdAt = Date.now.timeIntervalSince1970
        model.dateOfBirth = dob.timeIntervalSince1970
        model.name = name
        return model
    }
}
