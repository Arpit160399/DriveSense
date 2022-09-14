//
//  WaveIcon.swift
//  DriveSense
//
//  Created by Arpit Singh on 15/07/22.
//

import SwiftUI

struct WaveIcon: View {
    @State var animation: Bool = false
    @State var topCrurve: CGFloat = 0
    @State var middleCurve: CGFloat = 0
    @State var bottomCurve: CGFloat = 0
    var stroke: CGFloat = 10
    var showPoint: Bool = true
    var color: Color = .orange
    var body: some View {
    GeometryReader { proxy in
        ZStack(alignment: .bottom) {
            let size = proxy.size
            let box = (size.height > size.width ? size.width : size.height)
            Arc(startAngle: .init(degrees: -10), endAngle: .init(degrees: 190), clockwise: true)
                .stroke(color.opacity(topCrurve), lineWidth: stroke)
                .frame(width: box, height: box, alignment: .center)
      
                .animation(
                    .linear(duration:1
                           ).delay(0.7).repeatForever(autoreverses: false), value: topCrurve)
            Arc(startAngle: .init(degrees: -20), endAngle: .init(degrees: 200), clockwise: true)
                .stroke(color.opacity(middleCurve), lineWidth: stroke)
                .frame(width: box * 0.8, height: box * 0.8, alignment: .center)
                .animation(.linear(duration: 0.8)
                    .delay(0.5)
                .repeatForever(autoreverses: false), value: middleCurve)
            Arc(startAngle: .init(degrees: -30), endAngle: .init(degrees: 210), clockwise: true)
                .stroke(color.opacity(bottomCurve), lineWidth: stroke)
                .frame(width: box * 0.6, height: box * 0.6, alignment: .center)
                .animation(.linear(duration: 0.5).delay(0.2)
                    .repeatForever(autoreverses: false), value: bottomCurve)
            if showPoint {
                Circle()
                    .fill(color)
                    .frame(width: box * 0.3, height: box * 0.5, alignment: .center)
             }
          }
    }.onAppear {
        if animation {
         topCrurve = 1
         middleCurve = 1
         bottomCurve = 1
         }
     }
   }
}


struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return path
    }
}
struct WaveIcon_Previews: PreviewProvider {
    static var previews: some View {
        WaveIcon(animation: true)
            .frame(width: 200, height: 200, alignment: .center)
    }
}
