//
//  APIClientImplTests.swift
//  NetworkingKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Alamofire
import Combine
@testable import NetworkingKit
@testable import DomainKit

final class APIClientImplTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    private var sut: APIClientImpl!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        sut = APIClientImpl(configuration: config, eventMonitors: [])
    }

    // MARK: - fetchUsers

    func testFetchUsers_success() {
        let json = """
        {
            "users": [{
                "id": 1,
                "name": "Test",
                "email": "test@example.com",
                "phone": "+380123456789",
                "photo": "photo.jpg",
                "position": "QA",
                "position_id": 1,
                "registration_timestamp": 1234
            }],
            "total_pages": 2,
            "page": 1
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockResponse = { _ in
            (
                json,
                HTTPURLResponse(url: URL(string: "https://example.com")!,
                                statusCode: 200,
                                httpVersion: nil,
                                headerFields: nil),
                nil
            )
        }

        let expectation = expectation(description: "Fetch users")

        sut.fetchUsers(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected failure: \(error)")
                }
            }, receiveValue: { users, hasMore in
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.name, "Test")
                XCTAssertTrue(hasMore)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testАetchUsers_returnsNoInternetError() {
        MockURLProtocol.mockResponse = { _ in
            let urlError = URLError(.notConnectedToInternet)
            return (
                nil,
                nil,
                urlError
            )
        }

        let expectation = expectation(description: "Should return no internet")

        sut.fetchUsers(page: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .noInternetConnection)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                }
            }, receiveValue: { _, _ in
                XCTFail("Expected no value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - fetchPositions

    func testFetchPositions_success() {
        let json = """
        {
            "positions": [{
                "id": 1,
                "name": "QA"
            }]
        }
        """.data(using: .utf8)!

        MockURLProtocol.mockResponse = { _ in
            (
                json,
                HTTPURLResponse(url: URL(string: "https://example.com")!,
                                statusCode: 200,
                                httpVersion: nil,
                                headerFields: nil),
                nil
            )
        }

        let expectation = expectation(description: "Fetch positions")

        sut.fetchPositions()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected failure: \(error)")
                }
            }, receiveValue: { positions in
                XCTAssertEqual(positions.count, 1)
                XCTAssertEqual(positions.first?.name, "QA")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchPositions_returnsNoInternetError() {
        MockURLProtocol.mockResponse = { _ in
            let urlError = URLError(.notConnectedToInternet)
            return (
                nil,
                nil,
                urlError
            )
        }

        let expectation = expectation(description: "Should return no internet on fetchPositions")

        sut.fetchPositions()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .noInternetConnection)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                }
            }, receiveValue: { _ in
                XCTFail("Expected no value")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    // MARK: - registerUser

    func testRegisterUser_success() {
        let tokenJSON = """
        {
            "token": "mock-token"
        }
        """.data(using: .utf8)!

        var requestCount = 0
        MockURLProtocol.mockResponse = { request in
            defer { requestCount += 1 }

            if request.url?.absoluteString.contains("/token") == true {
                return (
                    tokenJSON,
                    HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil),
                    nil
                )
            } else if request.url?.absoluteString.contains("/users") == true {
                return (
                    nil,
                    HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil),
                    nil
                )
            }

            return (nil, nil, NSError(domain: "Unexpected", code: 1))
        }

        let expectation = expectation(description: "Register user")

        let req = UserRegistrationRequest(name: "John", email: "john@doe.com", phone: "+380123456789", positionId: 1, photo: Data("image".utf8))

        sut.registerUser(request: req)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            }, receiveValue: {
                XCTAssertEqual(requestCount, 2)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func testRegisterUser_tokenFailure() {
        MockURLProtocol.mockResponse = { _ in
            (
                nil,
                HTTPURLResponse(url: URL(string: "https://example.com")!,
                                statusCode: 500,
                                httpVersion: nil,
                                headerFields: nil),
                NSError(domain: "TestError", code: 123)
            )
        }

        let expectation = expectation(description: "Register user fail")

        let req = UserRegistrationRequest(name: "John", email: "john@doe.com", phone: "+380123456789", positionId: 1, photo: Data("image".utf8))

        sut.registerUser(request: req)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                }
            }, receiveValue: {
                XCTFail("Should not succeed")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
    
    func testRegisterUser_returnsNoInternetError() {
        MockURLProtocol.mockResponse = { _ in
            let urlError = URLError(.notConnectedToInternet)
            return (
                nil,
                nil,
                urlError
            )
        }

        let expectation = expectation(description: "Should return no internet on register")

        let req = UserRegistrationRequest(
            name: "John",
            email: "john@doe.com",
            phone: "+380123456789",
            positionId: 1,
            photo: Data("image".utf8)
        )

        sut.registerUser(request: req)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .noInternetConnection)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure")
                }
            }, receiveValue: {
                XCTFail("Should not succeed")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
