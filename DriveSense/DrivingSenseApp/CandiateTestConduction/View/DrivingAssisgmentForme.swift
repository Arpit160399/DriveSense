//
//  DrivingAssisgmentForme.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/07/22.
//

import SwiftUI

struct DrivingAssessmentForm: View {
    
    @Binding var testMark: TestMark
    var saveAction: (TestMark) -> Void
    var onChange: (TestMark) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
        Color.appOrangeLevel.ignoresSafeArea(.all)
        VStack {
            Text("Driving Assessment")
                .font(.system(size: 20,
                              weight: .bold,
                              design: .default))
                .padding(.top,50)
            ScrollView {
             VStack(spacing: 0) {
              firstSection
              FormSection(title: "Progress", fields: [
              ("Appropriated Speed",
               $testMark.progress.appropriatedSpeed),
              ("Undue hesitation",
               $testMark.progress.undueHesitation)])
                FormSection(title: "Control", fields: [
                    ("Acceleation",$testMark.control.acceleation),
                    ("FootBreak",$testMark.control.footBreak),
                    ("Steering",$testMark.control.steering),
                    ("ParkingBreak",$testMark.control.parkingBreak),
                    ("Clutch",$testMark.control.clutch),
                    ("Gear",$testMark.control.gear)
                ])
                FormSection(title: "Move Off",
                            fields: [
                             ("Control",
                              $testMark.moveOff.control),
                             ("Safety",
                              $testMark.moveOff.safety)
                            ])
                FormSection(title: "Juctions",
                            fields: [
                       ("Approaching Speed",
                       $testMark.junctions.approachingSpeed),
                       ("Cuting Corner",
                       $testMark.junctions.cutingCorner),
                       ("Observation",
                        $testMark.junctions.observation),
                       ("Turning Left",
                        $testMark.junctions.turningLeft),
                       ("Turning Right",
                        $testMark.junctions.turningRight)])
                FormSection(title: "Judgement",
                            fields: [
                    ("Overtaking",$testMark.judgement.overtaking),
                    ("Crossing",$testMark.judgement.crossing),
                    ("Meeting",$testMark.judgement.meeting)
                             ])
                FormSection(title: "Positioning",
                            fields: [
            ("Lane Discipline",
                     $testMark.positioning.laneDiscipline),
            ("Normal Driving",
                     $testMark.positioning.normalDriving)
                            ])
                 
              }.padding(.bottom,40)
            }.padding(.top).edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
        .cornerRadius(2)
        .padding(.horizontal)
        .padding(.top,90)
        Image("clipBoard")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 80, height: 80, alignment: .center)
        .padding(.top,40)
        RoundedRectangle(cornerRadius: 6)
        .foregroundColor(.white)
        .frame(width: 60, height: 5, alignment: .center)
        .padding(.vertical)
        }.onChange(of: testMark, perform: { newValue in
            onChange(newValue)
        }).onDisappear {
            saveAction(testMark)
        }
    }
    
    var firstSection: some View {
        Section {
        FormInputSection(title: "Use Of Speed",
                         checkState: $testMark.useofSpeed)
            .padding(.horizontal)
        Divider()
            .padding()
        FormInputSection(title: "Following Distance",
                         checkState: $testMark.followingDistance)
            .padding(.horizontal)
         Divider()
                .padding()
        FormInputSection(title: "Reverse Park",
                         checkState: $testMark.reversePark)
                .padding(.horizontal)
            
        }
    }
    
}

struct FormSection: View {
    var title: String
    var fields: [(String,Binding<Conclusion>)]
    var body: some View {
        VStack(alignment: .leading) {
           Text("\(title)")
                .font(.system(size: 17, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.horizontal)
                .padding(.vertical,5)
                .background(Color.black)
                .padding(.vertical)
            ForEach(0..<fields.count,id: \.self) { index in
                if index != 0 {
                    Divider()
                }
              let value = fields[index]
                FormInputSection(title: value.0,
                                 checkState: value.1)
                .padding(.horizontal)
               
            }
        }
    }
}

struct FormInputSection: View {
    var title: String
    @Binding var checkState: Conclusion
    var body : some View {
     HStack(alignment: .center) {
            Text("\(title)")
                .font(.system(size: 15,
                              weight: .semibold,
                              design: .default))
                .foregroundColor(.black)
                .padding(.top,10)
            Spacer()
            HStack {
                VStack(spacing: 1) {
               Text("Minor")
                .font(.system(size: 12,
                                      weight: .regular,
                                      design: .default))
                   Button {
                       updateValue(.minor)
                   } label: {
                       checkBox(isChecked: checkState == .minor)
                   }
               }
                VStack(spacing: 1) {
               Text("Major")
                  .font(.system(size: 12,weight: .regular,
                                design: .default))
                   Button {
                       updateValue(.major)
                    } label: {
                       checkBox(isChecked: checkState == .major)
                   }
               }
            }
        }
    }
    
    fileprivate func checkBox(isChecked: Bool) -> some View {
        ZStack {
            Rectangle()
                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                .padding(5)
            if isChecked {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }.frame(width: 50,height: 50, alignment: .center)
    }
    
    fileprivate func updateValue(_ current: Conclusion) {
        if checkState == current {
            checkState = .perfect
        } else {
       
            checkState = current
        }
    }
}
