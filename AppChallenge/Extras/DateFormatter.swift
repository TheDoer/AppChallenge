//
//  DateFormatter.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import Foundation

extension JSONDecoder {

    func setDateDecodingStrategy() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.dateDecodingStrategy = .formatted(dateFormatter)
    }
   
}

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
