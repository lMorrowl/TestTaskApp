//
//  UserRegistrationRequest.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import Foundation

/// A model representing the data required to register a new user.
/// Used as the payload for the user registration API.
public struct UserRegistrationRequest: Encodable, Equatable {
    /// The user's full name, should be 2-60 characters.
    public let name: String
    
    /// The user's email address, must be a valid email according to RFC2822
    public let email: String
    
    /// The user's phone number, should start with code of Ukraine +380.
    public let phone: String
    
    /// The identifier of the selected position.
    public let positionId: Int
    
    /// The user's profile photo in JPEG format, should be jpg/jpeg image, with resolution at least 70x70px and size must not exceed 5MB.
    public let photo: Data
    
    public init(name: String, email: String, phone: String, positionId: Int, photo: Data) {
        self.name = name
        self.email = email
        self.phone = phone
        self.positionId = positionId
        self.photo = photo
    }
}
