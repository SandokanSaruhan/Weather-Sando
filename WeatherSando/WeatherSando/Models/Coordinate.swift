//
//  Coordinate.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 2.12.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate {
    static var sharedInstance = Coordinate(latitude: 0.0, longitude: 0.0)
    
    static let locationManager = CLLocationManager()
    
    typealias CheckLocationPermissionsCompletionHandler = (Bool) -> Void
    static func checkForGrantedLocationPermissions(completionHandler completion: @escaping CheckLocationPermissionsCompletionHandler) {
        let locationPermissionsStatusGranted = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        
        if locationPermissionsStatusGranted {
            let currentLocation = locationManager.location
            
            print (currentLocation?.coordinate.longitude as Any)
            
            if (currentLocation?.coordinate.longitude==nil){
                print ("simulator cant get location")
                //Minsk Coordinates
                Coordinate.sharedInstance.latitude = 53.9
                Coordinate.sharedInstance.longitude = 27.6
            }
            else{
                Coordinate.sharedInstance.latitude = (currentLocation?.coordinate.latitude)!
                Coordinate.sharedInstance.longitude = (currentLocation?.coordinate.longitude)!
            }
        }
        
        completion(locationPermissionsStatusGranted)
    }
    
    var latitude: Double
    var longitude: Double
}
