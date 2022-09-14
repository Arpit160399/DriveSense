//
//  ContentView.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/07/22.
//

import SwiftUI

struct ContentView : View {
    @State var backGroudMovement: CGFloat = -10
    @State var carMovementx: CGFloat = 100
    @State var carMovementy: CGFloat = 25
    @State var showContent: Bool = false
    @State var hideBackGound = false
    @State var hideTop = false
    @Namespace var animation: Namespace.ID
//    var content: () -> T
    var body: some View {
    if !showContent {
        ZStack {
            Color.orange
                .edgesIgnoringSafeArea(.all)
             Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 340, alignment: .center)
                .offset(x: backGroudMovement)
                .opacity(hideBackGound ? 0 : 1)
              carBody
                .offset(x: carMovementx)
                .offset(y: carMovementy)
        }.onAppear {
            
            withAnimation(.linear(duration: 1).speed(0.5)) {
                    carMovementx = -50
            }
            withAnimation(.easeInOut(duration: 1).speed(0.5)) {
                    backGroudMovement = 90
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.spring().speed(0.6)) {
//                        showContent = true
                }
            }
       
         }
        } else {
             VStack {
                 if !hideTop {
                   HStack {
                     Image("WithoutSensor")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(height: 35, alignment: .bottom)
                     .matchedGeometryEffect(id: "logo", in: animation)
                     Text("Drive\n Sense")
                         .font(.system(size: 20, weight: .heavy, design: .default))
                     .foregroundColor(.white)
                }
                   .onAppear {
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                           withAnimation {
                               hideTop.toggle()
                           }
                       }
                   }
                 }
//                    content()
             }.background(Color.appOrangeLevel.edgesIgnoringSafeArea(.all))
        }
    }
        
   var carBody: some View {
            GeometryReader { proxy in
             WaveIcon(animation: true,stroke: 4,showPoint: false,color: .white)
                 .frame(width: 40, height: 40, alignment: .bottom)
                 .position(x: proxy.frame(in: .local).midY + 52, y: proxy.frame(in: .local).minY + 35)
             WaveIcon(animation: true,stroke: 4,showPoint: false,color: .white)
                    .rotationEffect(.degrees(40))
                    .frame(width: 40, height: 40, alignment: .bottom)
                    .position(x: proxy.frame(in: .local).maxX - 10, y: proxy.frame(in: .local).midY)
             WaveIcon(animation: true,stroke: 4,showPoint: false,color: .white)
                    .rotationEffect(.degrees(-20))
                    .frame(width: 40, height: 40, alignment: .bottom)
                    .position(x: proxy.frame(in: .local).minX + 45, y: proxy.frame(in: .local).midY)
             Image("WithoutSensor")
                 .resizable()
                 .aspectRatio(contentMode: .fit)
                 .frame(height: 140, alignment: .bottom)
                 .matchedGeometryEffect(id: "logo", in: animation)
            }.frame(width: 200, height: 140, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
