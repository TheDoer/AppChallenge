//
//  generalServiceable.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation
import Combine

protocol generalServiceable {
    func getCurrentWeather() -> AnyPublisher<Weather, NetworkError>
    
}

class GeneralService: generalServiceable {
    
    private var networkRequest: Requestable
    
    // inject this for testability
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
    
    func getCurrentWeather() -> AnyPublisher<Weather, NetworkError> {
        let endpoint = GeneralEndpoints.getCurrentWeather
        let request = endpoint.createRequest()
        return self.networkRequest.request(request)
        
    }
    
}
