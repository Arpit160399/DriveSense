//
//  CandidateList.swift
//  DriveSense
//
//  Created by Arpit Singh on 31/07/22.
//

import SwiftUI

struct CandidateList: View {
    @ObservedObject var store: CandidateListPresenter
    @FocusState var searchText: Bool
    var state: SignedInState {
        return store.state
    }
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
                    store.enrollNewCandidate()
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
                Button {
                    store.presentSetting()
                } label: {
                    Image(systemName: "gear.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.white)
                        .padding(9)
                        .background(Color.appOrange.opacity(0.3))
                        .cornerRadius(20)
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(.trailing)
                }
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
                TextField("Search..", text: $store.query)
                    .font(.systemSubTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal,5)
                    .padding(.vertical)
                    .focused($searchText)
            }
            .background(Color.appOrange)
            .cornerRadius(22)
            .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0.0, y: 1.0)
            .padding(.horizontal)
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack {
                        ForEach(store.candidates.indices,id: \.self) { index in
                            let candidate = store.candidates[index]
                            CandidateCardView(model: candidate)
                                .onTapGesture {
                                    let action = SignedInAction.PresentAssessmentDetail(forCandidate: candidate)
                                    store.send(action)
                                }
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
            }.onTapGesture {
                searchText = false
            }
            NavigationLink(destination: store.navigationMode.destination,
                           isActive: $store.navigationMode.isDisplayed ,
                           label: {}).hidden()
        }.background(Color.appOrangeLevel.ignoresSafeArea())
          if store.navigationMode.showModel {
              store.navigationMode.destination
          }
      }
      .alert(isPresented: $store.showError) {
          let errorMessage = store.state.errorToPresent.first
          return Alert(title: Text(errorMessage?.title ?? ""),
                    message: Text(errorMessage?.message ?? ""),
                    dismissButton: Alert.Button.cancel(Text("ok"), action: {
                  if let error = errorMessage {
                      let action = SignedInAction.PresentedCandiateFetchingError(error: error)
                      store.send(action)
                  }
              }))
      }
      .onAppear {
          if state.currentPage == 0 ,
             state.candidates.isEmpty {
              store.getCandidatesList(fromPage: 0)
        }
      }
    }
    
}
