//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import Foundation
import DomainKit

/// Response model for the users list API.
/// Contains user array and pagination metadata.
struct UsersResponse: Decodable {
    let users: [User]
    let total_pages: Int
    let page: Int
}


/// Response model for the positions list API.
struct PositionsResponse: Decodable {
    let positions: [Position]
}

/// Response model for the token request used in user registration.
struct TokenResponse: Decodable {
    let token: String
}

/// Response model for error payloads returned by the server.
struct ErrorResponse: Decodable {
    let message: String
}
