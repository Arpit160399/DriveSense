//
//  CoreDataInstructor.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 06/09/22.
//
import XCTest
import Combine
import Foundation
@testable import DriveSense
class CoreDataInstructorTest: XCTestCase {
    
    var testInstuctor: InstructorModel!
    var instructorRepoManager: CoreDataInstructorPersistencelayer?
    var instuctorTOfind: UUID!
    var task = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let coredataStack = try CoreDataStack()
        instuctorTOfind = try coredataStack.getInstructorID()
        (instructorRepoManager,testInstuctor) = coredataStack.createInstuctorTestRepo()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInstructorCoreDataOperations() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let exp = expectation(description: "Successfully create instructor.")
        instructorRepoManager?.create(instructor: testInstuctor)
            .sink(receiveCompletion: { completed in
                if case .failure(_) = completed {
                  XCTFail("creation failed with and error")
                  exp.fulfill()
                }
            }, receiveValue: { newData in
                XCTAssertTrue(newData.id == self.testInstuctor.id, "failed to write data into core data object")
                exp.fulfill()
            })
            .store(in: &task)
        wait(for: [exp], timeout: 5)
    }
    
    func testInstructorCoreDataFetchOperations() throws {
        let exp1 = expectation(description: "Successfully fetched instructor.")
        instructorRepoManager?.fetch(id: instuctorTOfind!)
        .sink(receiveCompletion: { completion in
            if case .failure(_) = completion {
              XCTFail("failed to fetch the given result form set")
                exp1.fulfill()
            }
        }, receiveValue: { result in
            XCTAssertTrue(result.id == self.instuctorTOfind , "failed to fetch data into core data object")
            exp1.fulfill()
        }).store(in: &task)
        wait(for: [exp1], timeout: 5)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
