//
//  Control.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Control {
 var acceleation:Conclusion
 var footBreak: Conclusion
 var steering: Conclusion
 var parkingBreak: Conclusion
 var clutch: Conclusion
 var gear: Conclusion

}

extension Control {
    init() {
        acceleation = .Perfect
        footBreak = .Perfect
        steering = .Perfect
        parkingBreak = .Perfect
        clutch = .Perfect
        gear = .Perfect
    }
}
