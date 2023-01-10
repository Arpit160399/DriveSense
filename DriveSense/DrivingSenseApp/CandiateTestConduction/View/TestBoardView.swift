//
//  TestBoardView.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/08/22.
//

import SwiftUI

struct TestBoardView: View {
    
    @ObservedObject var store: TestViewPresenter
    @State var showPopup = false
    
    var body: some View {
        VStack {
            switch store.state.viewState {
            case .initial:
                initial
            case .consentForm:
                VStack {
                    headerView("Drive Sense App") {
                        dismiss()
                    }
                    ConsentForm {
                        let action = MockTestAction.AcceptedPolicy()
                        store.send(action)
                    } decline: {
                        dismiss()
                    }
                }
            default:
                ZStack {
                    mainTestBoard
                    if showPopup {
                        Group {
                            Rectangle()
                                .fill(Color.black.opacity(0.5))
                                .edgesIgnoringSafeArea(.all)
                            waringPopup
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.appOrangeLevel.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $store.presentTestBoard) {
            DrivingAssessmentForm(testMark: $store.testFeedback) { feedback in
                let action = MockTestAction.DismissTestBoard(feedback: feedback.convertToFeedbackModel())
                store.send(action)
            } onChange: { testMark in
                let action = MockTestAction.UpdateFeedBackState(feedback: testMark.convertToFeedbackModel())
                store.send(action)
           }
        }
        .alert(isPresented: $store.showError, content: {
            let errorMessage = store.state.errorToPresent.first
            return Alert(title: Text(errorMessage?.title ?? ""),
                         message: Text(errorMessage?.message ?? ""),
                         dismissButton: Alert.Button.cancel(Text("ok"), action: {
                             if let error = errorMessage {
                                 let action = MockTestAction.PresentedError(error: error)
                                 store.send(action)
                             }
                         }))
        })
        .onAppear {}
        .navigationBarBackButtonHidden()
    }
    
    var initial: some View {
        VStack {
            headerView("Mock Test") {
                dismiss()
            }
            Spacer()
            Button {
                store.createAssessment()
            } label: {
                Text("Start Test")
            }.buttonStyle(PrimaryButton(loading: $store.state.loading))
                .padding()
            Spacer()
        }
    }
    
    var mainTestBoard: some View {
        VStack {
            headerView("Driving Mock Test") {
                showPopup = true
            }
            HStack {
                SpeedMeasurement(currentSpeed: store.state.currentSpeed)
            }
            .padding()
            .background(Color.appOrange)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -3)
            .padding(.horizontal)
            HStack(alignment: .center) {
                RoadView(direction: store.getCurrentDirection(value:   store.state.currentDirection))
                    .frame(width: 300, height: 200, alignment: .center)
                    .overlay(
                        VStack {
                            Spacer()
                            displayValue
                        }
                    )
            }.padding()
            Spacer()
            Button {
                let action = MockTestAction.PresentTestBoard()
                store.send(action)
            } label: {
                Text("Test Sheet")
            }.buttonStyle(PrimaryButton(loading: .constant(false),
                                        image: "doc.plaintext.fill"))
                .padding()
        }
    }
    
    var waringPopup: some View {
        VStack {
            if case .none = store.state.testOperation {
                Text("Are you sure you want end the current Mock test ?")
                    .font(.systemCaption2)
                    .foregroundColor(.black)
                    .padding(.vertical)
                HStack {
                    Button {
                        store.update()
                    } label: {
                        Text("Yes")
                    }.buttonStyle(PrimaryButton(loading: .constant(false), color: .appPeach))
                    Spacer()
                    Button {
                        showPopup = false
                    } label: {
                        Text("No")
                    }.buttonStyle(PrimaryButton(loading: .constant(false)))
                }
            } else {
                Text("Please wait saving the current mock test..")
                    .font(.systemCaption2)
                    .foregroundColor(.black)
                    .padding(.vertical)
                ActivityLoader(color: .black)
                    .frame(width: 50)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
    }
    
    var displayValue: some View {
        VStack {
            VStack {
                Text("Trip").font(.system(size: 23, weight: .heavy, design: .default))
                HStack(spacing: 0) {
                    RollingMeter(value: $store.state.currentDistance, color: .white)
                    Text("(Miles)").font(.system(size: 13, weight: .heavy, design: .default))
                }
            }
        }
        .padding([.horizontal, .bottom])
        .foregroundColor(.white)
    }
    
    fileprivate func headerView(_ title: String, _ action: @escaping () -> Void) -> some View {
        return HStack {
            Button {
                action()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .font(.systemTitle)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .heavy,
                              design: .default))
            
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.horizontal)
    }
    
    fileprivate func dismiss() {
        let action = AssessmentListAction.AssessmentListDismissView()
        store.send(action)
    }
}

struct SpeedMeasurement: View {
    
    var currentSpeed: Double
    @State var prevSpeed: Double = 0
    
    var body: some View {
        SpeedOMeter(speed: $prevSpeed)
            .frame(width: 230, height: 230, alignment: .center)
            .overlay(
                VStack {
                    Spacer()
                    Text("Speed").font(.system(size: 23, weight: .heavy, design: .default))
                    HStack(spacing: 0) {
                        RollingMeter(value: $prevSpeed,color: .white)
                        Text(" (mph)").font(.system(size: 13, weight: .heavy, design: .default))
                    }
                }.foregroundColor(.white)
                    .padding(.bottom, 25)
            )
            .onChange(of: currentSpeed) { newValue in
                  prevSpeed = newValue
            }
     }

}
struct HeaderView: View {
    var title: String
    var action: () -> Void
    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .font(.systemTitle)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25, alignment: .center)
            }
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .heavy,
                              design: .default))
            
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.horizontal)
    }
}
