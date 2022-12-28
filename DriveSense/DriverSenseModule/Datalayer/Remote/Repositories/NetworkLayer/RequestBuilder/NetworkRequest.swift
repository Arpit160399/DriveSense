//
//  NetworkRequest.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/08/22.
//

import Foundation

/// HTTP Request Methods
enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkRequest: RequestBuilder {
    
    // MARK: - Properties
    var request: URLRequest
    var method: HTTPMethods
    var data: Data?

    
    // MARK: - methods
    /// creating a network request  without Payload Request
    /// - Parameters:
    ///   - url: The http request path in which network request need to be done
    ///   - method: in which http method the request need to constructed upon
    ///   - query: it expects an collection of key value pairs which are then append as the query parameter for current request
    init(url: ResourcePath ,method: HTTPMethods,query: [String: String]? = nil) throws {
        var currentRequest = url.getURL()
        currentRequest.queryItems = NetworkRequest.appendQueryItems(query)
        guard let uri = currentRequest.url else {
            throw NetworkError.invalidURl
        }
        request = URLRequest(url: uri)
        request.addValue(url.auth, forHTTPHeaderField: "Authorization")
        self.method = method
    }
    
    /// creating a network request with Payload Request
    /// - Parameters:
    ///   - url: The http request path in which network request need to be done
    ///   - method: in which http method the request need to constructed upon
    ///   - payload: is data set that will be append to http body as payload  when network request is made
    ///   - query: it expects an collection of key value pairs which are then append as the query parameter for current request
    convenience init <T: Encodable>(url: ResourcePath ,
                                    method: HTTPMethods,payload: T,
                                    query: [String: String]? = nil) throws {
        let encoder =  JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        try self.init(url: url, method: method, query: query)
        data = try encoder.encode(payload)
    }
    
    fileprivate static func appendQueryItems(_ query: [String : String]?) -> [URLQueryItem]? {
        var queryList:  [URLQueryItem]?
        if let query = query {
            query.forEach { (key,value) in
                if queryList == nil {
                    queryList = [.init(name: key, value: value)]
                } else {
                    queryList?.append(.init(name: key, value: value))
                }
            }
        }
        return queryList
    }
    
    func getRequest() -> URLRequest {
        request.httpMethod = method.rawValue
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
