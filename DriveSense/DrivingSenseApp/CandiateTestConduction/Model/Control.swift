//
//  Control.swift
//  DriveSense
//
//  Created by Arpit Singh on 04/08/22.
//

import Foundation
struct Control: Equatable {
 var acceleation:Conclusion
 var footBreak: Conclusion
 var steering: Conclusion
 var parkingBreak: Conclusion
 var clutch: Conclusion
 var gear: Conclusion

}

extension Control: faultNum {
    func totalFaultby(_ type: Conclusion) -> Int {
        let total = [acceleation,footBreak,steering,parkingBreak,clutch,gear]
                    .reduce(0) { partialResult,current  in
                        return partialResult + current.getValue(type)
                    }
        return total
    }
}

extension Control {
    init() {
        acceleation = .perfect
        footBreak = .perfect
        steering = .perfect
        parkingBreak = .perfect
        clutch = .perfect
        gear = .perfect
    }
}
