//
//  GPS.swift
//  DriveSense
//
//  Created by Arpit Singh on 11/08/22.
//

import Foundation
import CoreLocation 
class GPSSensor: NSObject {
    
    private var manager: CLLocationManager
    private var previous: GPS
    
    enum GPSError: Swift.Error {
        case notAuthorized
        case invalidDataFormate
        case unknown
        
        var description: String {
            switch self {
            case .notAuthorized:
                return "The Application was given the permission to access the location services please enable this from the settings"
            case .invalidDataFormate:
                return "The given data has been corrupted or is invalid formate"
            case .unknown:
                return "an unexpected Error Occurred"
            }
        }
    }
    

    override init() {
        manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        previous = .init(longitude: 0, latitude: 0)
        super.init()
        manager.delegate = self
    }
    
    deinit  {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
    
    func getDirection() throws -> Double {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            throw GPSError.notAuthorized
        }
        guard let direction = manager.heading?.magneticHeading as? Double else {
            throw GPSError.invalidDataFormate
        }
//        guard let direction = manager.location?.course as? Double else {
//            throw GPSError.invalidDataFormate
//        }

        return direction
    }
    
    func getVehicleCourse() throws -> Double {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            throw GPSError.notAuthorized
        }

        guard let course = manager.location?.course as? Double else {
            throw GPSError.invalidDataFormate
        }

        return course
    }
    
    func getSpeed() throws -> Double {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            throw GPSError.notAuthorized
        }
        guard let speed = manager.location?.speed as? Double else {
            throw GPSError.invalidDataFormate
        }
        return speed
    }
    
    func getDistance() throws -> Double {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            throw GPSError.notAuthorized
        }
        let clPrev = CLLocation(latitude: CLLocationDegrees(previous.latitude),
                                      longitude: CLLocationDegrees(previous.longitude))
        guard let distance = manager.location?.distance(from: clPrev) as? Double else {
            throw GPSError.invalidDataFormate
        }
        return distance
    }
    
    func getLocation() throws -> GPS {
        guard manager.authorizationStatus == .authorizedWhenInUse ||
                manager.authorizationStatus == .authorizedAlways else {
            throw GPSError.notAuthorized
        }
            guard let location = manager.location?.coordinate else {
                throw GPSError.unknown
            }
            let gps = GPS(longitude: Float(location.longitude) ,
                          latitude:  Float(location.latitude))
            previous = gps
            return gps
    }
}

extension GPSSensor: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
       if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
           manager.startUpdatingLocation()
           manager.startUpdatingHeading()
       }
    }
}
