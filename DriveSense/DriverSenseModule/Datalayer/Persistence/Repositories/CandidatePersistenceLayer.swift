//
//  CandiatesPersistenceLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
import Combine
import Foundation
protocol CandidatePersistenceLayer {

    
    /// The reference of parent Model under which different Candidate Model resides
    var instructor: InstructorModel { get }
    
    /// Create an Candidate  Object inside the database
    /// - Parameter candidate: model that is need to created  and stored with they're value.
    /// - Returns: a publisher of that notifies once the object created in database and that object as it's response value.
    func create(candidate: CandidatesModel) -> AnyPublisher<CandidatesModel,Error>
    
    /// Create an set of candidates Model object in the batch inside the database
    /// - Parameter candidates: collection of model which are required to be created in batch
    /// - Returns: a Publisher which notifies once all the input collection Candidates Model model objects are created with
    /// that collection of object
    func batchCreate(candidates: [CandidatesModel]) -> AnyPublisher<[CandidatesModel],Error>
    
    /// Remove the a particular candidates model object from database.
    /// - Parameter candidate: model that need to be deleted.
    /// - Returns: a Publisher which notifies the when operation is completed.
    func remove(candidate: CandidatesModel) -> AnyPublisher<Void,Error>
    
    /// Fetch the collection of candidate Model from database
    /// - Parameters:
    ///   - page: indicates from which page number does the result are need to be put forward from. if incase
    ///   the expected results are more than the limit given.
    ///   - limit: indicates number of result need to served in single page
    ///     incase if input limit is passed as zero this will indicate that no limit needs to imply
    ///   - id: This optional parameter if implied return candidate models with same Id
    /// - Returns: a publisher which notifies once the operation is completed with response value as collection of
    /// candidate model object
    func fetch(page: Int,limit: Int,id: UUID?) -> AnyPublisher<[CandidatesModel],Error>
    
     /// Finding a particular candidates model into database.
    /// - Parameter Predicated: the query according to which the result will presented.
    /// - Returns: a publisher which notifies once the fetch operation is completed with response value respected object model.
    func find(predicate: NSPredicate) -> AnyPublisher<CandidatesModel?,Error>
    
    /// To get total candidate model object present in database for the particular parent model
    /// - Returns: Publishers with response as Integer value representing total count of object
    func count() -> AnyPublisher<Int,Error>
}
