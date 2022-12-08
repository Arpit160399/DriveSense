//
//  RequestBuilder.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

/// Is Interface for aggregating all request building parameter in it like request method , payload , query parameter and endpoints
protocol RequestBuilder {
    /// Provides an  appropriate URL Request instances which constructed using all parameter passed into request builder.
    /// - Returns: Instance of URL Request.
    func getRequest() -> URLRequest
}
