//
//  UserOnBoarding.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import SwiftUI

struct UserOnBoarding: View {
    @ObservedObject var store: UserOnBoardingPresenter
    var body: some View {
        store.getCurrentView()
    }
}
