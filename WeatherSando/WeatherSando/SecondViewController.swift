//
//  SecondViewController.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 30.11.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire

class SecondViewController: UIViewController {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var forecastWeatherViewModels: [ForecastWeatherViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location manager setup
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //internet check with alamofire
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            self.checkPermissions()
        }
        else{
            print("No! internet is not available.")
            self .alertInternetAccessNeeded()
        }
    }
    
    // MARK: - Internet Methods
    class Connectivity {
        class var isConnectedToInternet:Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
    func alertInternetAccessNeeded() {
        
        let alert = UIAlertController(
            title: "Need Interet Access",
            message: "Internet access is required",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - View Methods
    func checkPermissions() {
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                self.locationManager.requestLocation()
                self.getForecastWeather()
            }
            else {
                    print("not enable")
            }
        }
    }
    
    func getForecastWeather() {
        toggleRefreshAnimation(on: true)
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getForecastWeather(at: Coordinate.sharedInstance) {
                [unowned self] forecastsWeather, error in
                if let forecastsWeather = forecastsWeather {
                    // reset self.forecastWeatherViewModels to avoid repeat items
                    if forecastsWeather.count > 0 {
                        self.forecastWeatherViewModels = []
                    }
                    
                    for forecastWeather in forecastsWeather {
                        let forecastWeatherVM = ForecastWeatherViewModel(model: forecastWeather)
                        self.forecastWeatherViewModels.append(forecastWeatherVM)
                    }
                    
                    self.tableView.reloadData()
                    self.toggleRefreshAnimation(on: false)
                }
            }
        }
    }
    
    func toggleRefreshAnimation(on: Bool) {
        if on {
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
        else {
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastWeatherViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecastWeatherViewModel = self.forecastWeatherViewModels[indexPath.row]
        
        // Dequeue Reusable Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FORECAST_CELL_SEGUE_ID, for: indexPath) as! ForecastDayTableViewCell
        
        // Configure Cell
        cell.weatherConditionImageView.image = forecastWeatherViewModel.icon
        cell.weekdayLabel.text = forecastWeatherViewModel.weekday
        cell.weatherConditionLabel.text = forecastWeatherViewModel.weatherCondition
        cell.temperatureLabel.text = forecastWeatherViewModel.temperature
        
        print (forecastWeatherViewModel.weekday)
        
        return cell
    }
}

extension SecondViewController: CLLocationManagerDelegate {
    // new location data is available
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // update shaped instance
        Coordinate.sharedInstance.latitude = (manager.location?.coordinate.latitude)!
        Coordinate.sharedInstance.longitude = (manager.location?.coordinate.longitude)!
        // request forecast weather
        self.getForecastWeather()
    }
    
    // the location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        Coordinate.checkForGrantedLocationPermissions() { allowed in
            if !allowed {
                print("not enable")
            }
        }
    }
}
