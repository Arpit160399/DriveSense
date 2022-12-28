//
//  ButtonStyle.swift
//  DriveSense
//
//  Created by Arpit Singh on 30/07/22.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    @Binding var loading: Bool
    var image: String?
    var color = Color.appCyan
    func makeBody(configuration: Configuration) -> some View {
        HStack {
        if loading {
            ActivityLoader(color:.white)
                .frame(width: 120,height: 50)
        } else {
        configuration.label
                .font(.systemTitle2)
                .foregroundColor(.white)
                .padding(.vertical)
            if let name = image {
                Image(systemName: name)
                    .resizable()
                    .font(.systemTitle2)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 20, alignment: .center)
            }
       }
      }
      .frame(maxWidth: .infinity, alignment: .center)
      .background(color)
      .overlay {
          if configuration.isPressed {
              Color.white.opacity(0.2)
          } else {
              Color.clear
          }
      }
      .cornerRadius(25)
      .frame(height: 50)
      .shadow(color: color.opacity(0.4), radius: 5, x: 0.0, y: 2)

    }
}
