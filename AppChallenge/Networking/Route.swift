//
//  Route.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation
import CoreLocation

struct endpoints {
    
    static func currentWeather(location: CLLocationCoordinate2D) -> String {
        return "https://api.openweathermap.org/data/2.5/weather?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(Config.APIKey)&units=metric"
    }
    
    static func forecastWeather(location: CLLocationCoordinate2D) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(Config.APIKey)&units=metric"
    }
    
}
