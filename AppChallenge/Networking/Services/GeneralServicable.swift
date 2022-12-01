//
//  GeneralServicable.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 1/12/2022.
//

import Foundation
import Combine

protocol generalServiceable {
    func getCurrentWeather() -> AnyPublisher<CurrentWeatherResponse, NetworkError>
    func getFocustWeather() -> AnyPublisher<FocustWeatherResponse, NetworkError>
}
class GeneralService: generalServiceable {
    private var networkRequest: Requestable
    
    // inject this for testability
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    func getCurrentWeather() -> AnyPublisher<CurrentWeatherResponse, NetworkError> {
        let endpoint = GeneralEndpoints.getFocustWeather
        let request = endpoint.createRequest()
        return self.networkRequest.request(request)
    }
    
    func getFocustWeather() -> AnyPublisher<FocustWeatherResponse, NetworkError> {
        let endpoint = GeneralEndpoints.getFocustWeather
        let request = endpoint.createRequest()
        return self.networkRequest.request(request)
        
    }
  
}
