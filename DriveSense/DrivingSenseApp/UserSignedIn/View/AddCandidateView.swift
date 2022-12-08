//
//  addCandidateView.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/10/22.
//

import SwiftUI
struct AddCandidateView: View {
    
    @ObservedObject var store: AddCandidatePresenter
    
    var body: some View {
            ZStack {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // TODO: - Dismiss Action
                        let action = SignedInAction.DismissCurrentView()
                        store.sendAction(action)
                    }
                VStack(alignment: .leading) {
                    Text("Add Canditates")
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .heavy, design: .default))
                        .padding(.horizontal)
                Section {
                    InputField(placeHolder: "Name", value: $store.candidate.name)
                    Divider()
                        .padding(.horizontal)
                    DatePicker("Date Of Birth",selection: $store.candidate.dob
                               ,in:Date(timeIntervalSince1970: 9911223)...Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 - 568080000),displayedComponents:[.date])
                        .datePickerStyle(.automatic)
                        .colorInvert()
                        .colorMultiply(.white)
                        .font(.systemSubTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                    Divider()
                        .padding(.horizontal)
                    InputField(placeHolder: "Postcode", value: $store.candidate.postcode)
                    Divider()
                        .padding(.horizontal)
                    InputField(placeHolder: "Address", value: $store.candidate.address1)
                    Divider()
                        .padding(.horizontal)
                    InputField(placeHolder: "Address Line 2 (Optional)",
                               value: $store.candidate.address2)
                    Divider()
                        .padding(.horizontal)
                    }
                    HStack {
                        Spacer()
                    Button {
                       //TODO: - Enrolling Candidate under Instructor
                        store.enrollCandidate()
                    } label: {
                        Text("Add")
                    }.buttonStyle(PrimaryButton(loading: $store.state.loading,
                                                image: "doc.fill.badge.plus"))
                        .frame(width: 100)
                    }.padding(.vertical)
                }.padding()
                .background(Color.appOrangeLevel)
                .cornerRadius(8)
                .padding(.horizontal)
            }.alert(isPresented: $store.showError) {
                let errorMessage = store.state.errorToPresent.first
                return Alert(title: Text(errorMessage?.title ?? ""),
                          message: Text(errorMessage?.message ?? ""),
                          dismissButton: Alert.Button.cancel(Text("ok"), action: {
                        if let error = errorMessage {
                            let action = AddCandidateAction.PresentedError(error: error)
                            store.sendAction(action)
                        }
                    }))
            }
    }
}
