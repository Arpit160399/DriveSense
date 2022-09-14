//
//  UnModel.swift
//  DriveSense
//
//  Created by Arpit Singh on 01/09/22.
//

import Foundation
import CoreData

protocol DomainModel {
    associatedtype Model
    func toDomainModel() -> Model
    func intoObject(from: Model,context: NSManagedObjectContext)
}
