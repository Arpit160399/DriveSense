//
//  File.swift
//  DriveSense
//
//  Created by Arpit Singh on 26/07/22.
//

import Foundation
struct TestMark {
 var id: UUID
 var totalMinorFault: Int
 var totalMajorFault: Int
 var useofSpeed: Conclusion
 var followingDistance: Conclusion
 var reversePark: Conclusion
 var progress: Progress
 var control: Control
 var moveOff: MoveOff
 var junctions: Junctions
 var positioning: Positioning
 var judgement: Judgement
    init() {
        id = UUID()
        totalMajorFault = 0
        totalMinorFault = 0
        useofSpeed = .Perfect
        followingDistance = .Perfect
        reversePark = .Perfect
        progress = .init()
        control = .init()
        moveOff = .init()
        junctions = .init()
        positioning = .init()
        judgement = .init()
    }
}

extension TestMark {
    func convertToFeedbackModel() -> FeedbackModel {
        
        let moveOffModel = MoveOffModel(safety: self.moveOff.safety.rawValue,control: self.moveOff.control.rawValue)
        
        let progressModel = ProgressModel(appropriatedSpeed: self.progress.appropriatedSpeed.rawValue,
                                          undueHesitation: self.progress.undueHesitation.rawValue)
        
        let controlModel = ControlModel(acceleration: self.control.acceleation.rawValue,
                                        footBreak: self.control.footBreak.rawValue,
                                        steering: self.control.steering.rawValue,
                                        parkingBreak: self.control.parkingBreak.rawValue,
                                        clutch: self.control.clutch.rawValue,
                                        gear: self.control.gear.rawValue)
        
        let junctionsModel = JunctionsModel(approachingSpeed: self.junctions.approachingSpeed.rawValue,
                                       observation: self.junctions.observation.rawValue,
                                       turingRight: self.junctions.turningRight.rawValue,
                                       turingLeft: self.junctions.turningLeft.rawValue,
                                       cuttingCorner: self.junctions.cutingCorner.rawValue)
      
        let positioningModel = PositioningModel(normalDriving: self.positioning.normalDriving.rawValue,
                                           laneDiscipline: self.positioning.laneDiscipline.rawValue)
        
        let judgementModel = JudgementModel(overtaking: self.judgement.overtaking.rawValue,
                                            meeting: self.judgement.meeting.rawValue,
                                            crossing: self.judgement.crossing.rawValue)
        
        return .init(id: id,
                     control: controlModel,judgement: judgementModel,
                     junctions: junctionsModel,positioning: positioningModel,
                     progress: progressModel,
                     useofSpeed: self.useofSpeed.rawValue,
                     followingDistance: self.followingDistance.rawValue,
                     reversePark: self.reversePark.rawValue,
                     moveOff: moveOffModel,
                     totalFaults: Double(self.totalMajorFault) + Double(self.totalMinorFault),
                     totalMajorFault: Double(self.totalMajorFault),
                     totalMinorFault: Double(self.totalMinorFault))
    }
}

extension TestMark {
    
    init(feedBack: FeedbackModel) {
        id = feedBack.id ?? UUID()
       
        moveOff = MoveOff(safety: Conclusion.get(feedBack.moveOff?.safety),
                          control: Conclusion.get(feedBack.moveOff?.control))
        
        control = Control(acceleation: Conclusion.get(feedBack.control?.acceleration),
                          footBreak: .get(feedBack.control?.footBreak),
                          steering: .get(feedBack.control?.steering),
                          parkingBreak: .get(feedBack.control?.parkingBreak),
                          clutch: .get(feedBack.control?.clutch),
                          gear: .get(feedBack.control?.gear))
        
        totalMajorFault = Int(feedBack.totalMajorFault ?? 0)
        totalMinorFault = Int(feedBack.totalMinorFault ?? 0)
        
        useofSpeed = .get(feedBack.useofSpeed)
        followingDistance = .get(feedBack.followingDistance)
        reversePark = .get(feedBack.reversePark)
        
        progress = Progress(appropriatedSpeed: .get(feedBack.progress?.appropriatedSpeed),
                            undueHesitation: .get(feedBack.progress?.undueHesitation))
      
        junctions = Junctions(approachingSpeed: .get(feedBack.junctions?.approachingSpeed),
                              observation: .get(feedBack.junctions?.observation),
                              turningRight: .get(feedBack.junctions?.turingRight),
                              turningLeft: .get(feedBack.junctions?.turingLeft),
                              cutingCorner: .get(feedBack.junctions?.cuttingCorner))
        
        positioning = Positioning(normalDriving: .get(feedBack.positioning?.normalDriving),
                                  laneDiscipline: .get(feedBack.positioning?.laneDiscipline))
        
        judgement = Judgement(overtaking: .get(feedBack.judgement?.overtaking),
                              meeting: .get(feedBack.judgement?.meeting),
                              crossing: .get(feedBack.judgement?.crossing))
        
    }
}
