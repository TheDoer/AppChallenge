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
    
    func focustWeatherSetUp(list: ForecastWeatherItemViewModel) {
        func configureCell(viewModel: ForecastWeatherItemViewModel) {
            focustDateLabel.text = viewModel.day
            weatherIconImageView.image = UIImage(named: viewModel.conditionImageName())
            tempLabel.text = viewModel.temperature
        }
    }

}
