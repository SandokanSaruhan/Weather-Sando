//
//  ForecastWeather.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 2.12.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import Foundation
struct ForecastWeather {
    var date: Double = Double.infinity
    var temperature: Double = Double.infinity
    var weatherCondition: String = ""
    var icon: String = ""
}

extension ForecastWeather {
    
    struct Key {
        static let date = "dt"
        // temp
        static let tempKey = "main"
        static let temperatureday = "temp"
        
        // weather[0]
        static let weatherKey = "weather"
        static let weatherCondition = "main"
        static let icon = "icon"
    }
    
    init?(json: [String: AnyObject]) {
        if let dateValue = json[Key.date] as? Double {
            self.date = dateValue
        }
        
        if let main = json[Key.tempKey] as? Dictionary<String, AnyObject> {
            if let temperatureValue = main[Key.temperatureday] as? Double {
                self.temperature = temperatureValue
            }
        }
        
        if let weather = json[Key.weatherKey] as? [Dictionary<String, AnyObject>] {
            if let weatherConditionValue = weather[0][Key.weatherCondition] as? String {
                self.weatherCondition = weatherConditionValue
            }
            
            if let iconValue = weather[0][Key.icon] as? String {
                self.icon = iconValue
            }
        }
    }
    
}

