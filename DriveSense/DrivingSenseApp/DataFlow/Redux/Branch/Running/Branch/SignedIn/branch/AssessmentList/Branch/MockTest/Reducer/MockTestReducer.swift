//
//  MockTestReducer.swift
//  DriveSense
//
//  Created by Arpit Singh on 13/10/22.
//

import Foundation
extension ReducerCollection {
    
    static let MockTestReducer : Reducer<MockTestState> = { state , action in
        var state = state
        switch action {
        case is MockTestAction.PresentTestBoard:
                state.viewState = .testBoard
        default:
            state = MockTestLogic.setState(currentState: state, action: action)
        }
        //Later if to expand the reducer for Test Board
        
        return state
    }
    
}
