//
//  NetworkService.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation
import CoreLocation

struct APIResource<T> {
    let urlString: String
    let parse: (Data) -> T?
}

protocol WebServiceProtocol {
    func getCurrentWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<CurrentWeatherResponse?, AppError>) -> Void)
    func getForecastWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<ForecastWeatherResponse?, AppError>) -> Void)
}

final class NetworkService: WebServiceProtocol {
    
    func load<T>(resource: APIResource<T>, completion: @escaping (Result<T?, AppError>) -> Void) {
        
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

    func getCurrentWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<CurrentWeatherResponse?, AppError>) -> Void) {
        
        let url = endpoints.currentWeather(location: location)
        let resource = APIResource<CurrentWeatherResponse>(urlString: url) { data in
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
    
    func getForecastWeather(location: CLLocationCoordinate2D, completion: @escaping (Result<ForecastWeatherResponse?, AppError>) -> Void) {
        
        let url = endpoints.forecastWeather(location: location)
        let resource = APIResource<ForecastWeatherResponse>(urlString: url) { data in
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
