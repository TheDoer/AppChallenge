//
//  WeatherResponse.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 26/11/2022.
//

import Foundation

// MARK: - WeatherResponse
public struct WeatherResponse: Codable {
    let weather: [WeatherCurrent]?
    let base: String?
    let main: Main?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?

}

// MARK: - Main
public struct Main: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let grndLevel: Int?
}

// MARK: - Sys
public struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}

// MARK: - Weather
public struct WeatherCurrent: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
}

// MARK: - Wind
public struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?

}

