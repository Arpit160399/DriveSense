//
//  MainView.swift
//  DriveSense
//
//  Created by Arpit Singh on 27/08/22.
//

import SwiftUI


struct MainView: View {
    @ObservedObject var dispatcher: MainViewPresenter
    var state: LaunchingState { dispatcher.getState() }
    var body: some View {
//        NavigationView {
            ContentView()
            .onAppear {
                dispatcher.checkForUser()
            }.fullScreenCover(isPresented: $dispatcher.navigation.isDisplayed,
             content: {
                NavigationView {
                    dispatcher.navigation.destination
                    .navigationBarHidden(true)
                }
            })
//        }
        .alert(isPresented: $dispatcher.showError) {
            Alert(title: Text(state.errorPresent.first?.title ?? ""),
                  message: Text(state.errorPresent.first?.message ?? "")
                  ,dismissButton: .cancel({
                let error = state.errorPresent.first
                if let error = error {
                  dispatcher.finishedPresenting(error: error)
                }
            }))
//            let error = state.errorPresent.first
//         return Alert(title: Text(error?.title ?? ""),
//                  message: Text(error?.message ?? ""),
//                  dismissButton: .cancel(Text("Ok"), action: {
//                if let error = error {
//                    dispatcher.finishedPresenting(error: error)
//                }
//            }))
        }
    }
    
}
