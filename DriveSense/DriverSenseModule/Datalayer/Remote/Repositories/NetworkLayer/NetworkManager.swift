//
//  NetworkManager.swift
//  DriveSense
//
//  Created by Arpit Singh on 05/11/22.
//
import Combine
import Foundation
protocol NetworkManager {
    
    /// Performs network request using instance of requestBuilder that has be pass to it.
    /// - Parameter request: is Bundle formate of all required for request parameter in it including payload.
    /// - Returns: a publisher which will notify with expected value on success otherwise in case of failure with network error type error.
    func fetch<T: Codable>(_ request: RequestBuilder) -> AnyPublisher<T,NetworkError>
}
