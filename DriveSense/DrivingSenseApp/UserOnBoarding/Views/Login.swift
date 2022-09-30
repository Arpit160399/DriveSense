//
//  Login.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI

struct Login: View {
    @ObservedObject var store: LoginViewPresenter
    var state: LoginState {
       return store.state
    }
    @State var floating = false
 
    var body: some View {
        ZStack {
        Color.appOrangeLevel.ignoresSafeArea()
        VStack(spacing: 10) {
                    topFrame
                    inputSection
                     .offset(y: -50)
//             if store.showError  {
//                    Text("dadada\(viewModel.error)")
//                        .font(.systemSubTitle)
//                        .foregroundColor(Color.red)
//                        .frame(maxWidth: .infinity,
//                               alignment: .leading)
//                        .padding(.horizontal)
//                        .padding(.top)
//                }
                Spacer()
                bottomSection
            }
        }.alert(isPresented: $store.showError) {
            let error = state.errorsToShow.first
            return Alert(title: Text(error?.title ?? ""),
                  message: Text(error?.message ?? ""),
                  dismissButton: .cancel(Text("ok"), action: {
                if let error = error {
                    store.send(action: LoginAction
                        .SignInErrorPresented(error: error))
                }
            }))
        }
    }

    var inputSection: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.appOrange)
                    .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 0)
                    .frame(width: 35, height: 35,
                           alignment: .center)
                    .overlay(Image(systemName: "mail").foregroundColor( .white ))
                TextField("Email", text: $store.email)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .disabled(state.viewState.isEmailInputDisable)
            }.padding(.top, 7).padding(.horizontal)
            Divider().padding(.leading, 50)
            HStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.appOrange)
                    .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 0)
                    .frame(width: 35, height: 35, alignment: .center)
                    .overlay(Image(systemName: "lock.fill").foregroundColor(.white ))
                SecureField("Password", text: $store.password)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .disabled(state.viewState.isPasswordDisable)
            }.padding(.bottom, 7).padding(.horizontal)
        }
        .background(Color.appOrange)
        .cornerRadius(30)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: -2)
        .padding(.horizontal)
    }
    var bottomSection: some View {
        HStack {
            Button {
                let action = OnBoardingActions.goToSignUp()
                store.send(action: action)
            } label: {
                Text("Wanna Sign Up ?")
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
            }
            Spacer()
         
            Button {
                store.loginUser()
            } label: {
             Text("Login")
            }
            .buttonStyle(
                PrimaryButton(loading: $store.state.viewState.isLoading,
                image: "chevron.right")
            )
//            .disabled(state.viewState.isLoginButtonDisable)
            .frame(width: 120)
        }.padding()
    }
    var topFrame: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0.0, y: 1)
                .overlay(
                    ZStack(alignment: .topLeading) {
                      VStack {
                        Spacer()
                         Image("Background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay(Image("BannerIcon").resizable().aspectRatio(contentMode: .fit))
                    }.padding(.bottom,50)
                      Circle()
                      .fill(Color.appOrangeLevel.opacity(0.5))
                      .frame(width: 250,height: 250, alignment: .center)
                      .rotationEffect(Angle(degrees: floating ? 360 : 0),anchor: .trailing)
                      .animation(.linear(duration: 90).repeatForever(autoreverses: false), value: floating)
                    }
                ).clipped()
            Text("Drive Sense")
                .font(.system(size: 28, weight: .heavy, design: .default))
                .padding()
        }.frame(height: 340, alignment: .center)
            .onAppear {
                floating.toggle()
//                store.showError = !state.errorsToShow.isEmpty
            }
    }
}
