//
//  WeatherScreenViewModel.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 30/11/2022.
//

import Foundation
import CoreLocation
import UIKit

protocol WeatherDelegate {
    func fetchWeatherData()
    func errorFetchingWeatherData(error: AppError)
}

class CurrentWeatherViewModel {
    
    var delegate: WeatherDelegate?
    var networkService: NetWorkServiceProtocol?
    private var currentWeather: CurrentWeatherResponse?
    private var forecastWeather = [ForecastWeatherItem]()
    
    private var dispatchGroup = DispatchGroup()
    
    var currentTemp: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.temp.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "-"
        }
    }
    
    var miniTemp: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.tempMin.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "-"
        }
    }
    
    var maxTemp: String {
        if let currentWeather = currentWeather {
            return currentWeather.main.tempMax.toStringWithZeroDecimalPlaces() + "°"
        }
        else {
            return "-"
        }
    }
        
    func `default`() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.displayName
        }
        else {
            return "-"
        }
    }
    
    func backgroundImageName() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.backgroundImageName
        }
        else {
            return "forest_rainy"
        }
    }
    
    func backgroundColor() -> UIColor {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather[0].main) {
            return condition.backgroundColor
        }
        else {
            return UIColor(rgb: 0x57575D)
        }
    }
    
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return forecastWeather.count
    }
    
    func forecastWeatherAtIndex(_ index: Int) -> ForecastWeatherItemViewModel {
        let forecastWeatherItem = forecastWeather[index]
        return ForecastWeatherItemViewModel(forecastWeatherItem)
    }
    
    
    //MARK: - Network functions
    func getWeatherData(location: CLLocationCoordinate2D) {
        
        getCurrentWeather(location: location)
        getForecastWeather(location: location)
        
        self.dispatchGroup.notify(queue: .main) {
            if self.currentWeather != nil, self.forecastWeather.count > 0 {
                self.delegate?.fetchWeatherData()
            }
        }
    }
    
    private func getCurrentWeather(location: CLLocationCoordinate2D) {
        self.dispatchGroup.enter()
        networkService?.getCurrentWeather(location: location) { result in
            switch result {
            case let .success(currentWeatherResponse):
                self.currentWeather = currentWeatherResponse
            case let .failure(error):
                self.delegate?.errorFetchingWeatherData(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func getForecastWeather(location: CLLocationCoordinate2D) {
        self.dispatchGroup.enter()
        networkService?.getForecastWeather(location: location) { result in
            switch result {
            case let .success(forecastWeatherResponse):
                if let response = forecastWeatherResponse {
                    let indexSet: IndexSet = self.createIndexSet(numberOfItems: response.list.count)
                    self.forecastWeather = indexSet.map { response.list[$0] }
                }
            case let .failure(error):
                self.delegate?.errorFetchingWeatherData(error: error)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func createIndexSet(numberOfItems: Int) -> IndexSet {
        let move = (numberOfItems) / 5
        var value = move
        var array = [Int]()
        
        for _ in 0..<5 {
            array.append(value-1)
            value = value + move
        }
        
        return IndexSet(array)
    }
    
}



