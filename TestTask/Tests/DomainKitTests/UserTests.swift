//
//  UserTests.swift
//  DomainKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
@testable import DomainKit

final class UserTests: XCTestCase {

    func testUserDecoding() throws {
        let json = """
        {
            "id": 123,
            "name": "Alice Smith",
            "email": "alice@example.com",
            "phone": "+380991112233",
            "photo": "https://example.com/photo.jpg",
            "position": "Designer",
            "position_id": 1,
            "registration_timestamp": 1234
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let user = try decoder.decode(User.self, from: json)

        XCTAssertEqual(user.id, 123)
        XCTAssertEqual(user.name, "Alice Smith")
        XCTAssertEqual(user.email, "alice@example.com")
        XCTAssertEqual(user.phone, "+380991112233")
        XCTAssertEqual(user.photo, "https://example.com/photo.jpg")
        XCTAssertEqual(user.position, "Designer")
        XCTAssertEqual(user.positionId, 1)
        XCTAssertEqual(user.registrationTimestamp, 1234)
    }
}
