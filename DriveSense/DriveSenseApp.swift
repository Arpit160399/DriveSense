//
//  DriveSenseApp.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/07/22.
//

import SwiftUI

@main
struct DriveSenseApp: App {
    let mainContainer = DriverSenseContainer()
    var body: some Scene {
        WindowGroup {
//            ContentView {
            mainContainer
            .makeMainView()
            .environment(\.colorScheme, .light)
       }
   }
}
  

struct Trapezium : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        let difwidth = (rect.width * 0.5) / 2
        path.addLine(to: .init(x: rect.maxX - difwidth, y: rect.minY))
        path.addLine(to: .init(x: rect.minX + difwidth, y: rect.minY))
        path.addLine(to: .init(x: rect.minX , y: rect.maxY))
        return path
    }
}
