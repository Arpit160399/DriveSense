//
//  RollingMeter.swift
//  DriveSense
//
//  Created by Arpit Singh on 25/07/22.
//

import SwiftUI

struct RollingMeter: View {
    @Binding var value: Double
    @State var range: [NSString] = []
    var font: Font = Font.system(size: 25, weight: .heavy, design: .default)
    var color: Color = .black
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<range.count, id: \.self) { num in
                if range[num] == "." {
                 Text(".")
                  .font(font)
                  .foregroundColor(color)
                } else {
                Text("9")
                    .font(font)
                    .foregroundColor(color)
                    .opacity(0)
                    .overlay(
                        GeometryReader { proxy in
                            let size = proxy.size
                            VStack(spacing: 0) {
                                ForEach(0..<10) { index in
                                    Text("\(index)")
                                        .font(font)
                                        .foregroundColor(color)
                                        .frame(width: size.width,
                                               height: size.height,
                                               alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(range[num].integerValue) * size.height)
                        }.clipped()
                    )
               }
            }
        }.onAppear {
            range = Array(repeating: "0", count: String(format: "%.1f",value).count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                updateCounter()
            }
        }
        .onChange(of: value) { _ in
            let extra = String(format: "%.1f",value).count - range.count
            withAnimation(.easeIn(duration: 0.04)) {
              for _ in 0..<abs(extra) {
                    if extra > 0 {
                        range.append("0")
                    } else {
                        range.removeLast()
                    }
               }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
                updateCounter()
            }
        }
    }

    func updateCounter() {
        let stringNumber = String(format: "%.1f",value)
        for (index, char) in stringNumber.enumerated() {
            withAnimation(.spring(response: 1, dampingFraction: 1, blendDuration: 1)) {
                range[index] = ("\(char)" as NSString)
            }
        }
    }
}

struct RollingMeter_Previews: PreviewProvider {
    static var previews: some View {
        RollingMeter(value: .constant(Double(45.8)))
    }
}
