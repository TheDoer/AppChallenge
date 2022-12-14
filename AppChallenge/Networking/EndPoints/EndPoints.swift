//
//  EndPoints.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 1/12/2022.
//

import Foundation
import CoreLocation

public typealias Headers = [String: String]

// if you wish you can have multiple services like this in a project
enum GeneralEndpoints {
    
  // organise all the end points here for clarity
    case getCurrentWeather
    case getFocustWeather
    
  // gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
  //specify the type of HTTP request
    var httpMethod: HTTPMethod {
        switch self {
            case .getCurrentWeather:
                return .GET
            case .getFocustWeather:
                return .GET
        }
    }
    
  // compose the NetworkRequest
    func createRequest() -> NetworkRequest {
        return NetworkRequest(url: getURL(), reqBody: requestBody, httpMethod: httpMethod)
    }
    
  // encodable request body for POST
    var requestBody: Encodable? {
        switch self {

        default:
            return nil
        }
    }
    
    
  // compose urls for each request
    func getURL() -> String {
        switch self {
            case  .getCurrentWeather:
                return "https://api.openweathermap.org/data/2.5/weather?lat=\(Location.shared.lat)&lon=\(Location.shared.lon)&appid=87461c4c288bfbf9413372ba35e10d7c&units=metric"
                
            case .getFocustWeather:
                return "https://api.openweathermap.org/data/2.5/forecast?lat=\(Location.shared.lat)&lon=\(Location.shared.lon)&appid=87461c4c288bfbf9413372ba35e10d7c&units=metric"
        }
    }
}
