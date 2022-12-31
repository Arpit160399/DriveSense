//
//  AssessmentDetailView.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/12/22.
//
import MapKit
import SwiftUI

struct AssessmentDetailView: View {

    @ObservedObject var store: AssessmentDetailPresenter
    
    private var feedback: TestMark {
        return store.testMark
    }
    
    private let height: CGFloat = 270
    private let offsetY: CGFloat = 65
    
    var body: some View {
        VStack {
            HeaderView(title: "Assessment ") {
                let action = AssessmentListAction.AssessmentListDismissView()
                store.send(action)
            }.padding(.bottom, offsetY)
            ZStack(alignment: .top) {
                feedbackView
                    .frame(height: store.switchCard ? 600 : height)
                    .offset(y: store.switchCard ? offsetY : 0)
                   .zIndex(store.switchCard ? 1 : 0)
                    .onTapGesture {
                        if !store.switchCard {
                            store.updateView()
                        }
                    }
                testBasicInfo
                    .offset(y: store.switchCard ? 0 : offsetY)
                    .zIndex(store.switchCard ? 0 : 1)
                    .onTapGesture {
                        if store.switchCard {
                            store.updateView()
                        }
                    }
                      
            }.animation(.spring(), value: store.switchCard)
            Spacer()
        }.background(Color.appOrangeLevel
            .edgesIgnoringSafeArea(.all))
            .alert(isPresented: $store.showError, content: {
                let errorMessage = store.state.errorToPresent.first
                return Alert(title: Text(errorMessage?.title ?? ""),
                             message: Text(errorMessage?.message ?? ""),
                             dismissButton: Alert.Button.cancel(Text("ok"), action: {
                                 if let error = errorMessage {
                                     let action = AssessmentDetailAction.PresentedError(error: error)
                                     store.send(action)
                                 }
                             }))
            })
            .onAppear {
                store.fetchSensorData()
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("")
    }
    
    var testBasicInfo: some View {
        VStack {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Image(systemName: "qrcode")) ID")
                            .foregroundColor(.gray)
                        Text(store.assessment.id.uuidString)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("\(Image(systemName: "calendar")) Held On")
                            .foregroundColor(.gray)
                        Text(store.assessment.createdAt?.formatter(type: "dd MMM yyy") ?? "")
                    }
                    
                }.font(.systemCaption2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Number of Fault")
                        .font(.systemTitle2)
                    HStack(spacing: 15) {
                        VStack(spacing: 5) {
                            Text("\(Image(systemName: "light.beacon.min.fill")) Major")
                                .foregroundColor(.red)
                            Text("\(feedback.totalMajorFault)")
                        }.font(.systemSubTitle)
                        VStack(spacing: 5) {
                            Text("\(Image(systemName: "minus.diamond.fill")) Minor")
                                .foregroundColor(.yellow)
                            Text("\(feedback.totalMinorFault)")
                        }.font(.systemSubTitle)
                        Spacer()
                    }
                }
                       
                HStack(spacing: 5) {
                    Text("\(Image(systemName: "speedometer")) Candidate maintained an average speed of")
                        + Text(" \(String(format: "%.1f", store.assessment.avgSpeed ?? 0)) mph")
                        .foregroundColor(.black)
                    Spacer()
                }
                .foregroundColor(.gray)
                .font(.systemCaption2)
                HStack(spacing: 5) {
                    Text("\(Image(systemName: "car.rear.and.tire.marks")) The total distance traveled is ")
                        + Text(" \(String(format: "%.1f", store.assessment.totalDistance ?? 0)) miles")
                        .foregroundColor(.black)
                    Spacer()
                }
                .foregroundColor(.gray)
                .font(.systemCaption2)
                HStack(spacing: 5) {
                    Text("\(Image(systemName: "clock.fill")) Complete duration of test was")
                        + Text(" \(store.getTestDuration()) minutes")
                        .foregroundColor(.black)
                    Spacer()
                }
                .foregroundColor(.gray)
                .font(.systemCaption2)
                
            }.padding()
                .foregroundColor(.black)
        if store.state.loading {
                Rectangle()
                    .fill(Color.white)
                    .overlay {
                        ActivityLoader(color: .black)
                            .frame(width: 50)
                    }
                    .frame(height: 300)
            }
            
            if !store.state.places.isEmpty {
                Map(coordinateRegion: $store.region,
                    annotationItems: store.places) { place in
                        MapAnnotation(coordinate: place.location) {
                            Rectangle()
                                .fill(Color.appOrange)
                                .frame(width: 20, height: 20)
                        }
                    }
                    .frame(height: 300)
                    .cornerRadius(5)
//                    .disabled(true)
            }
        }.background(Color.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.3), radius: 3)
    }
    
    var feedbackView: some View {
        VStack(alignment: .leading) {
            Text("FeedBack")
                .foregroundColor(.white)
                .font(.systemTitle)
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Group {
                        feedBackFiled("Use Of Speed", feedback.useofSpeed)
                        feedBackFiled("Following Distance", feedback.followingDistance)
                        feedBackFiled("Reverse Park", feedback.reversePark)
                    }
                    Group {
                        Text("Progress")
                            .font(.systemTitle2)
                            .padding(.vertical, 8)
                        Group {
                            feedBackFiled("Appropriated Speed", feedback.progress.appropriatedSpeed)
                            feedBackFiled("Undue Hesitation", feedback.progress.undueHesitation)
                        }
                        Text("Control")
                            .font(.systemTitle2)
                            .padding(.vertical, 8)
                        Group {
                            feedBackFiled("Acceleration", feedback.control.acceleation)
                            feedBackFiled("Foot Break", feedback.control.footBreak)
                            feedBackFiled("Clutch", feedback.control.clutch)
                            feedBackFiled("Gear", feedback.control.gear)
                            feedBackFiled("Steering", feedback.control.steering)
                            feedBackFiled("Parking Break", feedback.control.parkingBreak)
                        }
                        Text("Move Off")
                            .font(.systemTitle2)
                            .padding(.vertical, 8)
                        Group {
                            feedBackFiled("Control", feedback.moveOff.control)
                            feedBackFiled("Safety", feedback.moveOff.safety)
                        }
                        Text("Judgement")
                            .font(.systemTitle2)
                            .padding(.vertical, 8)
                        Group {
                            feedBackFiled("Crossing", feedback.judgement.crossing)
                            feedBackFiled("Meeting", feedback.judgement.meeting)
                            feedBackFiled("Overtaking", feedback.judgement.overtaking)
                        }
                        Text("Junctions")
                            .font(.systemTitle2)
                            .padding(.vertical, 8)
                        Group {
                            feedBackFiled("Approaching Speed", feedback.junctions.approachingSpeed)
                            feedBackFiled("Cutting Corner", feedback.junctions.cutingCorner)
                            feedBackFiled("Observation", feedback.junctions.observation)
                            feedBackFiled("Turning Left", feedback.junctions.turningLeft)
                            feedBackFiled("Turning Right", feedback.junctions.turningRight)
                        }
                    }
                    Text("Positioning")
                        .font(.systemTitle2)
                        .padding(.vertical, 8)
                    Group {
                        feedBackFiled("Lane Discipline", feedback.positioning.laneDiscipline)
                        feedBackFiled("Normal Driving", feedback.positioning.normalDriving)
                    }
                }
                .padding([.bottom], 20)
                .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.appOrange)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.3), radius: 3)
        .padding([.horizontal])
    }
    


    func feedBackFiled(_ title: String, _ value: Conclusion) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.appOrangeLevel)
            HStack {
                Text(title)
                    .font(.systemSubTitle)
                Spacer()
                Text("\(Image(systemName: value == .perfect ? "checkmark.circle.fill" : "multiply.circle.fill")) \(value.rawValue)")
                    .font(.systemCaption)
                    .foregroundColor(value == .perfect ? .white : .red)
            }.foregroundColor(.white)
                .padding()
        }
    }
}
