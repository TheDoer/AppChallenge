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

func getDayForDate(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE" //Saturday, Mar 12
    return formatter.string(from: inputDate)
}

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a" //Nov 30, 9:09 AM
    return (formatter.string(from: Date()) as NSString) as String
}
