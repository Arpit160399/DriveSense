//
//  SettingsView.swift
//  DriveSense
//
//  Created by Arpit Singh on 14/10/22.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var store: SettingsPresenter
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    let action = SignedInAction.DismissCurrentView()
                    store.send(action)
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .font(.systemCaption)
                        .frame(width: 25, height: 25, alignment: .center)
                        .padding([.leading])
                }
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.system(size: 22, weight: .heavy,
                                  design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal,7)
                Spacer()
            }
                Circle()
                .fill(Color.appOrange)
                .overlay {
                    Image(systemName:  "person.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .padding()
                }.frame(width: 80,height: 80)
            Text(store.getInstructor().name ?? "Unknow")
                .foregroundColor(.white)
                .font(.systemTitle)
            VStack(spacing: 0) {
                HStack {
                    Text("Sensor Data Collection")
                        .foregroundColor(.white)
                        .font(.systemTitle2)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    Toggle(isOn: $store.toggleSensorData, label: {})
                        .frame(width: 45)
                }.padding(.vertical,7)
                .padding(.horizontal)
                Divider().padding(.horizontal)
                Button {
                    store.signOutUser()
                } label: {
                    HStack {
                        Spacer()
                        Text("Sign Out")
                            .foregroundColor(.appPeach)
                            .font(.systemTitle2)
                        Spacer()
                    }
                    .padding(.vertical,15)
                }
            }
            .background(Color.appOrange)
            .cornerRadius(7)
            .padding(.horizontal)
            Spacer()
        }
        .background(Color.appOrangeLevel.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

