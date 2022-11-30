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
        weatherIconImageView.contentMode = .scaleAspectFit
        focustDateLabel.text =  getDayForDate(Date(timeIntervalSinceNow: Double(list.dt ?? Int(0.0))))
        tempLabel.text = "\(Double(list.main?.temp ?? 0).rounded(toPlaces: 0))°"
        
        let icon = list.weather?[0].main?.lowercased()
        
        guard let icon = icon else  {
            return
        }
     
        if (icon.contains("clear")) {
            self.weatherIconImageView.image = UIImage(named: "clear")
        }
        else if (icon.contains("rain")) {
            self.weatherIconImageView.image = UIImage(named: "rain")
        }
        else if (icon.contains("clouds")) {
            self.weatherIconImageView.image = UIImage(named: "partlysunny")
        }
        else {
            self.weatherIconImageView.image = UIImage(named: "partlysunny")
            
        }
    }

}
