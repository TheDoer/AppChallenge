//
//  FocustWeather.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import Foundation

// MARK: - FocustWeather
struct FocustWeather: Codable {
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

// MARK: - Coord
struct Coord: Codable {
    let lat: Double?
    let lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainFocust?
    let weather: [WeatherFocust]?
}

// MARK: - Main
struct MainFocust: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
}

// MARK: - Weather
struct WeatherFocust: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
}
