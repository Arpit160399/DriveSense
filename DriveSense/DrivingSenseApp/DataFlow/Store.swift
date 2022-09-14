//
//  Store.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/08/22.
//
import Combine
import Foundation

protocol Action {}

protocol ActionDispatcher {
    func dispatch(_ action: Action)
}

typealias Reducer<State> = (State,Action) -> State
typealias Middleware<State> = (State,Action) -> AnyPublisher<Action,Never>

final class Store<State>: ObservableObject,ActionDispatcher {
    
    // MARK: - Properties

    @Published private(set) var state: State
    
    private var subscription = [UUID : AnyCancellable]()
    private var queue = DispatchQueue(label: "drivesense.dispatch.event", qos: .userInitiated)
    private let reducer: Reducer<State>
    private let middlewares: [Middleware<State>]
    
    
    init(initial: State,
         reducer: @escaping Reducer<State>,
         middlewares: [Middleware<State>]
    ) {
        self.state = initial
        self.reducer = reducer
        self.middlewares = middlewares
    }
    
    
    // MARK: - Methods
    
    func restore( _ state: State) {
        self.state = state
    }
    
    func dispatch(_ action: Action) {
        queue.sync {
            dispatch(self.state, action)
        }
    }
    
    fileprivate func dispatch(_ current: State,_ action: Action) {
        let newState = reducer(current,action)
        middlewares.forEach { middleware in
            let key = UUID()
            middleware(newState,action)
                .receive(on: RunLoop.main)
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.subscription.removeValue(forKey: key)
                })
                .sink(receiveValue: dispatch(_:))
                .store(for: &subscription,key: key)
                
        }
        self.state = newState
    }
    
 
}

extension AnyCancellable {
    func store(for collection: inout [UUID: AnyCancellable],key: UUID) {
        collection[key] = self
    }
}
