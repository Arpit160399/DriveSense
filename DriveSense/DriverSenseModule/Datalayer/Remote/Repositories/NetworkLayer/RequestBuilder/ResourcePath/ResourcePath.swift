//
//  ResourcePath.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/08/22.
//

import Foundation

protocol ResourcePath {
    var env: Environment { get }
    var auth: String { get }
    func getURL() -> URLComponents
}

extension ResourcePath {
    // Default Environment
    var env: Environment {
        return .production
    }
    // Default auth token as None
    var auth: String {
        return ""
    }
}

// MARK: - Environment Condition for Remote URL

enum Environment: CaseIterable {
    case development
    case production
}

extension Environment {
    var baseURL: String {
        switch self {
        case .development:
            let url = Bundle.main.object(forInfoDictionaryKey: "Base_URL_Staging") as? String ?? ""
            return url
        case .production:
            let url = Bundle.main.object(forInfoDictionaryKey: "Base_URL_Pro") as? String ?? ""
            return url
        }
    }
}
