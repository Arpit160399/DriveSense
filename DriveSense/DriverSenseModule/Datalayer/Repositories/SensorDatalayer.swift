//
//  SensorDatalayer.swift
//  DriveSense
//
//  Created by Arpit Singh on 29/12/22.
//
import Combine
import Foundation
protocol SensorDataLayer {
    
    func getSensorData(page: Int) -> AnyPublisher<[SensorModel],Error>
    
}
