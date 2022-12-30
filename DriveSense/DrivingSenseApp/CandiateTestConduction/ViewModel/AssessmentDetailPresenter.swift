//
//  AssessmentDetailPresenter.swift
//  DriveSense
//
//  Created by Arpit Singh on 29/12/22.
//
import MapKit
struct IdentifiablePlace: Identifiable,Equatable {
    
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
    
    static func == (lhs: IdentifiablePlace, rhs: IdentifiablePlace) -> Bool {
        return lhs.id == rhs.id
    }
}

import Foundation
class AssessmentDetailPresenter: ObservableObject {
    
    // MARK: - Property
    @Published var switchCard = false
    @Published var region: MKCoordinateRegion
    @Published var state: AssessmentDetailState
    @Published var showError: Bool = false
    let places: [IdentifiablePlace]
    let assessment: AssessmentModel
    let testMark: TestMark
    private let dispatcher: ActionDispatcher
    
    /// Use Case
    private let fetchSensorDataUseCaseFactory: FetchSensorDataUseCaseFactory
    
    // MARK: - method
    init(dispatcher: ActionDispatcher,
         state: AssessmentDetailState,
         fetchSensorDataUserCaseFactory: FetchSensorDataUseCaseFactory) {
        self.dispatcher = dispatcher
        self.state = state
        self.fetchSensorDataUseCaseFactory = fetchSensorDataUserCaseFactory
        self.assessment = state.assessment
        if let feedback = assessment.feedback {
            self.testMark =  .init(feedBack: feedback)
        } else {
            self.testMark =  .init()
        }
        self.showError = !state.errorToPresent.isEmpty 
        if !state.places.isEmpty {
            self.places = state.places
            let midCoordinate = state.places[(0 + state.places.count) / 2]
            self.region = .init(center: midCoordinate.location,
                                latitudinalMeters: 900,
                                longitudinalMeters: 900)
        } else {
            self.places = []
            self.region = .init(center: .init(latitude: 13.45566, longitude: -121.89909),
                                latitudinalMeters: 500,
                                longitudinalMeters: 500)
        }
    }
    
    func fetchSensorData() {
        let useCase = fetchSensorDataUseCaseFactory.makeFetchSensorDataUseCase(forAssessment: assessment)
        useCase.start()
    }
    
    func send(_ action: Action) {
        dispatcher.dispatch(action)
    }
    
    func getTestDuration() -> Int {
        let startDate = Date(timeIntervalSince1970: assessment.createdAt ?? 0)
        let endDate = Date(timeIntervalSince1970: assessment.endedAt ?? 0)
        let min = Calendar.current.dateComponents([.minute], from: startDate, to: endDate).minute ?? 0
        return min
    }
    
    func updateView() {
//        withAnimation(.spring()) {
        switchCard.toggle()
//        }
    }
}
