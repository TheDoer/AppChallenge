//
//  NetworkServiceMock.swift
//  AppChallengeTests
//
//  Created by Adonis Rumbwere on 30/11/2022.
//

import Foundation
import CoreLocation
@testable import AppChallenge

struct NetworkServiceMock: NetWorkServiceProtocol {
    
    let weather = Weather(id: 1, main: "Rain", description: "", icon: "")
    let main = Main(temp: 25.6, tempMin: 31.5, tempMax: 45.6)
    let date = Date()
    
    func getCurrentWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<AppChallenge.CurrentWeatherResponse?, AppChallenge.AppError>) -> Void) {
        
        let currentWeatherResponse = CurrentWeatherResponse(name: "Victoria Falls", weather: [weather], main: main)
        completion(.success(currentWeatherResponse))
    }
    
    func getForecastWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<AppChallenge.ForecastWeatherResponse?, AppChallenge.AppError>) -> Void) {
        
        let forecastWeatherItem = ForecastWeatherItem(main: main, weather: [weather], dtTxt: date)
        let forecastWeatherResponse = ForecastWeatherResponse(list: [forecastWeatherItem, forecastWeatherItem, forecastWeatherItem, forecastWeatherItem, forecastWeatherItem])
        
        completion(.success(forecastWeatherResponse))
        
    }
    
}



