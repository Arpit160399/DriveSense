//
//  JunctionsEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension JunctionsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JunctionsEntity> {
        return NSFetchRequest<JunctionsEntity>(entityName: "JunctionsEntity")
    }

    @NSManaged public var approachingSpeed: String
    @NSManaged public var cuttingCorner: String
    @NSManaged public var observation: String
    @NSManaged public var turingLeft: String
    @NSManaged public var turingRight: String
    @NSManaged public var assessement: FeedbackEntity?

}

extension JunctionsEntity : Identifiable {

}

extension JunctionsEntity: DomainModel {
 
    func intoObject(from: JunctionsModel,context: NSManagedObjectContext) {
        approachingSpeed = from.approachingSpeed ?? ""
        observation = from.observation ?? ""
        turingLeft = from.turingLeft ?? ""
        turingRight = from.turingRight ?? ""
        cuttingCorner = from.cuttingCorner ?? ""
    }
    
    func toDomainModel() -> JunctionsModel {
        return .init(approachingSpeed: approachingSpeed,
            observation: observation,
            turingRight: turingRight,
            turingLeft: turingLeft,
             cuttingCorner: cuttingCorner)
    }

}
