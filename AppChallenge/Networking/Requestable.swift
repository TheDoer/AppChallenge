//
//  Requestable.swift
//  AppChallenge
//
//  Created by Adonis Rumbwere on 27/11/2022.
//

import Combine
import Foundation

public protocol Requestable {
    var requestTimeOut: Float { get }
    
    func request<T: Codable>(_ req: NetworkRequest) -> AnyPublisher<T, Error>
}
