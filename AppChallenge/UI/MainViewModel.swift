//
//  MainViewModel.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import UIKit
import Combine
import CoreLocation

class MainViewModel: ObservableObject {
    var mainCoordinator: MainCoordinator!
    
    enum Input {
        case viewDidAppear
    }
    
    enum Output {
        case fetchCurrentWeatherDidFail(error: Error)
        case fetchCurrentWeatherDidSucceed(weather: CurrentWeather)
    }
    
    //let currentWeather = CurrentValueSubject<[WeatherCurrent], Never>([WeatherCurrent]())
    let focustWeather = CurrentValueSubject<[List], Never>([List]())
    private let output: PassthroughSubject<Output, Never> = .init()
    
    let service = GeneralService(networkRequest: NativeRequestable())

    var subscriptions = Set<AnyCancellable>()
    
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
      input.sink { [weak self] event in
        switch event {
        case .viewDidAppear:
          self?.handleGetCurrentWeather()
        }
      }.store(in: &subscriptions)
      return output.eraseToAnyPublisher()
    }
    
    private func handleGetCurrentWeather() {
        service.getCurrentWeather().sink { [weak self] completion in
        if case .failure(let error) = completion {
            self?.output.send(.fetchCurrentWeatherDidFail(error: error))
        }
      } receiveValue: { [weak self] current in
          self?.output.send(.fetchCurrentWeatherDidSucceed(weather: current))
      }.store(in: &subscriptions)
    }
    
    func getFocustWeather() {
        service.getFocustWeather()
            .sink { (completion) in
                switch completion {
                    case .failure(let error): print("error: \(error.localizedDescription)")
                    case .finished:
                    break
                }
            } receiveValue: { (response) in
                self.focustWeather.send(response.list ?? [List]())
            }
            .store(in: &subscriptions)
    }
    
    
  
}
