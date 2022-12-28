//
//  FeedbackEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 03/09/22.
//
//

import Foundation
import CoreData


extension FeedbackEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedbackEntity> {
        return NSFetchRequest<FeedbackEntity>(entityName: "FeedbackEntity")
    }

    @NSManaged public var followingDistance: String?
    @NSManaged public var id: UUID?
    @NSManaged public var reversePark: String?
    @NSManaged public var totalFaults: Double
    @NSManaged public var totalMajorFault: Double
    @NSManaged public var totalMinorFault: Double
    @NSManaged public var useofSpeed: String?
    @NSManaged public var control: ControlEntity?
    @NSManaged public var judgement: JudgementEntity?
    @NSManaged public var junctions: JunctionsEntity?
    @NSManaged public var moveOff: MoveOffEntity?
    @NSManaged public var positioning: PositioningEntity?
    @NSManaged public var progress: ProgressEntity?
    @NSManaged public var assessment: AssessmentEntity?

}

extension FeedbackEntity : Identifiable {

}

extension FeedbackEntity : DomainModel {
    
    func toDomainModel() -> FeedbackModel {
        return .init(id: id ?? UUID(), control: control?.toDomainModel(), judgement: judgement?.toDomainModel(),
                     junctions: junctions?.toDomainModel(), positioning: positioning?.toDomainModel(),
                     progress: progress?.toDomainModel(), useofSpeed: useofSpeed,
                     followingDistance: followingDistance,
                     reversePark: reversePark, moveOff: moveOff?.toDomainModel(),
                     totalFaults: totalFaults, totalMajorFault: totalMajorFault,
                     totalMinorFault: totalMinorFault)
    }
    
    fileprivate func controObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let controlModel = from.control {
            let object = control != nil ? control : ControlEntity(context: context)
            object?.intoObject(from: controlModel, context:  context)
            control = object
        }
    }
    
    fileprivate func judgementObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let judgementModel = from.judgement {
            let object = judgement != nil ? judgement : JudgementEntity(context: context)
            object?.intoObject(from: judgementModel, context: context)
            judgement = object
        }
    }
        
    fileprivate func junctionsObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let junctionsModel = from.junctions {
            let object = junctions != nil ? junctions : JunctionsEntity(context: context)
            object?.intoObject(from: junctionsModel,context: context)
            junctions = object
        }
    }
    
    fileprivate func moveOffObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let moveOffModel = from.moveOff {
            let object =  moveOff != nil ? moveOff : MoveOffEntity(context: context)
            object?.intoObject(from: moveOffModel, context: context)
            moveOff = object
        }
    }
    
    fileprivate func positioningObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let positioningModel = from.positioning {
            let object = positioning != nil ? positioning : PositioningEntity(context: context)
            object?.intoObject(from: positioningModel, context: context)
            positioning = object
        }
    }
    
    fileprivate func progressObject(_ from: FeedbackModel, _ context: NSManagedObjectContext) {
        if let progressModel = from.progress {
            let object = progress != nil ? progress : ProgressEntity(context: context)
            object?.intoObject(from: progressModel, context: context)
            progress = object
        }
    }
    
    func intoObject(from: FeedbackModel,context: NSManagedObjectContext) {
        followingDistance = from.followingDistance
        id = from.id
        reversePark = from.reversePark
        totalFaults = from.totalFaults ?? 0
        totalMajorFault = from.totalMajorFault ?? 0
        totalMinorFault = from.totalMinorFault ?? 0
        useofSpeed = from.useofSpeed
        controObject(from, context)
        judgementObject(from, context)
        junctionsObject(from, context)
        moveOffObject(from, context)
        positioningObject(from, context)
        progressObject(from, context)
    }
    
}
