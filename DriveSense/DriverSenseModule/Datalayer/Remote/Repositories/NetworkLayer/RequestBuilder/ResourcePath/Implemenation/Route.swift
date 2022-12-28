//
//  Routes.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation
struct Route: ResourcePath {
     var path: Endpoint
     var id: String?
    
    init(_ endpoint: Endpoint , id: String? = nil) {
        self.id = id
        self.path = endpoint
    }
    
    func getURL() -> URLComponents {
        var component = URLComponents()
        component.scheme = "https"
        component.host = env.baseURL
        let stringPath = id == nil ? path.rawValue : path.rawValue + "/\(id ?? "")"
        component.path = stringPath
        return component
    }
}
