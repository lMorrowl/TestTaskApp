//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import Foundation

/// A model representing a registered user.
public struct User: Decodable, Identifiable, Equatable {
    /// Unique identifier of the user.
    public let id: Int
    
    /// Full name of the user.
    public let name: String
    
    /// Email address of the user.
    public let email: String
    
    /// Phone number of the user.
    public let phone: String
    
    /// URL string pointing to the user's photo.
    public let photo: String
    
    /// Position name of the user (e.g., job title).
    public let position: String
    
    /// Identifier of the user's position.
    public let positionId: Int
    
    /// UNIX timestamp of the registration date.
    public let registrationTimestamp: Int
    
    public init(id: Int, name: String, email: String, phone: String, photo: String, position: String, positionId: Int, registrationTimestamp: Int) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.photo = photo
        self.position = position
        self.positionId = positionId
        self.registrationTimestamp = registrationTimestamp
    }
    
    /// Coding keys for custom mapping between Swift property names and JSON keys.
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, photo, position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
    }
}

extension User {
    /// A sample user with standard-length fields.
    public static let sample: User = .init(
        id: 1,
        name: "John Doe",
        email: "johndoe@example.com",
        phone: "+1234567890",
        photo: "https://frontend-test-assignment-api.abz.agency/images/users/5fa2a65972a8f5.jpeg",
        position: "Developer",
        positionId: 1,
        registrationTimestamp: 1
    )
    
    /// A sample user with excessively long text values to test layout edge cases.
    public static let sampleLong: User = .init(
        id: 1,
        name: "Seraphina Anastasia Isolde Aurelia Celestina von Hohenzollern",
        email: "seraphina_anastasia_isolde_aurelia_celestina@example.com",
        phone: "+1234567890",
        photo: "",
        position: "Lorem Ipsum Dolor Sit Amet Consectetur Adipiscing Elit",
        positionId: 1,
        registrationTimestamp: 1
    )
}
