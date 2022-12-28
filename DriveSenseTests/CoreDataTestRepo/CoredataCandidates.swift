//
//  CoredataCandidates.swift
//  DriveSenseTests
//
//  Created by Arpit Singh on 07/09/22.
//
import Combine
import XCTest
@testable import DriveSense
class CoredataCandidates: XCTestCase {
    
    var task = Set<AnyCancellable>()
    var candidatesTestResource: CandidateCoreDataTestResource!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let coreDataStack = try CoreDataStack()
        candidatesTestResource = try coreDataStack.createCandiatesTestRepo()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreationOfCandidatesIntoCoreData() throws {
        let candidates = candidatesTestResource.candidate
        let exp = expectation(description: "Successfully create candidate")
        candidatesTestResource.repo.create(candidate: candidates)
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Failed to create Candidate object in core data")
                    exp.fulfill()
                }
            } receiveValue: { model in
                XCTAssertTrue(model.id == candidates.id,"mapping object to model failed")
                exp.fulfill()
            }.store(in: &task)
        wait(for: [exp], timeout: 5)
    }
    
    func testFetchOfCandidatesFromCoreData() throws {
        let id = candidatesTestResource.fetchID
        let exp = expectation(description: "Successfully fetced candidate")
        candidatesTestResource.repo.fetch(page: 1, limit: 2, id: nil)
        .sink { completion in
            if case .failure(_ ) = completion {
                XCTFail("Failed to fetch candidate from core data")
                exp.fulfill()
            }
        } receiveValue: { models in
             XCTAssertTrue(models.first?.id == id ,"failed to map object to model")
             exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 5)
    }
    
    func testBatchCreationOfCandidatesIntoCoreData() {
        let candidates = Array(repeating: candidatesTestResource.candidate,count: 4)
        let exp = expectation(description: "Successfully batch create candidate")
        candidatesTestResource.repo.batchCreate(candidates: candidates)
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Failed to batch create Candidate object in core data")
                    exp.fulfill()
                }
            } receiveValue: { models in
                for (model,candidate) in zip(models,candidates) {
                 XCTAssertTrue(model.id == candidate.id,"mapping object to model failed")
                }
                exp.fulfill()
            }.store(in: &task)
         wait(for: [exp], timeout: 5)
    }
    
    func testCountOFCandidatesFromCoreData() throws {
        let exp = expectation(description: "Successfully count conduct on candidate")
       candidatesTestResource.repo.count()
        .sink { completion in
            if case .failure(let error) = completion {
                XCTFail("Failed to count candidate from core data")
                exp.fulfill()
            }
        } receiveValue: { number in
             XCTAssertTrue(number > 0 ,"incorrect count result")
             exp.fulfill()
        }
        .store(in: &task)
        wait(for: [exp], timeout: 15)
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
