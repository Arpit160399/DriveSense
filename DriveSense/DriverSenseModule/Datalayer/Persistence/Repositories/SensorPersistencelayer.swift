//
//  SensorPersistencelayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
import Combine
import Foundation
protocol SensorPersistenceLayer {
    
    /// is the reference of assessment model under which all data operation will be conducted.
    var assessment: AssessmentModel { get }

    /// To update feedback model object value in the database.
    /// - Parameter feedback: the  feedback model with respected to which value needed to updated.
    /// - Returns: a publisher which notifies once the update operation is completed with new updated response object
    /// as response value.
    func update(feedback: FeedbackModel) -> AnyPublisher<FeedbackModel,Error>
    
    /// To get average speed from all sensor model object in the database.
    /// - Returns: a publisher which notifies once the operation is completed with response
    /// value representing the average speed calculated.
    func getAvgSpeed() -> AnyPublisher<Double,Error>
    
    
    /// To get total distance from all sensor model object in the database.
    /// - Returns: a publisher which notifies once the operation is completed.
    /// with response value representing the total distance.
    func getTotalDistance() -> AnyPublisher<Double,Error>
    
    /// creates an object of sensor model into database.
    /// - Parameter sensor: the sensor model whose object that need to be created.
    /// - Returns: a publisher which notifies once the object is created and with response value as that object.
    func create(sensor: SensorModel) -> AnyPublisher<SensorModel,Error>
    
    /// create an batch collection of sensor object at once into database
    /// - Parameter sensors: the collection sensor model whose object are to be created.
    /// - Returns: a publisher which notifies once the all given model object are created
    ///  with the response value that object collection.
    func createBatch(sensors: [SensorModel]) -> AnyPublisher<[SensorModel],Error>
    
    /// fetch a collection sensor model object from database
    /// - Parameters:
    ///   - page: indicates from which page number does the result are need to be put forward from. if incase
    ///   the expected results are more than the limit given.the indexing of page starts from 1. 
    ///   - limit: indicates number of result need to served in single page
    ///     incase if input limit is passed as zero this will indicate that no limit needs to imply
    ///   - id: This optional parameter if implied return candidate models with same Id
    /// - Returns: a publisher that notifies once the fetch operation completed
    /// with response value the collection of expected object.
    func fetch(page: Int,limit: Int,id: UUID?) -> AnyPublisher<[SensorModel],Error>
    
    /// Finding a particular sensor model into database.
    /// - Parameter predicated: the query according to which the result will presented.
    /// - Returns: a publisher which notifies once the fetch operation is
    /// completed with response value respected object model.
    func find(predicated: NSPredicate) -> AnyPublisher<SensorModel?,Error>
    
    /// to get count of sensor object under it's  parent object in database
    /// - Returns: a publisher that notifies once the operation is completed with
    /// response value the integer which represents object model count.
    func count() -> AnyPublisher<Int,Error>
    
    /// remove the particular sensor model from database.
    /// - Parameter sensor: sensor model that need to be removed from the database.
    /// - Returns: a publisher that notifies once remove operation is completed.
    func remove(sensor: [SensorModel]) -> AnyPublisher<Void,Error>
}
