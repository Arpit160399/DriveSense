//
//  TestBoardView.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/08/22.
//

import SwiftUI

struct TestBoardView: View {
    @State var currentSpeed = "0"
    @State var distance = "0"
    @State var showTestBoard = false
    var body: some View {
        VStack {
            HStack {
            Button  {
                
            } label: {
              Image(systemName:  "chevron.left")
                    .resizable()
                    .font(.systemTitle)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25, alignment: .center)
            }
             Text("Driving Mock Test")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .heavy,
                              design: .default))
             
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal)
            HStack {
             SpeedOMeter()
             .frame(width: 230, height: 230, alignment: .center)
             .overlay(
                VStack {
                    Spacer()
                    Text("Speed").font(.system(size: 23, weight: .heavy, design: .default))
                    HStack(spacing: 0) {
                     RollingMeter(value: $currentSpeed,color: .white)
                     Text(" (mph)").font(.system(size: 13, weight: .heavy, design: .default))
                    }
                }.foregroundColor(.white)
                    .padding(.bottom,25)
               )
            }
            .padding()
            .background(Color.appOrange)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -3)
            .padding(.horizontal)
            HStack(alignment: .center) {
            RoadView()
            .frame(width: 300,height: 200, alignment: .center)
            .overlay(
//            .padding(.top,231)
                VStack {
                    Spacer()
            DisplayValue
                .onTapGesture {
                    currentSpeed = String(Int.random(in: 0..<160))
                    distance = String(format: "%.2f",Double.random(in: 0..<20))
            }
            
                }
            )
                
//                .padding(.bottom,10)
            }.padding()
            Spacer()
            Button {
                showTestBoard.toggle()
            } label: {
               Text("Test Sheet")
            }.buttonStyle(PrimaryButton(loading: .constant(false),
                image: "doc.plaintext.fill"))
            .padding()
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.appOrangeLevel.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showTestBoard) {
            DrivingAssisgmentForme()
        }
    }
    var DisplayValue: some View {
        VStack {
//            VStack {
//                Text("Speed").font(.system(size: 23, weight: .heavy, design: .default))
//                HStack(spacing: 0) {
//                 RollingMeter(value: $currentSpeed,color: .white)
//                 Text(" (mph)").font(.system(size: 13, weight: .heavy, design: .default))
//                }
//            }
//            Spacer()
            VStack {
                Text("Trip").font(.system(size: 23, weight: .heavy, design: .default))
                HStack(spacing: 0) {
                RollingMeter(value: $distance,color: .white)
                Text(" (Miles)").font(.system(size: 13, weight: .heavy, design: .default))
                }
            }
        }
        .padding([.horizontal,.bottom])
        .foregroundColor(.white)
    }
}

struct TestBoardView_Previews: PreviewProvider {
    static var previews: some View {
        TestBoardView()
    }
}
