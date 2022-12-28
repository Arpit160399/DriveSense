//
//  SpeedOMeter.swift
//  DriveSense
//
//  Created by Arpit Singh on 19/07/22.
//

import SwiftUI

struct SpeedOMeter: View {
    
    @Binding var speed: Double
    
    var body: some View {
    ZStack {
        Circle()
        .trim(from: 0.5, to: 1)
        .fill(Color.black.opacity(0.5))
        .overlay(
         ZStack{
            let collect = createDrivion()
            ForEach(collect.indices,
                    id: \.self) { index in
                HStack {
                let current = collect[index]
                Rectangle()
                    .fill(Color.white)
                    .frame(width: current % 20 == 0 ? 10 : 5, height: 1, alignment: .center)
                 if current % 20 == 0 {
                  Text("\(current)")
                         .font(.system(size: 9,
                                       weight: .semibold,
                                       design: .default))
                  .foregroundColor(.white)
                  .rotationEffect(.degrees( -1 * Double(180 / collect.count * index + 10)))
                 }
                Spacer()
                }.rotationEffect(.degrees(Double(180 / collect.count * index)))
            }
         }.rotationEffect(.degrees(10))
        ).clipped()
       Rectangle()
            .fill(Color.black.opacity(0.5))
            .frame(height: 10, alignment: .center)
            .padding(.top,10)
        SpeedNiddel()
            .fill(Color.red)
            .frame(width: 60, height: 20, alignment: .center)
//            .padding(.bottom,20)
            .offset(x: -20)
            .rotationEffect(Angle(degrees: speed + 10), anchor: .center)
            .animation(.spring(), value: speed)
       }
    }

  func createDrivion() -> [Int] {
      var collection = [Int]()
      for i in 0...160 where i % 5 == 0 {
          collection.append(i)
      }
      return collection
  }
}

struct SpeedNiddel: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.minX, y: rect.midY))
        path.addLine(to: .init(x: rect.maxX - 5, y: rect.minY + 5))
        path.addArc(center: .init(x: rect.maxX - 5,
                                  y: rect.maxY / 2),
        radius: 5,
        startAngle: Angle(degrees: 90.0),
        endAngle: Angle(degrees: -90),
        clockwise: true)
        path.addLine(to: .init(x: rect.maxX - 5, y: rect.maxY - 5))
        path.addLine(to: .init(x: rect.minX, y: rect.midY))
        return path
    }
}

struct SpeedOMeter_Previews: PreviewProvider {
    static var previews: some View {
        SpeedOMeter(speed: .constant(0))
    }
}
