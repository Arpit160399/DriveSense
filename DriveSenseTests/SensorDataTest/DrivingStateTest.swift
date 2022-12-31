//
//  SensorHandler.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 30/12/22.
//

import XCTest
@testable import DriveSense

final class DrivingStateTest: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAccelerationState() throws {
        let accelerations: [Double] = [20,85,120,220,210,0,320]
        let results = ["constant acceleration",
                       "increased acceleration",
                       "increased acceleration",
                       "increased acceleration",
                       "constant acceleration",
                       "decreased acceleration",
                       "increased acceleration"]
        
        var drivingState = DrivingState(prevSpeed: 10,prevDirection: 0)
        
        for (result,acceleration) in zip(results,accelerations) {
            let value = drivingState.getAccelerationState(bySpeed: acceleration)
            // then
            XCTAssertTrue(value == result,"Test failed for speed \(acceleration) ")
            drivingState = DrivingState(prevSpeed: acceleration,prevDirection: 0)
        }
    }

    func testForwardDriving() throws {
        // given
        let directions: [Double] = [40,69,90,220,330,0,350]
        let results = [true,true,true,false,false,true,true]
        // when
        var drivingState = DrivingState(prevSpeed: 0,prevDirection: 60)
        
        for (result,direction) in zip(results,directions) {
            let value = drivingState.isConstant(direction: direction)
            // then
            XCTAssertTrue(value == result,"Test failed for direction \(direction) degree")
            drivingState = DrivingState(prevSpeed: 0,prevDirection: direction)
        }
    }
    
    func testTheReverseDrivingIn() throws {
        // given
        let directions: [Double] = [230,44,250,330,185,5,206]
        let results = [true,true,true,false,false,true,true]
        // when
        var drivingState = DrivingState(prevSpeed: 0,prevDirection: 60)
        
        for (result,direction) in zip(results,directions) {
            let value = drivingState.detectTheReverseDrivingIn(direction: direction)
            // then
            XCTAssertTrue(value == result,"Test failed for direction \(direction) degree")
            drivingState = DrivingState(prevSpeed: 0,prevDirection: direction)
        }
    }
    
    func testLeftTurn() throws {
        // given
        let directions: [Double] = [30,330,270,60,90,0,240]
        let results = [true,true,true,false,false,true,true]
        // when
        var drivingState = DrivingState(prevSpeed: 0,prevDirection: 60)
    
        for (result,direction) in zip(results,directions) {
            let value = drivingState.checkForLeftTurn(direction: direction)
            // then
            XCTAssertTrue(value == result,"Test failed for direction \(direction) degree")
            drivingState = DrivingState(prevSpeed: 0,prevDirection: direction)
        }
    }

}
