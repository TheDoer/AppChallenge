//
//  DateFormatter.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 28/11/2022.
//

import Foundation

func getDayForDate(_ date: Date?) -> String {
    guard let inputDate = date else {
        return ""
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE" // Monday
    return formatter.string(from: inputDate)
}

func generateCurrentTimeStamp () -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a" //Nov 30, 9:09 AM
    return (formatter.string(from: Date()) as NSString) as String
}
