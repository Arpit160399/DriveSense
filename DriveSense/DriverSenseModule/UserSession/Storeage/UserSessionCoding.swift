//
//  UserSessionCoding.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
public protocol UserSessionCoding {
    func encode(userSession: UserSession) -> Data?
    func decode(data: Data) -> UserSession?
}
