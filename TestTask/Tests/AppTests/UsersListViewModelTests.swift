//
//  UsersListViewModelTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Combine
@testable import App
@testable import DomainKit
@testable import NetworkingKit

final class UsersListViewModelTests: XCTestCase {
    
    private var viewModel: UsersListViewModel!
    private var apiClient: MockAPIClient!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        viewModel = UsersListViewModel(apiClient: apiClient)
    }

    func testFetchUsers_appendsUsersAndIncrementsPage() {
        let expectation = self.expectation(description: "Users loaded")

        let usersPage1 = [
            User(id: 1, name: "User 1", email: "user1@test.com", phone: "+380000000001", photo: "", position: "Dev", positionId: 1, registrationTimestamp: 1234)
        ]

        apiClient.fetchUsersResult = Just((usersPage1, true))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        viewModel.fetchUsers()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.users.count, 1)
            XCTAssertEqual(self.viewModel.users[0].name, "User 1")
            XCTAssertFalse(self.viewModel.showNoInternet)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchUsers_noInternet_setsShowNoInternet() {
        let expectation = self.expectation(description: "No internet shown")

        apiClient.fetchUsersResult = Fail(error: .noInternetConnection)
            .eraseToAnyPublisher()

        viewModel.fetchUsers()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showNoInternet)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchUsersReset_clearsUsersAndStartsFromFirstPage() {
        let expectation = self.expectation(description: "Reset fetch works")

        let usersPage1 = [
            User(id: 1, name: "User 1", email: "user1@test.com", phone: "+380000000001", photo: "", position: "Dev", positionId: 1, registrationTimestamp: 1234)
        ]

        apiClient.fetchUsersResult = Just((usersPage1, false))
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        // First page
        viewModel.fetchUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.viewModel.users.count, 1)
            self.viewModel.refresh()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self.viewModel.users.count, 1)
                XCTAssertEqual(self.viewModel.users[0].id, 1)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
}
