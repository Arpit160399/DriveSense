//
//  UserSessionEncoder.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
public class UserSessionPropertyListCoding: UserSessionCoding {
   
    public init() {}
    
    // MARK: - Methods
    
    public func encode(userSession: UserSession) -> Data? {
            let data = try? PropertyListEncoder().encode(userSession)
            return data
    }
    
    public func decode(data: Data) -> UserSession? {
        let user = try? PropertyListDecoder().decode(UserSession.self, from: data)
        return user
    }
    
}
