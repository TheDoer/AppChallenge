//
//  APIResponse.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

struct APIResource<T> {
    let urlString: String
    let parse: (Data) -> T?
}
