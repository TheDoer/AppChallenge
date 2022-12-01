//
//  MainViewModel.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 1/12/2022.
//

import Foundation
import UIKit
import Combine

class MainViewModel: ObservableObject {
    private var currentWeather: CurrentWeatherResponse?
    
    let service = GeneralService(networkRequest: NativeRequestable())
    var subscriptions = Set<AnyCancellable>()
    
    //Current
    private let currentWeatherItems: PassthroughSubject<CurrentWeatherItems, Never> = .init()
    
    //Focust
    let focustWeatherItems = CurrentValueSubject<[List] , Never>([List]())
    //let errorFound = CurrentValueSubject<String, Never>(String())
    
    enum Input {
      case viewDidAppear
    }
    enum CurrentWeatherItems {
      case fetchCurrentDidFail(error: Error)
      case fetchCurrentDidSucceed(currentWeather: CurrentWeatherResponse)

    }
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<CurrentWeatherItems, Never> {
      input.sink { [weak self] currentWeather in
        switch currentWeather {
        case .viewDidAppear:
          self?.handleGetCurrentWeather()
        }
      }.store(in: &subscriptions)
      return currentWeatherItems.eraseToAnyPublisher()
    }
    
    private func handleGetCurrentWeather() {
        service.getCurrentWeather()
            .sink { [weak self] completion in
        if case .failure(let error) = completion {
          self?.currentWeatherItems.send(.fetchCurrentDidFail(error: error))
        }
      } receiveValue: { [weak self] current in
          self?.currentWeatherItems.send(.fetchCurrentDidSucceed(currentWeather: current))
      }.store(in: &subscriptions)
    }
    
    func handleFocustWeather() {
        service.getFocustWeather()
            .sink {  [weak self] (completion) in
                switch (completion) {
                    case .failure(let error):
                        print("we got an error \(error.localizedDescription)")
                        
                    case .finished:
                        print("nothing much to do here")
                }
            } receiveValue: { (response) in
                self.focustWeatherItems.send(response.list ?? [])
            }.store(in: &subscriptions)

    }
    
    func backgroundImageName() -> String {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather?[0].main ?? "forest_rainy") {
            return condition.backgroundImageName
        }
        else {
            return "forest_rainy"
        }
    }
    
    
    func backgroundColorHexValue() -> Int {
        if let currentWeather = currentWeather, let condition = CurrentCondition(rawValue: currentWeather.weather?[0].main ?? "Clouds") {
            return condition.backgroundColorHexValue
        }
        else {
            return 0x57575D
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
    

 
}


