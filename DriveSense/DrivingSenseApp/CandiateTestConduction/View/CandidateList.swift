//
//  CandidateList.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import SwiftUI

struct CandidateList: View {
    @State var name: String = ""
    var body: some View {
      ZStack {
        VStack {
            HStack {
            Text("Canditates")
                .font(.system(size: 24, weight: .heavy, design: .default))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Button {
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(9)
                        .background(Color.appOrange.opacity(0.3))
                        .cornerRadius(20)
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(.trailing)
                      
                    
                }
                Spacer()
            }
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.appOrange)
                    .cornerRadius(9)
                    .frame(width: 30, height: 30, alignment: .center)
                    .shadow(color: .black.opacity(0.12), radius: 15, x: 0, y: 0)
                    .padding(.leading)
                TextField("Search..", text: $name)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,5)
                    .padding(.vertical)
            }
            .background(Color.appOrange)
            .cornerRadius(22)
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0.0, y: 1.0)
            .padding(.horizontal)
            ScrollView {
                LazyVStack {
                    card
                }
            }
        }.background(Color.appOrangeLevel.ignoresSafeArea())
         popUp
      }
    }
    
    var card: some View {
        ZStack(alignment: .bottomTrailing) {
        VStack {
            HStack {
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
                
                Spacer()
                VStack(spacing: 7) {
                    Text("Prev Test")
                        .font(.systemCaption)
                        .foregroundColor(.gray.opacity(0.8))
                    Text("Not Yet Taken")
                        .font(.systemTitle2)
                }
            }.padding([.horizontal,.top])
            VStack(spacing: 10)  {
                 Text("Rick Astley")
                    .foregroundColor(.white)
                    .font(.systemTitle)
                    .frame(maxWidth: .infinity,alignment: .leading)
                 Text("29 Year Old")
                    .foregroundColor(.white)
                    .font(.systemTitle)
                    .frame(maxWidth: .infinity,alignment: .leading)

            }.padding()
          
        }
        .background(Color.appOrange)
        .cornerRadius(20)
 
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 2)
         
         Circle()
                .fill(Color.appOrange)
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 2)
                .frame(width: 55, height: 55, alignment: .center)
                .overlay(Image(systemName: "chevron.right.circle")
                    .resizable().foregroundColor(.Peach).padding(9)).padding()
            
//                .offset(x: -10 ,y: 15)
        }       .padding(.horizontal)
            .padding(.top)
    }
    var popUp: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                Text("Add Canditates")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .heavy, design: .default))
                    .padding(.horizontal)
            Section {
                InputField(placeHolder: "Name", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                InputField(placeHolder: "Date Of Birth", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                InputField(placeHolder: "Postcode", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                InputField(placeHolder: "Adderss", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                InputField(placeHolder: "Adderss Line 2 (Optional)", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                }
                HStack {
                    Spacer()
                Button {
                    
                } label: {
                    Text("Add")
                }.buttonStyle(PrimaryButton(loading: .constant(false), image: "doc.fill.badge.plus"))
                    .frame(width: 100)
                }.padding(.vertical)
            }.padding()
            .background(Color.appOrangeLevel)
            .cornerRadius(8)
            .padding(.horizontal)
        }
    }
}
struct CandidateList_Previews: PreviewProvider {
    static var previews: some View {
        CandidateList()
            
            
    }
}
