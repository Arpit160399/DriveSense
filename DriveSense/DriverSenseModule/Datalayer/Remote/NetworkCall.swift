//
//  File.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/08/22.
//
import Combine
import Foundation

class NetworkCall {
    // default session
    var session: URLSession
    
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Codable>(_ request: RequestBuilder) -> AnyPublisher<T,NetworkError> {
        let task = request.getRequest()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return session.dataTaskPublisher(for: task)
            .tryMap { output -> T in
                guard let reps = output.response as? HTTPURLResponse else {
                    throw NetworkError.NetworkFailure
                }
                if reps.statusCode == 200 {
                    let data = try decoder.decode(T.self,
                                              from: output.data)
                    return data
                } else {
                    let data = try decoder.decode(ErrorResponse.self,
                                              from: output.data)
                    throw NetworkError.ServerWith(data)
               }
            }.mapError({ error in
                guard let err = error as? NetworkError else {
                    return NetworkError.InvalidResponse(error)
                }
                 return err
            }).eraseToAnyPublisher()
    }
    
}
