//
//  JudgementEntity+CoreDataProperties.swift
//  DriveSense
//
//  Created by Arpit Singh on 02/09/22.
//
//

import Foundation
import CoreData


extension JudgementEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<JudgementEntity> {
        return NSFetchRequest<JudgementEntity>(entityName: "JudgementEntity")
    }

    @NSManaged public var crossing: String?
    @NSManaged public var meeting: String?
    @NSManaged public var overtaking: String?
    @NSManaged public var assessment: FeedbackEntity?

}

extension JudgementEntity : Identifiable {

}

extension JudgementEntity : DomainModel {
    
    func intoObject(from: JudgementModel,context: NSManagedObjectContext) {
        overtaking = from.overtaking
        meeting = from.meeting
        crossing = from.crossing
    }
    
    func toDomainModel() -> JudgementModel {
        return .init(overtaking: overtaking, meeting: meeting, crossing: crossing)
    }
}
