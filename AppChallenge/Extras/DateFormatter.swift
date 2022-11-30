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

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a" //Nov 30, 9:09 AM
    return (formatter.string(from: Date()) as NSString) as String
}
