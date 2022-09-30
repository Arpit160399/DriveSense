//
//  CandidateList.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import SwiftUI

struct CandidateList: View {
    @ObservedObject var store: CandidateListPresenter
    var state: SignedInState {
        return store.state
    }
    @State var name: String = ""
    @State var showPopUp: Bool = false
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
                    showPopUp.toggle()
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
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(state.candidates.indices,id: \.self) { index in
                            let candidate = state.candidates[index]
                            CandidateCardView(model: candidate)
                                .onAppear {
                                    if index == state.candidates.count - 1 {
                                        store.getCandidatesList(fromPage:
                                                                    state.currentPage + 1)
                                    }
                                }
                        }
                        if state.isLoading {
                            ActivityLoader(color: .white)
                                .frame(width: 55,height: 55)
                        }
                    }}
//                    }.onAppear(perform: {
//                        proxy.scrollTo((state.currentPage * 20) - 1)
//                    })
            }
            NavigationLink(destination: store.navigationMode.destination,
                           isActive: $store.navigationMode.isDisplayed ,
                           label: {}).hidden()
        }.background(Color.appOrangeLevel.ignoresSafeArea())
        if showPopUp {
              popUp
        }
      }.onAppear {
          if state.currentPage == 0 {
              store.getCandidatesList(fromPage: 0)
        }
      }
    }
    
    
    var popUp: some View {
        ZStack {
            Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showPopUp.toggle()
                }
            VStack(alignment: .leading) {
                Text("Add Canditates")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .heavy, design: .default))
                    .padding(.horizontal)
            Section {
                InputField(placeHolder: "Name", value: .constant(""))
                Divider()
                    .padding(.horizontal)
                DatePicker("Date Of Birth",selection: .constant(Date())
                           ,in:Date(timeIntervalSince1970: 9911223)...Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 - 568080000),displayedComponents:[.date])
                    .datePickerStyle(.automatic)
                    .colorInvert()
                    .colorMultiply(.white)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
//                InputField(placeHolder: "Date Of Birth", value: .constant(""))
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
