//
//  ForecastWeatherItemViewModel.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 1/12/2022.
//

import Foundation

struct ForecastWeatherItemViewModel {
    
    init(_ forecastWeatherItem: List) {
        self.forecastWeatherItem = forecastWeatherItem
    }
    
    private var forecastWeatherItem: List
    
    
    var temperature: String {
        return (forecastWeatherItem.main?.temp?.toStringWithZeroDecimalPlaces() ?? "0") + "°"
    }
    
    func conditionImageName() -> String {
        if let condition = CurrentCondition(rawValue: forecastWeatherItem.weather?[0].main ?? "") {
            return condition.imageName
        }
        else {
            return "clear"
        }
    }
}

enum CurrentCondition: String {
    case cloudy = "Clouds"
    case rainy = "Rain"
    case clear = "Clear"
    
    var displayName: String {
        switch self {
            case .cloudy:
                return "Cloudy"
            case .rainy:
                return "Rainy"
            case .clear:
                return "Sunny"
        }
    }
    
    var imageName: String {
        switch self {
            case .cloudy:
                return "partlysunny"
            case .rainy:
                return "rain"
            case .clear:
                return "clear"
        }
    }
    
    var backgroundColorHexValue: Int {
        switch self {
            case .clear:
                return 0x47AB2F
            case .rainy:
                return 0x57575D
            case .cloudy:
                return 0x54717A
        }
    }
    
    var backgroundImageName: String {
        switch self {
            case .cloudy:
                return "forest_cloudy"
            case .rainy:
                return "forest_rainy"
            case .clear:
                return "forest_sunny"
        }
    }
    
}
