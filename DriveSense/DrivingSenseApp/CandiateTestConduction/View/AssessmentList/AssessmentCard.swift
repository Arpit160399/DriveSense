//
//  AssessmentCard.swift
//  DriveSense
//
//  Created by Arpit Singh on 22/12/22.
//

import SwiftUI

struct AssessmentCard: View {
    
    var assessment: AssessmentModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ZStack {
                    let status = getProgressBarStatus()
                    Circle()
                        .fill(Color.appOrange)
                        .shadow(color: .appOrangeLevel, radius: 2)
                    Circle()
                        .trim(from: 0, to: status.1)
                        .stroke(status.0, style: .init(lineWidth: 8, lineCap: .round))
                        .shadow(color: status.0.opacity(0.8), radius: 1.5)
                        .rotationEffect(.degrees(-100))
                }
                .overlay {
                    VStack(spacing: 3) {
                        Text(calculateMistake())
                            .font(.systemTitle)
                            .foregroundColor(.white)
                        Rectangle()
                            .frame(height: 1)
                            .padding(.horizontal)
                            .foregroundColor(.white.opacity(0.8))
                        Text("15")
                            .font(.systemCaption2)
                            .foregroundColor(.white.opacity(0.8))
                    }.rotationEffect(.degrees(-10))
                }
                .frame(width: 80, height: 80)
                Spacer()
                HStack {
//        Image(systemName: "doc.text.below.ecg.fill")
//                    .resizable()
//                   .aspectRatio( contentMode: .fit)
//                   .frame(width: 50)
//                   .foregroundColor(.white)
                    let major = Int(assessment.feedback?.totalMajorFault ?? 0)
                    VStack(spacing: 8) {
                        Text(" \(Image(systemName: "light.beacon.min.fill")) Total Major fault : \(major)")
                            .foregroundColor(  major > 0 ? .red : .white)
                            .shadow(color: (major > 0 ? Color.red : .white).opacity(0.4), radius: 2)
                        let minor = Int(assessment.feedback?.totalMinorFault ?? 0)
                        Text("\(Image(systemName: "minus.diamond.fill")) Total Minor fault : \(minor)")
                            .foregroundColor(minor > 0 ? .red : .white)
                            .shadow(color: (minor > 0 ? Color.red : .white).opacity(0.4), radius: 2)
                    }.font(.systemCaption)
                }
            }.padding()
                .background(Color.appOrange)
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading,spacing: 6) {
                        Text("Assessment ID")
                            .font(.systemTitle)
                        Text(assessment.id.uuidString)
                            .font(.systemCaption2)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(Image(systemName: "clock.fill")) \(assessment.createdAt?.formatter(type: "dd MMM yyy") ?? "")")
                            .font(.systemCaption2)
                            .foregroundColor(.gray)
                }
               
                HStack {
                    Text("\(Image(systemName: "speedometer")) \(String(format: "%.1f",assessment.avgSpeed ?? 0)) Miles/Hr")
                    Spacer()
                    Text("\(Image(systemName: "car.rear.and.tire.marks")) \(String(format: "%.1f",assessment.totalDistance ?? 0)) Miles")
                   
                }.font(.systemCaption)
            }
            .padding()
            .background(Color.white)
//            .shadow(radius: 3,x: 0,y: -2)
        }
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 4)
        .padding(.horizontal)
        .foregroundColor(.black)
    }
    
    
    func calculateMistake() -> String {
        let allowedMistake = 15
        let current = allowedMistake - Int(assessment.feedback?.totalFaults ?? 0)
        return "\(current)"
    }
    
    func getProgressBarStatus() -> (Color,CGFloat) {
        let mistake = 15 - Int(assessment.feedback?.totalFaults ?? 0)
        let percent = (CGFloat(mistake) / CGFloat(15))
        switch mistake {
        case _ where mistake < 5 :
            return (Color.red,1)
        case _ where mistake < 10 :
            return (Color.yellow,percent)
        default :
            return (Color.green,percent)
        }
    }
    
}
