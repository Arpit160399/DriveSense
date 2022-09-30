//
//  NavigationModel.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//
import SwiftUI
import Foundation
struct NavigationModel {
    var isDisplayed: Bool
    var destination: AnyView?
    var showModel: Bool = false
    static var none = NavigationModel(isDisplayed: false)
}
