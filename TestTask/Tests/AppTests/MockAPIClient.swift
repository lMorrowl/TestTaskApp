//
//  SignUpViewModelTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import Combine
import DomainKit
@testable import NetworkingKit

final class MockAPIClient: APIClient {

    var fetchUsersResult: AnyPublisher<([User], Bool), APIError> = Just(([], false))
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()

    var fetchPositionsResult: AnyPublisher<[Position], APIError> = Just([])
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()

    var registerUserResult: AnyPublisher<Void, APIError> = Just(())
        .setFailureType(to: APIError.self)
        .eraseToAnyPublisher()

    func fetchUsers(page: Int) -> AnyPublisher<([User], Bool), APIError> {
        return fetchUsersResult
    }

    func fetchPositions() -> AnyPublisher<[Position], APIError> {
        return fetchPositionsResult
    }

    func registerUser(request: UserRegistrationRequest) -> AnyPublisher<Void, APIError> {
        return registerUserResult
    }
}
