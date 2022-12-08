//
//  CandidateCardView.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/09/22.
//
import SwiftUI
import Foundation
struct CandidateCardView: View {

    var model: CandidatesModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
        VStack {
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.appOrange)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
                    .frame(width: 50,
                           height: 50,
                           alignment: .center)
                    .overlay(Image(systemName:  "person.fill").resizable()
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: .fit)
                        .padding(12))
                VStack(spacing: 10)  {
                    Text(model.name ?? "")
                        .foregroundColor(.white)
                        .font(.systemTitle2)
                        .frame(maxWidth: .infinity,alignment: .leading)
                     Text("29 Year Old")
                        .foregroundColor(.white)
                        .font(.systemTitle2)
                        .frame(maxWidth: .infinity,alignment: .leading)

                }.padding(.horizontal)
                Spacer()
                VStack(alignment: .leading,spacing: 7) {
                    Text("Joined On")
                        .font(.systemCaption2)
                        .foregroundColor(.black.opacity(0.6))
//                        .frame(maxWidth: .infinity,alignment: .leading)
                    Text(model.createdAt?.formatter(type: "dd MMM yyy") ?? "")
                        .font(.systemCaption)
                        .foregroundColor(.white)
                }
            }.padding([.horizontal,.top])
            VStack(spacing: 10)  {
                Text("Address")
                    .foregroundColor(.black.opacity(0.6))
                    .font(.systemCaption2)
                    .frame(maxWidth: .infinity,alignment: .leading)
                Text(model.address ?? "")
                    .foregroundColor(.white)
                    .font(.systemBody)
                    .frame(maxWidth: .infinity,alignment: .leading)

            }.padding()
          
        }
        .background(Color.appOrange)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.18), radius: 5, x: 0, y: 0.5)
         
         Circle()
                .fill(Color.appCyan)
                .shadow(color:  Color.appCyan.opacity(0.5), radius: 7, x: 0, y: 0.5)
                .frame(width: 45, height: 45, alignment: .center)
                .overlay(Image(systemName: "chevron.right")
//                    .imageScale(.medium)
                    .resizable()
                    .font(.system(size: 15, weight: .bold))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(12))
                .padding()
            
//                .offset(x: -10 ,y: 15)
        }
            .padding(.horizontal)
            .padding(.top)
    }
    
}

extension TimeInterval {
  func formatter(type: String) -> String {
       let formatter = DateFormatter()
       let date = Date(timeIntervalSince1970: self)
       formatter.dateFormat = type
       return formatter.string(from: date)
    }
}
