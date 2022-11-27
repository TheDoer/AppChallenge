//
//  String+Extension.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}

