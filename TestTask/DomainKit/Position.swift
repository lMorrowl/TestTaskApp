//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import Foundation

/// A model representing a user position (e.g., job role).
public struct Position: Decodable, Identifiable {
    /// Unique identifier of the position.
    public let id: Int
    
    /// Name or title of the position.
    public let name: String
}
