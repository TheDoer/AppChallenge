//
//  APIResponse.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

struct APIResponse<T: Decodable>: Decodable {
    let weather: T?
    let error: String?
    
}
