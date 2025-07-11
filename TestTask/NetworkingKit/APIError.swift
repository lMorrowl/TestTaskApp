//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import Foundation
import Alamofire
import Combine

/// Represents possible errors that can occur when performing API calls.
public enum APIError: LocalizedError, Equatable {
    /// Wraps any underlying error.
    case underlying(Error)
    
    /// A known error with a specific message.
    case message(String)
    
    /// Indicates no internet connectivity.
    case noInternetConnection

    public var errorDescription: String? {
        switch self {
        case .underlying(let error):
            return error.localizedDescription
        case .message(let message):
            return message
        case .noInternetConnection:
            return "No internet connection"
        }
    }
    
    public static func ==(lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.noInternetConnection, .noInternetConnection):
            return true
        case (.underlying(let lhsError), .underlying(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.message(let lhsMessage), .message(let rhsMessage)):
            return lhsMessage == rhsMessage
        default :
            return false
        }
    }
}

public extension Publisher where Failure == AFError {
    /// Maps Alamofire's `AFError` into an appropriate `APIError` for unified error handling.
    /// - Returns: A publisher emitting `Output` or failing with `APIError`.
    func mapAFErrorToAPIError() -> AnyPublisher<Output, APIError> {
        return self
            .mapError { afError in
                if let urlError = afError.underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    return .noInternetConnection
                } else {
                    return .underlying(afError)
                }
            }
            .eraseToAnyPublisher()
    }
}
