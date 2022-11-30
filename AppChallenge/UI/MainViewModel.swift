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

    enum InputCurrent {
        case viewDidAppear
    }
    
    enum OutputCurrent {
        case fetchCurrentWeatherDidFail(error: Error)
        case fetchCurrentWeatherDidSucceed(weather: CurrentWeather)
    }
    
    let focustWeather = CurrentValueSubject<[List], Never>([List]())

    private let output: PassthroughSubject<OutputCurrent, Never> = .init()
   
    var subscriptions = Set<AnyCancellable>()
    
    //EndPoint Service
    let service = GeneralService(networkRequest: NativeRequestable())
    
    func transform(input: AnyPublisher<InputCurrent, Never>) -> AnyPublisher<OutputCurrent, Never> {
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
