//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import Foundation
import Combine
import Alamofire
import DomainKit


/// Interface for making API requests.
public protocol APIClient {
    /// Fetches a paginated list of users.
    /// - Parameter page: The page number to fetch.
    /// - Returns: A publisher emitting a tuple of users and a boolean indicating if more pages are available.
    func fetchUsers(page: Int) -> AnyPublisher<([User], Bool), APIError>
    
    /// Fetches available user positions.
    func fetchPositions() -> AnyPublisher<[Position], APIError>
    
    /// Registers a new user with a multipart/form-data payload.
    /// - Parameter request: User registration request data.
    /// - Returns: A publisher that completes on success or emits an `APIError`.
    func registerUser(request: UserRegistrationRequest) -> AnyPublisher<Void, APIError>
}

public class APIClientImpl: APIClient {
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    private let session: Session

    /// Initializes a new APIClient with custom URLSession configuration and event monitors. To be able to mock URL session in tests.
    public init(configuration: URLSessionConfiguration = .default, eventMonitors: [EventMonitor] = [NetworkLogger()]) {
        let session = Session(configuration: configuration, eventMonitors: eventMonitors)
        self.session = session
    }

    public func fetchUsers(page: Int) -> AnyPublisher<([User], Bool), APIError> {
        let url = "\(baseURL)/users?page=\(page)&count=6"
        return session.request(url)
            .publishDecodable(type: UsersResponse.self)
            .value()
            .map { ($0.users, $0.page < $0.total_pages) }
            .mapAFErrorToAPIError()
            .eraseToAnyPublisher()
    }
    
    public func fetchPositions() -> AnyPublisher<[Position], APIError> {
        let url = "\(baseURL)/positions"
        return session.request(url)
            .validate()
            .publishDecodable(type: PositionsResponse.self)
            .value()
            .map { $0.positions }
            .mapAFErrorToAPIError()
            .eraseToAnyPublisher()
    }

    public func registerUser(request: UserRegistrationRequest) -> AnyPublisher<Void, APIError> {
        let tokenURL = "\(baseURL)/token"
        let registerURL = "\(baseURL)/users"

        // Step 1. Fetching token for user registration.
        return session.request(tokenURL, method: .get)
            .validate()
            .publishDecodable(type: TokenResponse.self)
            .value()
            .mapAFErrorToAPIError()
            .flatMap { tokenResponse -> AnyPublisher<Void, APIError> in
                return Future<Void, APIError> { promise in
                    // Step 2. Posting user with token received in previous step. Token TTL is 40 min.
                    self.session.upload(
                        multipartFormData: { formData in
                            formData.append(Data(request.name.utf8), withName: "name")
                            formData.append(Data(request.email.utf8), withName: "email")
                            formData.append(Data(request.phone.utf8), withName: "phone")
                            formData.append(Data(String(request.positionId).utf8), withName: "position_id")
                            formData.append(request.photo, withName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg")
                        },
                        to: registerURL,
                        method: .post,
                        headers: ["Token": tokenResponse.token]
                    )
                    .validate()
                    .response { response in
                        if let error = response.error {
                            if let data = response.data,
                               let parsed = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                                promise(.failure(APIError.message(parsed.message)))
                            } else {
                                promise(.failure(APIError.underlying(error)))
                            }
                        } else {
                            promise(.success(()))
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
