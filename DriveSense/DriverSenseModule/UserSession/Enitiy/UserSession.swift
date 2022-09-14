//
//  UserSession.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
public class UserSession: Codable {
   public var user: InstructorModel
   public var session: Session
    
   public init(user: InstructorModel,session: Session) {
        self.user = user
        self.session = session
    }
}

extension UserSession: Equatable {
    static public func == (lhs: UserSession, rhs: UserSession) -> Bool {
        return lhs.session == rhs.session &&
               lhs.user == rhs.user
    }
}
