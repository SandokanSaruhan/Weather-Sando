//
//  FirstViewController.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 30.11.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire

var todayWeatherViewModel: TodayWeatherViewModel!

class FirstViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet var weatherImageView: UIImageView!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherConditionLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var precipitationLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // location manager setup
        locationManager.delegate = self
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupActivityIndicator()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let sharedText = "\(todayWeatherViewModel.cityName!.uppercased())'s temperature ---> \(todayWeatherViewModel.temperature!)"
        let activityController = UIActivityViewController(activityItems: [sharedText, todayWeatherViewModel.icon!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    
    func checkPermissions() {
        Coordinate.checkForGrantedLocationPermissions() { [unowned self] allowed in
            if allowed {
                self.getTodayWeather()
            }
            else {
                print("not enable")
            }
        }
    }
    
    func getTodayWeather() {
        toggleRefreshAnimation(on: true)
        DispatchQueue.main.async {
            OpenWeatherMapClient.client.getTodayWeather(at: Coordinate.sharedInstance) {
                [unowned self] currentWeather, error in
                if let currentWeather = currentWeather {
                    todayWeatherViewModel = TodayWeatherViewModel(model: currentWeather)
                    // update UI
                    self.displayWeather(using: todayWeatherViewModel)
                    // save weather
                    FirebaseProvider.Instance.saveCurrentWeather(todayWeather: todayWeatherViewModel)
                    self.toggleRefreshAnimation(on: false)
                }
            }
        }
    }
    
    func displayWeather(using viewModel: TodayWeatherViewModel) {
        self.cityNameLabel.text = viewModel.cityName
        
        self.temperatureLabel.text = viewModel.temperature
        self.weatherConditionLabel.text = viewModel.weatherCondition
        self.humidityLabel.text = viewModel.humidity
        self.precipitationLabel.text = viewModel.precipitationProbability
        self.pressureLabel.text = viewModel.pressure
        self.windSpeedLabel.text = viewModel.windSpeed
        self.windDirectionLabel.text = viewModel.windDirection
        self.weatherImageView.image = viewModel.icon
        
        print (viewModel.cityName)
        print (viewModel.precipitationProbability)
        print (viewModel.pressure)
    }
    
    func setupActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
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

extension FirstViewController: CLLocationManagerDelegate {
    
    // new location data is available
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        // update shaped instance
        Coordinate.sharedInstance.latitude = (manager.location?.coordinate.latitude)!
        Coordinate.sharedInstance.longitude = (manager.location?.coordinate.longitude)!
        // request current weather
        self.getTodayWeather()
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


