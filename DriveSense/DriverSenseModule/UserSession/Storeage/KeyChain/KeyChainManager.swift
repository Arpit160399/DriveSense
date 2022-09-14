//
//  KeyChainManager.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
class KeyChainManager {
    
    //MARK: - Custom Error
    enum KeyChainErrors: Error {
      case undefined
      case typeMismatch
    }
    
    //MARK: - Methods
    
    /// finding element from Keychain
   static func findItem(query: KeyChainQuery) throws -> Data? {
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { output in
            SecItemCopyMatching(query.map(), output)
        }
        if status == errSecItemNotFound {
            return nil
        }
        if status != noErr  {
            throw KeyChainErrors.undefined
        }
        guard let item = result as? Data else {
            throw KeyChainErrors.typeMismatch
       }
        return item
    }
    
    ///  Remove the item From Keychain
    static func delete(value: KeyChainValue) throws {
        let status = SecItemDelete(value.map())
        guard status == noErr || status == errSecItemNotFound else {
            throw KeyChainErrors.undefined
        }
    }
    
    /// Update Value in Keychain
    static func update(value: KeyChainForData) throws {
        let status = SecItemUpdate(value.attribMap(), value.dataMap())
        guard status == noErr else {
            throw KeyChainErrors.undefined
        }
    }
    
    
    /// Saving Data into Keychain
    static func save(value: KeyChainForData) throws {
        let status = SecItemAdd(value.map(), nil)
        guard status == noErr else {
            throw KeyChainErrors.undefined
        }
    }
    
}
