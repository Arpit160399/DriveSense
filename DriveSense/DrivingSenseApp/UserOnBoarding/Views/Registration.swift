//
//  Registration.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI

struct Registration: View {
    @ObservedObject var store: RegistrationPresenter
    var state: RegisterState {
        store.state
    }
    @State var animation: Bool = false
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.appOrangeLevel.edgesIgnoringSafeArea(.all)
            backGroungAnimation
         VStack {
             HStack {
                 Button {
                     let action = OnBoardingActions.GoToSignIn()
                     store.send(action: action)
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

                    Spacer()
                    
                    Button {
                        store.registerNewUser()
                    } label: {
                        Text("Register")
                    }.buttonStyle(PrimaryButton(loading: $store.state.isLoading,
                                                image: "lock.doc.fill"))
                        .frame(width: 150)
                }
            }
          }
        }
        .alert(isPresented: $store.showError) {
            let error = state.errorToPresent.first
            return Alert(title: Text(error?.title ?? ""),
                         message: Text(error?.message ?? ""),
                         dismissButton: .cancel(Text("ok"),
                         action: {
                if let error = error {
                    let action = RegisterAction
                        .RegistrationErrorPresented(error: error)
                    store.send(action: action)
                }
            }))
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
                       value: $store.instructor.name).padding(.top)
            Divider()
            .padding(.leading,20)
            InputField(placeHolder: "Email",example: "harry@gamil.com",
                       value: $store.instructor.email)
            Divider()
            .padding(.leading,20)
            InputField(placeHolder: "Address",example: "12 avenue street blue park flat 5",
                       value: $store.instructor.address)
            Divider()
            .padding(.leading,20)
            Section {
            InputField(placeHolder: "Password",example: "******",
                       value: $store.password)
            Divider()
            .padding(.leading,20)
            InputField(placeHolder: "Post Code",example: "RH1 233",
                       value: $store.instructor.postCode)
            Divider()
            .padding(.leading,20)
            InputField(placeHolder: "ADI No",example: "435127",
                       value: $store.instructor.ADI.no)
            }
            Divider()
            .padding(.leading,20)
                DatePicker("Expires",
            selection: $store.instructor.ADI.expiryDate,
                in: Date.now...,
                           displayedComponents:[.date])
                .datePickerStyle(.automatic)
                    .colorInvert()
                    .colorMultiply(.white)
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
            VStack {
                if let placeHolder = placeHolder, placeHolder.lowercased().contains("password") {
                    SecureField(placeHolder, text: $value)
                        .font(.systemSubTitle)
                } else {
                    TextField("\(placeHolder ?? "")", text: $value)
                        .font(.systemSubTitle)
                }
            } .foregroundColor(.white)
                .padding(.horizontal,20)
                .padding(.vertical,5)
        }
    
    }
}
