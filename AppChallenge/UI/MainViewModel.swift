//
//  MainViewModel.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import UIKit
import Combine

class MainViewModel: ObservableObject {
    var mainCoordinator: MainCoordinator!
    
    let currentWeather = CurrentValueSubject<[WeatherResponse], Never>([WeatherResponse]())
    let focustWeather = CurrentValueSubject<[List], Never>([List]())
    
    let service = GeneralService(networkRequest: NativeRequestable())
    
    var subscriptions = Set<AnyCancellable>()
    
    func getCurrentWeather() {
        service.getCurrentWeather()
            .sink { (completion) in
                switch completion {
                    case .failure(let error): print("error: - CurrentWeather \(error.localizedDescription)")
                    case .finished:
                    break
                }
            } receiveValue: { response in
                self.currentWeather.send(response)
            }
            .store(in: &subscriptions)
    }
    
    func getFocustWeatheer() {
        service.getFocustWeather()
            .sink { (completion) in
                switch completion {
                    case .failure(let error): print("error: \(error.localizedDescription)")
                    case .finished:
                    break
                }
            } receiveValue: { (response) in
                self.focustWeather.send(response.list ?? [List]())
                print(response.list ?? [List]())
            }
            .store(in: &subscriptions)
    }
  
}
