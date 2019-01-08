//
//  WeatherIcon.swift
//  WeatherSando
//
//  Created by Saruhan Köle on 2.12.2018.
//  Copyright © 2018 Saruhan Köle. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIcon {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstorm
    case snow
    case mist
    case clearSkyNight
    case fewCloudsNight
    case scatteredCloudsNight
    case brokenCloudsNight
    case showerRainNight
    case rainNight
    case thunderstormNight
    case snowNight
    case mistNight
    case `default`
    
    init(iconString: String) {
        switch iconString {
        case "01d": self = .clearSky
        case "02d": self = .fewClouds
        case "03d": self = .scatteredClouds
        case "04d": self = .brokenClouds
        case "09d": self = .showerRain
        case "10d": self = .rain
        case "11d": self = .thunderstorm
        case "13d": self = .snow
        case "50d": self = .mist
        case "01n": self = .clearSkyNight
        case "02n": self = .fewCloudsNight
        case "03n": self = .scatteredCloudsNight
        case "04n": self = .brokenCloudsNight
        case "09n": self = .showerRainNight
        case "10n": self = .rainNight
        case "11n": self = .thunderstormNight
        case "13n": self = .snowNight
        case "50n": self = .mistNight
        default: self = .default
        }
    }
}

extension WeatherIcon {
    var image: UIImage {
        switch self {
        case .clearSky: return #imageLiteral(resourceName: "ClearSkyIcon")
        case .fewClouds: return #imageLiteral(resourceName: "FewCloudsIcon")
        case .scatteredClouds: return #imageLiteral(resourceName: "ScatteredCloudsIcon")
        case .brokenClouds: return #imageLiteral(resourceName: "BrokenCloudsIcon")
        case .showerRain: return #imageLiteral(resourceName: "ShowerRainIcon")
        case .rain: return #imageLiteral(resourceName: "RainIcon")
        case .thunderstorm: return #imageLiteral(resourceName: "RainIcon")
        case .snow: return #imageLiteral(resourceName: "SnowIcon")
        case .mist: return #imageLiteral(resourceName: "MistIcon")
        case .clearSkyNight: return #imageLiteral(resourceName: "ClearSkyNight")
        case .fewCloudsNight: return #imageLiteral(resourceName: "FewCloudsNight")
        case .scatteredCloudsNight: return #imageLiteral(resourceName: "ScatteredCloudsNight")
        case .brokenCloudsNight: return #imageLiteral(resourceName: "BrokenCloudsNight")
        case .showerRainNight: return #imageLiteral(resourceName: "ShowerRainNight")
        case .rainNight: return #imageLiteral(resourceName: "RainNight")
        case .thunderstormNight: return #imageLiteral(resourceName: "ThunderStormNight")
        case .snowNight: return #imageLiteral(resourceName: "SnowNight")
        case .mistNight: return #imageLiteral(resourceName: "MistNight")
        case .default: return #imageLiteral(resourceName: "ClearSkyIcon")
        }
    }
}
