//
//  RequestBuilder.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

protocol RequestBuilder {
    func getRequest() -> URLRequest
}
