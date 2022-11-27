//
//  AppError.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Foundation

enum AppError: LocalizedError {
    case errorDecoding
    case unknownError
    case invalidUrl
    case serverError(String)
    
    
    var errorDescription: String? {
        switch self {
            case .errorDecoding:
                return "Response could not be decoded"
            case . unknownError:
                return "Unknow Error"
            case .invalidUrl:
                return "URL is invalid"
            case .serverError(let error):
                return error
        }
    }

}


