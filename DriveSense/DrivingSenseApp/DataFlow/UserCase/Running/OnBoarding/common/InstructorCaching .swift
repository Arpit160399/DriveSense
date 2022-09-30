//
//  InstructorCaching .swift
//  DriveSense
//
//  Created by Arpit Singh on 20/09/22.
//

import Foundation
protocol InstructorCaching {
    func saveInstructor(model: InstructorModel)
    func removeInstructor(model: InstructorModel)
}
