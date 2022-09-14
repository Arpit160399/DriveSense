//
//  RoadView.swift
//  DriveSense
//
//  Created by Arpit Singh on 19/07/22.
//

import SwiftUI

enum CarDirection: Double {
//    case left = "arrow.left"
//    case right = "arrow.right"
//    case forward = "arrow.up"
//    case backward = "arrow.down"
        case left = 90
        case right = -90
        case forward = 0
        case backward = 180
}




struct RoadView: View {
    @State var moveing: CGFloat = -300
    @State var direction: CarDirection = .left
    var body: some View {
     ZStack {
            Trapezium()
               .fill(Color.black.opacity(0.5))
               .padding(.horizontal,40)
            .overlay(Rectangle()
             .fill(Color.white)
             .frame(width: 10,height: 50, alignment: .center)
             .offset(y: moveing)).clipped().onAppear(perform: {
            withAnimation(.linear.speed(0.2).repeatForever(autoreverses: false), {
                moveing = 300
            })
        })
         Image(systemName: "arrow.up")
             .aspectRatio(contentMode: .fit)
             .font(.system(size: 35,weight: .heavy, design: .default))
             .foregroundColor(.white)
             .rotationEffect(.degrees(direction.rawValue), anchor: .center)
             .rotation3DEffect(.degrees(40), axis: (x: 1, y: 0, z: 0))
             
             .onTapGesture {
                 let setdirection: [CarDirection]  = [.left , .right , .backward,.forward]
                 withAnimation(.linear) {
                     direction = setdirection[Int.random(in: 0..<setdirection.count)]
                 }
        }
     }
   }
}

struct RoadView_Previews: PreviewProvider {
    static var previews: some View {
        RoadView()
    }
}
