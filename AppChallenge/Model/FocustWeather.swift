//
//  FocustWeather.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import Foundation

struct ForecastWeatherResponse: Decodable {
    var list: [ForecastWeatherItem]
}

struct ForecastWeatherItem: Decodable {
    var main: Main
    var weather: [Weather]
    var dtTxt: Date
}
