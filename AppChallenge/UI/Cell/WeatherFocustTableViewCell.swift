//
//  WeatherFocustTableViewCell.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import UIKit

class WeatherFocustTableViewCell: UITableViewCell {
    static let identifier = String(describing: WeatherFocustTableViewCell.self)
    
    @IBOutlet weak var focustDateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    func focustWeatherSetUp(list: List) {
        focustDateLabel.text =  getDayForDate(Date(timeIntervalSinceNow: Double(list.dt ?? Int(0.0))))
        print(focustDateLabel.text)
        
        tempLabel.text = "\(list.main!.temp)"
        
        
    }
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
    }


}
