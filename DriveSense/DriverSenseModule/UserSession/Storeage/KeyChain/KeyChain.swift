//
//  KeyChain.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//

import Foundation
class KeyChainValue {
    
    // MARK: - Properties
    let name: NSString = "Driver.sense.key.store"
    let className = kSecClass as String
    let service = kSecAttrService as String
    
    //  MARK: - Methods
    func map() -> CFDictionary {
        let item : [String: AnyObject] = [className: kSecClassGenericPassword,service: name]
        return item as CFDictionary
    }
}

class KeyChainForData: KeyChainValue {
     
    // MARK: - Properties
    let data: AnyObject
    let key = kSecValueData as String
    
    init(data: Data) {
        self.data = data as AnyObject
    }
    
    //  MARK: - Methods
    override func map() -> CFDictionary {
        let item : [String: AnyObject] = [className: kSecClassGenericPassword,
                                          service: name,
                                          key: data]
        return item as CFDictionary
    }
    
    func attribMap() -> CFDictionary {
        let item: [String: AnyObject] = [className: kSecClassGenericPassword,
                                        service: name]
        return item as CFDictionary
    }
    
    func dataMap() -> CFDictionary {
        let item: [String: AnyObject] = [className: kSecClassGenericPassword,
                                        key: data]
        return item as CFDictionary
    }
    
}

class KeyChainQuery: KeyChainValue {
    
    // MARK: - Properties
    let limit = kSecMatchLimit as String
    let returnData = kSecReturnData as String
    
    //  MARK: - Methods
    override func map() -> CFDictionary {
        let item: [String : AnyObject] = [className: kSecClassGenericPassword,
                                          service: name,
                                          limit: kSecMatchLimitOne,
                                          returnData: kCFBooleanTrue]
        return  item as CFDictionary
    }
    
}
