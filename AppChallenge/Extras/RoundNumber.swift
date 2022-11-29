//
//  RoundNumber.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 29/11/2022.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Int {
        let divisor = pow(10.0, Double(places))
        return Int((self * divisor ).rounded() / divisor)
    }
}
