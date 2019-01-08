//
//  OpenWeatherMapClient.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 2.12.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import Foundation
import Alamofire

class OpenWeatherMapClient {
    static let client = OpenWeatherMapClient()
    
    fileprivate let apiKey = "67baa261ccbfd6c99703333a6dc8a562"
    
    lazy var baseUrl: URL = {
        return URL(string: Constants.API_BASE_URL)!
    }()
    
    
    typealias TodayWeatherCompletionHandler = (TodayWeather?, OpenWeatherMapError?) -> Void
    typealias ForecastWeatherCompletionHandler = ([ForecastWeather]?, OpenWeatherMapError?) -> Void
    
    func getTodayWeather(at coordinate: Coordinate, completionHandler completion: @escaping TodayWeatherCompletionHandler) {
        
        guard let url = URL(string: Constants.API_ENDPOINT_CURRENT_WEATHER, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let parameters: Parameters = self.buildParameters(coordinate: coordinate)
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let JSON = response.result.value as? Dictionary<String, AnyObject> else {
                completion(nil, .invalidaData)
                return
            }
            
            print (url)
            print (parameters)
            print (JSON)
            
            if response.response?.statusCode == 200 {
                guard let currentWeather = TodayWeather(json: JSON) else {
                    completion(nil, .jsonParsingFailure)
                    
                    print (JSON)
                    return
                }
                
                completion(currentWeather, nil)
            }
            else {
                completion(nil, .responseUnsuccessful)
            }
        }
    }
    
    //Alamofire
    func getForecastWeather(at coordinate: Coordinate, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        
        guard let url = URL(string: Constants.API_ENDPOINT_FORECAST_WEATHER, relativeTo: baseUrl) else {
            completion(nil, .invalidUrl)
            return
        }
        
        let parameters: Parameters = self.buildParameters(coordinate: coordinate)
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let JSON = response.result.value else {
                completion(nil, .invalidaData)
                return
            }
            
            print (url)
            print (parameters)
            print (JSON)
            
            if response.response?.statusCode == 200 {
                var forecasts: [ForecastWeather] = []
                
                print (JSON)
                
                if let dict = JSON as? Dictionary<String, AnyObject>{
                    if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                        for obj in list {
                            let forecast = ForecastWeather(json: obj)
                            forecasts.append(forecast!)
                        }
                    }
                }
                
                completion(forecasts, nil)
            }
            else {
                completion(nil, .responseUnsuccessful)
            }
        }
    }
    
    
    
    //Classic Method (Non Alomofire)
    /*
     func getForecastWeather(at coordinate: Coordinate, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
     
     var forecasts: [ForecastWeather] = []
     
     let parameters: Parameters = self.buildParameters(coordinate: coordinate)
     
     print (parameters)
     print (parameters["appid"] ?? NSString())
     
     //let sampleUrlString = "http://api.openweathermap.org/data/2.5/forecast?lat=41.0098876953125&lon=28.8713888390362&units=metric&APPID=67baa261ccbfd6c99703333a6dc8a562"
     
     let urlString = NSString(format:"%@%@%@%@%@%@%@%@%@", "http://api.openweathermap.org/data/2.5/forecast?", "lat=", (parameters["lat"]  as! String), "&lon=", (parameters["lon"]  as! String), "&units=", (parameters["units"] as! String), "&APPID=", (parameters["appid"] as! String))
     
     print (urlString)
     
     guard let url = URL(string: urlString as String) else { return }
     
     URLSession.shared.dataTask(with: url) { (data, response, error) in
     if error != nil {
     print(error!.localizedDescription)
     }
     
     guard let data = data else { return }
     
     if let JSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
     
     print (JSON)
     
     if let dict = JSON as? Dictionary<String, AnyObject>{
     if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
     for obj in list {
     let forecast = ForecastWeather(json: obj)
     forecasts.append(forecast!)
     }
     }
     }
     }
     completion(forecasts, nil)
     
     
     }.resume()
     //End implementing URLSession
     }
     */
    
    
    
    func buildParameters(coordinate: Coordinate) -> Parameters {
        let parameters: Parameters = [
            "appid": self.apiKey,
            "units": "metric",
            "lat": String(coordinate.latitude),
            "lon": String(coordinate.longitude)
        ]
        
        return parameters
    }
}
