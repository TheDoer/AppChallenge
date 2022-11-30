//
//  NetworkServiceProtocol.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 30/11/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCurrentWeather(latitude: Double?, longitude: Double?, completion: @escaping (Result<CurrentWeatherResponse?, AppError>) -> Void)
    func getForecastWeather(latitude: Double?, longitude: Double?, completion: @escaping (Result<ForecastWeatherResponse?, AppError>) -> Void)
}
