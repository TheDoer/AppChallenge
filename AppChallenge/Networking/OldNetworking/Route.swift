//
//  Route.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

enum Route {
    static let baseUrl = "https://api.openweathermap.org/data/2.5"
    
    case fetchDailyWeather
    
    var description: String {
        switch self {
            case .fetchDailyWeather:
                return "/weather?lat=-17.8216&lon=31.0492&appid=87461c4c288bfbf9413372ba35e10d7c"
        }
    }
    
}
