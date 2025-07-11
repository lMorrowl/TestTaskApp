//
//  DTOTests.swift
//  DomainKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import DomainKit
@testable import NetworkingKit

final class DTOTests: XCTestCase {

    func testUsersResponseDecoding() throws {
        let json = """
        {
            "users": [
                {
                    "id": 1,
                    "name": "User 1",
                    "email": "user1@example.com",
                    "phone": "+380111111111",
                    "photo": "https://example.com/1.jpg",
                    "position": "Developer",
                    "position_id": 1,
                    "registration_timestamp": 1234
                }
            ],
            "total_pages": 2,
            "page": 1
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(UsersResponse.self, from: json)
        XCTAssertEqual(response.users.count, 1)
        XCTAssertEqual(response.total_pages, 2)
        XCTAssertEqual(response.page, 1)
    }

    func testPositionsResponseDecoding() throws {
        let json = """
        {
            "positions": [
                { "id": 1, "name": "QA" },
                { "id": 2, "name": "Designer" }
            ]
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(PositionsResponse.self, from: json)
        XCTAssertEqual(response.positions.count, 2)
    }

    func testTokenResponseDecoding() throws {
        let json = """
        {
            "token": "abc123token"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(TokenResponse.self, from: json)
        XCTAssertEqual(response.token, "abc123token")
    }

    func testErrorResponseDecoding() throws {
        let json = """
        {
            "message": "Something went wrong"
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(ErrorResponse.self, from: json)
        XCTAssertEqual(response.message, "Something went wrong")
    }
}
