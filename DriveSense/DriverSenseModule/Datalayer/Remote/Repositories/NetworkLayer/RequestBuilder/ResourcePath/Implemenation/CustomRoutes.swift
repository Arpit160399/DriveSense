//
//  CustomRoutes.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation
struct CustomRoutes: ResourcePath {
    var path: String
    
    init(path: String) {
        self.path = path
    }

    func getURL() -> URLComponents {
        var components = URLComponents()
        components.host = env.baseURL
        if path.first == Character("/") {
            components.path = path
        } else {
            components.path = "/" + path
        }
        return components
    }
}
