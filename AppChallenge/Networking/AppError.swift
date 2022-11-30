//
//  AppError.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

enum AppError: Error {
    case badUrl
    case decodingError
    case badRequest
    case noData
    case customError(Error)
}

extension AppError: LocalizedError {
    
    public var errorDescription: String? {
        return "Something didnt go right. Please try again"
    }
}


