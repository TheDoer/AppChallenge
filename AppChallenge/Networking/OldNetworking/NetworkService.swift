//
//  NetworkService.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation
import CoreLocation



/// A resource object to be created when making network calls
struct Resource<T> {
    let urlString: String
    let parse: (Data) -> T?
}


///This is a protocol that the WebService will conform to so as to allow us to mock it for testing purposes
protocol WebServiceProtocol {
    func getCurrentWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<CurrentWeatherResponse?, AppError>) -> Void)
    func getForecastWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<ForecastWeatherResponse?, AppError>) -> Void)
}


/// The class responsible for all network calls within the app
final class NetworkService: WebServiceProtocol {
    
    /// Generic network caller that can take in and return any type of object
    /// - Parameters:
    ///    - resource: object of type Resource to be used for the network call
    ///    - completion: Code to be executed by the caller. Will contain type Result
    func load<T>(resource: Resource<T>, completion: @escaping (Result<T?, AppError>) -> Void) {
        
        guard let url = URL(string: resource.urlString) else {
            completion(.failure(.badUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.customError(error)))
                return
            }
            
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(.badRequest))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            completion(.success(resource.parse(data)))
            
        }.resume()
    }

    
    /// Fetch the current weather for a given location
    /// - Parameters:
    ///   - location: A CLLocation object containing the current location of the device
    ///   - completion: Callback with either the current weather resource or a Network Error
    func getCurrentWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<CurrentWeatherResponse?, AppError>) -> Void) {
        
        let url = Urls.currentWeatherUrl(location: location)
        let resource = Resource<CurrentWeatherResponse>(urlString: url) { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let weatherResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
                return weatherResponse
            }
            catch {
                print(error)
            }
           
            return nil
        }
        
        load(resource: resource) { result in
            switch result {
            case let .success(currentWeatherResponse):
                completion(.success(currentWeatherResponse))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    /// Fetch the forecasr weather for a given location
    /// - Parameters:
    ///   - location: A CLLocation object containing the current location of the device
    ///   - completion: Callback with either the forecast weather resource or a Network Error
    func getForecastWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<ForecastWeatherResponse?, AppError>) -> Void) {
        
        let url = Urls.forecastWeather(location: location)
        let resource = Resource<ForecastWeatherResponse>(urlString: url) { data in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.setDateDecodingStrategy()
            let forecastWeatherResponse = try? decoder.decode(ForecastWeatherResponse.self, from: data)
            return forecastWeatherResponse
        }
        
        load(resource: resource) { result in
            switch result {
            case let .success(forecastWeatherResponse):
                completion(.success(forecastWeatherResponse))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
