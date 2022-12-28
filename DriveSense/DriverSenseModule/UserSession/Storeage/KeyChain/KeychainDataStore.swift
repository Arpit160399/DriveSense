//
//  KeychainDataStore.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//
import Combine
import Foundation
public class KeychainUserSessionDataStore: UserSessionManager {
    
    // MARK: - Properties
    var userSession: UserSessionCoding
    
    // MARK: - Methods
    public init(coder: UserSessionCoding) {
        userSession = coder
    }
    
    func getUser() -> AnyPublisher<UserSession?, Error> {
        return Future { promise in
            self.fetchSyncUserSession(promise)
        }.subscribe(on: DispatchQueue.global()).eraseToAnyPublisher()
    }
    
    func clearSession() -> AnyPublisher<Void, Error> {
        return Future { promise in
            let item = KeyChainValue()
            do {
                try KeyChainManager.delete(value: item)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.subscribe(on: DispatchQueue.global()).eraseToAnyPublisher()
    }
    
    func createSessionFor(user: UserSession) -> AnyPublisher<UserSession, Error> {
        guard let data = userSession.encode(userSession: user) else {
            return Fail(error: KeyChainManager.KeyChainErrors.undefined).eraseToAnyPublisher()
        }
       return clearSession()
            .flatMap { () -> AnyPublisher<UserSession,Error> in
            let item = KeyChainForData(data: data)
                return self.getUser()
                .tryMap { userSession  in
                if userSession != nil {
                     try KeyChainManager.update(value: item)
                 } else {
                     try KeyChainManager.save(value: item)
                 }
                return user
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

}

extension KeychainUserSessionDataStore {
    private func fetchSyncUserSession(_ promise: (Result<UserSession?,Error>) -> Void ) {
        do {
            let query = KeyChainQuery()
            if let data = try KeyChainManager.findItem(query: query),
               let user = userSession.decode(data: data) {
                promise(.success(user))
            } else {
                promise(.success(nil))
            }
        } catch {
            promise(.failure(error))
        }
    }
}
