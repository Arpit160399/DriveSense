//
//  SecuredRoutes.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

struct SecuredRoute: ResourcePath {
    var auth: String
    var path: SecurePath
    var id: String?
    
    init(endpoint: SecurePath,auth: String,id: String? = nil) {
        self.id = id
        self.auth = auth
        self.path = endpoint
    }
    
    func getURL() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = env.baseURL
        let stringPath = id == nil ? path.rawValue : path.rawValue + "/\(id ?? "")"
        components.path = stringPath
        return components
    }
}
