//
//  AssessmentListView.swift
//  DriveSense
//
//  Created by Arpit Singh on 24/10/22.
//

import SwiftUI
struct AssessmentListView: View {
    @ObservedObject var store: AssessmentDetailPresenter
    var body: some View {
        VStack {
            HStack(spacing: 7) {
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
                }
               Text("Assessments")
                    .font(.system(size: 22, weight: .heavy,
                                  design: .default))
                    .foregroundColor(.white)
               Spacer()
            }.padding(.horizontal)
            ZStack {
                ScrollView {
                    LazyVStack {
                        
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                       Spacer()
                        Button {
                            store.conductMockTest()
                        } label: {
                            Circle()
                            .fill(Color.appCyan)
                            .shadow(color: Color.appCyan.opacity(0.4),radius: 5,x: -0.5 ,y: 0.4)
                            .overlay {
                                Image(systemName: "chart.bar.doc.horizontal.fill")
                                    .foregroundColor(.white)
                                    .imageScale(.medium)
                            }
                            .frame(width: 50)
                        }
                    }
                }.padding()
            }
        }
        .background(Color.appOrangeLevel.edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden()
    }
}

