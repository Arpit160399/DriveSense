//
//  SettingsState.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
struct SettingsState: Equatable {
    var enableSensorDataCollection: Bool
    var loading: Bool
    var errorPresent:Set<ErrorMessage>
    
    init(enableSensorDataCollection: Bool, loading: Bool = false, errorPresent: Set<ErrorMessage> = Set<ErrorMessage>()) {
        self.enableSensorDataCollection = enableSensorDataCollection
        self.loading = loading
        self.errorPresent = errorPresent
    }
}
