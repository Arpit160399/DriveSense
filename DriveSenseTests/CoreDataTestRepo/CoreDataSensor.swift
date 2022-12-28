//
//  CoreDataSensor.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 07/09/22.
//
import Combine
import XCTest
@testable import DriveSense
class CoreDataSensor: XCTestCase {

    var task = Set<AnyCancellable>()
    var sensorTestResource: SensorCoreDataTestResource!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let coreDataStack = try CoreDataStack()
        sensorTestResource = try coreDataStack.createSensorTestRepo()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateSensorObjectIntoCoreData() throws {
        let exp = expectation(description: "Successfully created Sensor object.")
        let createModel = sensorTestResource.sensor
        sensorTestResource.repo.create(sensor: createModel)
            .sink { completion in
                if case .failure(_ ) = completion {
                    XCTFail("failed to create Sensor Object into core data")
                    exp.fulfill()
                }
            } receiveValue: { model in
                XCTAssertTrue(model.id == createModel.id,"failed to map the object to model")
                exp.fulfill()
            }
            .store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testBatchCreationSensorObjectIntoCoreData() throws {
        let exp = expectation(description: "Successfully batch created Sensor.")
        let createModels = Array(repeating: sensorTestResource.sensor, count: 4)
        sensorTestResource.repo.createBatch(sensors: createModels)
            .sink { completion in
                if case .failure(_ ) = completion {
                    XCTFail("failed to create in batch the sensor object into core data")
                    exp.fulfill()
                }
            } receiveValue: { objects in
                for (model,object) in zip(createModels,objects) {
                    XCTAssertTrue(model.id == object.id,"failed to map the object to model")
                }
                exp.fulfill()
            }.store(in: &task)

        wait(for: [exp], timeout: 5)
    }

    func testFetchSensorObjectFromCoreData() throws {
        let exp = expectation(description: "Successfully Fetched Sensor Object.")
        try testBatchCreationSensorObjectIntoCoreData()
        sensorTestResource.repo.fetch(page: 1, limit: 10, id: nil)
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("failed to fetch the sensor object into core data")
                exp.fulfill()
            }
        } receiveValue: { models in
            XCTAssertTrue(models.count >= 4,"incorrect result of fetch operation")
            exp.fulfill()
        }.store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testAvgSpeedCalculationOfSensorObjectIntoCoreData () throws {
        let exp = expectation(description: "Successfully calculated average speed in sensor.")
        try testBatchCreationSensorObjectIntoCoreData()
        let correctResult = ((sensorTestResource.sensor.speed ?? 0) * 4) / 4
        sensorTestResource.repo.getAvgSpeed()
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("failed calculate average speed in sensor object from core data")
                exp.fulfill()
            }
        } receiveValue: { avg in
            XCTAssertTrue(correctResult == avg,"incorrect result of average operation")
            exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testSumOfDistanceCalculationIntoCoreData() throws {
        let exp = expectation(description: "Successfully calculated total distance in sensor.")
        try testBatchCreationSensorObjectIntoCoreData()
        let correctResult = (sensorTestResource.sensor.distance ?? 0) * 5
        sensorTestResource.repo.getTotalDistance()
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("failed calculate total distance in sensor object from core data")
                exp.fulfill()
            }
        } receiveValue: { total in
            XCTAssertTrue(correctResult == total,"incorrect result of sum operation")
            exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testCountOfSensorObjectIntoCoreData() throws {
        let exp = expectation(description: "Successfully calculated count of sensor object.")
        try testBatchCreationSensorObjectIntoCoreData()
        sensorTestResource.repo.count()
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("failed calculate the count sensor object in core data")
                exp.fulfill()
            }
        } receiveValue: { count in
            XCTAssertTrue(count > 4,"incorrect result of count operation")
            exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testUpdateOfFeedbackIntoCoreData() throws {
        let exp = expectation(description: "Successfully updated feedback object.")
        var newFeedback = sensorTestResource.feedback
        newFeedback.judgement?.meeting = "minor"
        newFeedback.totalMinorFault = 7.0
        sensorTestResource.repo.update(feedback: newFeedback)
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("failed to updated feedback object in core data")
                exp.fulfill()
            }
        } receiveValue: { model in
            XCTAssertTrue(model.judgement?.meeting == "minor" &&
                          model.totalMinorFault == 7.0
                          ,"failed to map object to model")
            exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
