//
//  AssessmentListView.swift
//  DriveSense
//
//  Created by Arpit Singh on 24/10/22.
//

import SwiftUI
struct AssessmentListView: View {
    @ObservedObject var store: AssessmentListPresenter
    var body: some View {
        VStack {
            NavigationLink(isActive: $store.navigation.isDisplayed, destination: {
                store.navigation.destination
            }, label: {}).hidden()
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
                        ForEach(store.assessment.indices,id: \.self) { index in
                            let assessment = store.assessment[index]
                            AssessmentCard(assessment: assessment)
                                .onAppear {
                                    if index == store.assessment.count - 1 {
                                        store
                                        .getAssessmentFor(page: store.state.page + 1)
                                    }
                                }
                        }
                    }.padding(.vertical)
                    if store.state.loading {
                        ActivityLoader(color: .white)
                            .frame(width: 55,height: 55)
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
        .alert(isPresented: $store.showError, content: {
            let errorMessage = store.state.errorPresenter.first
            return Alert(title: Text(errorMessage?.title ?? ""),
                      message: Text(errorMessage?.message ?? ""),
                      dismissButton: Alert.Button.cancel(Text("ok"), action: {
                    if let error = errorMessage {
                        let action = AssessmentListAction.PresentedError(error: error)
                        store.send(action)
                    }
            }))
        })
        .navigationBarBackButtonHidden()
        .onAppear {
            if store.state.assessment.isEmpty {
                store.getAssessmentFor(page: 0)
            }
        }
    }
}
