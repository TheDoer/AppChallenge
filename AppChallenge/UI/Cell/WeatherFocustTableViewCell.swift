//
//  WeatherFocustTableViewCell.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import UIKit
import Foundation

class WeatherFocustTableViewCell: UITableViewCell {
    static let identifier = String(describing: WeatherFocustTableViewCell.self)
    
    @IBOutlet weak var focustDateLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func focustWeatherSetUp(list: List) {
        focustDateLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(list.dt ?? 0)))
        
        weatherIconImageView.image = UIImage(named: conditionImageName())
        tempLabel.text = Double((list.main?.temp ?? 0)).toStringWithZeroDecimalPlaces() + "°"
        
        func conditionImageName() -> String {
            if let condition = CurrentCondition(rawValue: list.weather?[0].main ?? "") {
                return condition.imageName
            }
            else {
                return "clear"
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
}
