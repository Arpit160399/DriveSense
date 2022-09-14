//
//  CoreData + NSExpression .swift
//  DriveSense
//
//  Created by Arpit Singh on 03/09/22.
//

import Foundation
import CoreData

public enum CoreDataFunction: String {
    case count
    case sum
    case average
}

extension NSExpression {
    fileprivate convenience init(function: CoreDataFunction ,col: NSAttributeDescription) {
        let path = NSExpression(forKeyPath: col.name)
        self.init(forFunction: "\(function.rawValue):", arguments: [path])
    }
}

extension NSExpressionDescription {
    public static func generate(function: CoreDataFunction,col: NSAttributeDescription) -> NSExpressionDescription {
        let express = NSExpression(function: function, col: col)
        let expressDescription = NSExpressionDescription()
        expressDescription.expression = express
        expressDescription.name = "\(function.rawValue)of\(col.name)"
        expressDescription.expressionResultType = col.attributeType
        return expressDescription
    }
}

extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
