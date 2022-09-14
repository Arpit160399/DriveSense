//
//  Session.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
public struct Session: Codable,Equatable {
    let refreshToken: Token
    let accessToken: Token
    
    init(auth: Token,refresh: Token) {
        accessToken = auth
        refreshToken = refresh
    }
    
}
