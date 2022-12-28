//
//  File.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/08/22.
//
import Combine
import Foundation

class NetworkCall: NetworkManager {
    /// default session
    var session: URLSession
    
    init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T: Codable>(_ request: RequestBuilder) -> AnyPublisher<T,NetworkError> {
        let task = request.getRequest()
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        print(task,String(data:task.httpBody ?? Data(),encoding: .utf8))
        return session.dataTaskPublisher(for: task)
            .tryMap { output -> T in
                guard let reps = output.response as? HTTPURLResponse else {
                    throw NetworkError.networkFailure
                }
                print(String(data: output.data,encoding: .utf8))
                if reps.statusCode == 200 {
                    let data = try decoder.decode(DataBinder<T>.self,
                                                  from: output.data).data
                    return data
                } else {
                    let data = try decoder.decode(ErrorResponse.self,
                                              from: output.data)
                    throw NetworkError.serverWith(data)
               }
            }.mapError({ error in
                guard let err = error as? NetworkError else {
                    print(error)
                    return NetworkError.invalidResponse(error)
                }
                 return err
            }).eraseToAnyPublisher()
    }
    
}
