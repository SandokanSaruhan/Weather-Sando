//
//  Constants.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 2.12.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import Foundation

class Constants {
    
    // MARK: OpenWeatherMap API
    static let API_BASE_URL = "http://api.openweathermap.org/data/2.5/"
    static let API_ENDPOINT_CURRENT_WEATHER = "weather/"
    static let API_ENDPOINT_FORECAST_WEATHER = "forecast/"
    
    // MARK: - Segues
    static let REQUEST_PERMISSIONS_SEGUE_ID = "RequestPermissions"
    static let FORECAST_CELL_SEGUE_ID = "ForecastCell"
    
    
    // MARK: Firebase - Weathers Reference
    static let WEATHER = "weathers"
    
    // Weathers Reference Properties
    static let WEATHER_CITY = "city"
    static let WEATHER_TEMP = "temperature"
    static let WEATHER_CONDITION = "condition"
    static let DATE = "date"
    static let LATITUDE = "lat"
    static let LONGITUDE = "lon"
}
