//
//  AssessmentPersistenceLayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
import Combine
import Foundation
protocol AssessmentPersistenceLayer {
    
    /// is the reference of candidate model under which all data operation will be conducted
    var candidate: CandidatesModel { get }
    
    /// creates an object of assessment model into database.
    /// - Parameter assessment: the assessment model whose object that need to be created.
    /// - Returns: a publisher which notifies once the object is created and with response value as that object.
    func create(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel,Error>
    
    /// create an batch collection of assessment object at once into database
    /// - Parameter assessments: the collection assessment model whose object are to be created.
    /// - Returns: a publisher which notifies once the all given model object are created
    ///  with the response value that object collection.
    func createBatch(assessments: [AssessmentModel]) -> AnyPublisher<[AssessmentModel],Error>
    
    /// To update assessment model object value in the database.
    /// - Parameter Assessment: the  Assessment model with respected to which value needed to updated.
    /// - Returns: a publisher which notifies once the update operation is completed with new updated response object
    /// as response value.
    func update(assessment: AssessmentModel) -> AnyPublisher<AssessmentModel,Error>
    
    /// fetch a collection assessment model object from database
    /// - Parameters:
    ///   - page: indicates from which page number does the result are need to be put forward from. if incase
    ///   the expected results are more than the limit given.the indexing of page starts from 1. 
    ///   - limit: indicates number of result need to served in single page
    ///     incase if input limit is passed as zero this will indicate that no limit needs to imply
    ///   - id: This optional parameter if implied return candidate models with same Id
    /// - Returns: a publisher that notifies once the fetch operation completed
    /// with response value the collection of expected object.
    func fetch(page: Int,limit: Int,id: UUID?) -> AnyPublisher<[AssessmentModel],Error>
    
    /// Finding a particular assessment model  into database.
    /// - Parameter predicated: the query according to which the result will presented.
    /// - Returns: a publisher which notifies once the fetch operation is completed with
    ///  response value respected object model.
    func find(predicated: NSPredicate) -> AnyPublisher<AssessmentModel?,Error>

    /// remove the particular assessment model from database.
    /// - Parameter assessment: assessment model that need to be removed from the database.
    /// - Returns: a publisher that notifies once remove operation is completed.
    func remove(assessment: AssessmentModel) -> AnyPublisher<Void,Error>
    
    /// to get count of Assessment object under it's  parent object in database
    /// - Returns: a publisher that notifies once the operation is completed with
    /// response value the integer which represents object model count.
    func count() -> AnyPublisher<Int,Error>
}
