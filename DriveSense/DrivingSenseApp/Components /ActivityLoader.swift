//
//  ActivityLoader.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI
struct ActivityLoader: View {
    @State var angle: Int = 0
    var color = Color.black
    var stroke: CGFloat = 8
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 8)
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(color,style: .init(lineWidth: stroke, lineCap: .round))
                .rotationEffect(Angle(degrees: Double(angle)))
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: false), value: angle)
        }.padding()
            .onAppear(perform: {
                 startLoader()
            })
    }
    
    fileprivate func startLoader() {
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            angle = angle == 360 ? -10 : 360
//        }
    }
}

struct Preview_ActivityLoader: PreviewProvider {
    static var previews: some View {
        ActivityLoader()
    }
}
