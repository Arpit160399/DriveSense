//
//  Registration.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI

struct Registration: View {
    @Binding var stateCurrent: UserOnBoarding.UserOnBoardingState
    @ObservedObject var viewModel: RegistrationViewModel
    @State var animation: Bool = false
    var body: some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(isActive: $viewModel.navigation.isDisplayed) {
                viewModel.navigation.destination
            } label: {}
            Color.appOrangeLevel.edgesIgnoringSafeArea(.all)
            backGroungAnimation
         VStack {
             HStack {
                 Button {
                     stateCurrent = .Login
                 } label: {
                    Image(systemName: "chevron.left")
                         .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .font(.systemCaption)
                .frame(width: 25, height: 25, alignment: .center)
                .padding([.leading])
                 }
            Text("Registration")
                 .foregroundColor(.white)
                 .font(.system(size: 22, weight: .heavy,
                              design: .default))
                 .frame(maxWidth: .infinity, alignment: .leading)
                 .padding(.horizontal,7)
                 Spacer()
            }
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                            Circle()
                            .fill(Color.appOrange.opacity(0.9))
                                .frame(width: 140, height: 140, alignment: .top)
                                .overlay(Image(systemName: "person.crop.square.filled.and.at.rectangle.fill").resizable().aspectRatio(contentMode: .fit).padding(40).foregroundColor(.white))
                        Spacer()
                    }
                    formInputSection.offset(y: -50)
                    if viewModel.type != .none {
                        Text("\(viewModel.error)")
                            .foregroundColor(.red)
                            .font(.systemTitle2)
                    }
                    Spacer()
                    
                    Button {
                        viewModel.RegisterNewUser()
                    } label: {
                        Text("Register")
                    }.buttonStyle(PrimaryButton(loading: $viewModel.loading,image: "lock.doc.fill"))
                        .frame(width: 150)
                }
            }
          }
        }
    }
    var backGroungAnimation: some View {
        VStack {
            HStack {
            Spacer()
        Circle()
            .fill(.white.opacity(0.3))
            .frame(width: 170, height: 170,
                   alignment: .center)
            .rotationEffect(Angle(degrees: animation ? 360 : 0), anchor: .trailing)
            .offset(x: 20)
            }
         Spacer()
            HStack {
            Circle()
                .fill(.white.opacity(0.3))
                .frame(width: 170, height: 170,
                       alignment: .center)
                .rotationEffect(Angle(degrees: animation ? 360 : 0), anchor: .leading)
                .offset(x: -20)
                Spacer()
            }
         Spacer()
        }.animation(.linear(duration: 60).repeatForever(autoreverses: false), value: animation)
        .onAppear {
                animation.toggle()
        }
    }

    var formInputSection: some View {
        VStack {
            InputField(placeHolder: "Name",example: "harry",
                       value: $viewModel.instructor.name).padding(.top)
            Divider()
            .background(viewModel.type != .invalidName ? .clear : .red)
            .padding(.leading,20)
            InputField(placeHolder: "Email",example: "harry@gamil.com",
            value: $viewModel.instructor.email)
            Divider()
            .background(viewModel.type != .invalidEmail ? .clear : .red)
            .padding(.leading,20)
            InputField(placeHolder: "Adddress",example: "12 aven street blue park flat 5",
            value: $viewModel.instructor.address)
            Divider()
                .background(viewModel.type != .invalidAddress ? .clear : .red)
            .padding(.leading,20)
            Section {
            InputField(placeHolder: "Post Code",example: "RH1 233",
                       value: $viewModel.instructor.postCode)
            Divider()
                    .background(viewModel.type != .invalidPostCode ? .clear : .red)
            .padding(.leading,20)
            InputField(placeHolder: "ADI No",example: "435127",
                       value: $viewModel.instructor.ADI.no)
            }
            Divider()
            .background(viewModel.type != .invalidADINo ? .clear : .red)
            .padding(.leading,20)
                DatePicker("Expires",
            selection: $viewModel.instructor.ADI.expiryDate,
                in: Date.now...,
                           displayedComponents:[.date])
                .datePickerStyle(.automatic)
                    .colorInvert()
                    .colorMultiply( viewModel.type != .invalidexprie ? .white : .red)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.bottom)

        }
        .background(Color.appOrange)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 2)
        .padding()
    }
}

struct InputField: View {
    var placeHolder: String?
    var example: String?
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
//            if let lable = placeHolder {
//                Text(lable)
//                    .font(.subheadline)
//                    .foregroundColor(.white)
//            }
            TextField("\(placeHolder ?? "")", text: $value)
                .font(.systemSubTitle)
                .foregroundColor(.white)
                .padding(.horizontal,20)
                .padding(.vertical,5)
        }
    
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration(stateCurrent: .constant(.Login),
            viewModel: .init())
    }
}
