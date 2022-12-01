//
//  FocustWeather.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import Foundation

import Foundation

// MARK: - FocustWeatherResponse
 struct FocustWeatherResponse: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]?
    let city: City?
}


// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [WeatherItem]?
    let dtTxt: Date?
}


// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int?
    let tempKf: Double?
}

// MARK: - Weather
struct WeatherItem: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: Description?
    let icon: String?
}


enum Description: Codable {
    case brokenClouds
    case clearSky
    case fewClouds
    case overcastClouds
    case scatteredClouds
}


