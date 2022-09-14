//
//  Login.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI

struct Login: View {
    @Binding var stateCurrent: UserOnBoarding.UserOnBoardingState
    @ObservedObject var viewModel: LoginViewModel
    @State var floating =  false
    var body: some View {
        ZStack {
            NavigationLink(isActive: $viewModel.navigation.isDisplayed) {
                viewModel.navigation.destination
            } label: {}
            Color.appOrangeLevel.ignoresSafeArea()
    
        VStack(spacing: 10) {
                    topFrame
                    inputSection
                     .offset(y: -50)
                if viewModel.type != .none {
                    Text("dadada\(viewModel.error)")
                        .font(.systemSubTitle)
                        .foregroundColor(Color.red)
                        .frame(maxWidth: .infinity,
                               alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                }
                Spacer()
                bottomSection
            }
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
                    .overlay(Image(systemName: "mail").foregroundColor( viewModel.type == .invalidUserName ? .red : .white ))
                TextField("Email", text: $viewModel.user.email)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
            }.padding(.top, 7).padding(.horizontal)
            Divider().padding(.leading, 50)
            HStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.appOrange)
                    .shadow(color: Color.black.opacity(0.12), radius: 2, x: 0, y: 0)
                    .frame(width: 35, height: 35, alignment: .center)
                    .overlay(Image(systemName: "lock.fill").foregroundColor( viewModel.type == .invalidPassword ? .red : .white ))
                TextField("Password", text: $viewModel.user.password)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
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
                stateCurrent = .Registration
            } label: {
                Text("Wanna Sign Up ?")
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
            }
            Spacer()
            Button {
                viewModel.loginUser()
            } label: {
             Text("Login")
            }.buttonStyle(
                PrimaryButton(loading: $viewModel.loading,
                image: "chevron.right")
            ).frame(width: 120)
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
            }
    }
}



struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(stateCurrent: .constant(.Registration),
            viewModel: .init())
    }
}
