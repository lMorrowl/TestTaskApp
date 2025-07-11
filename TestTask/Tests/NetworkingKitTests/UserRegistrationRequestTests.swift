//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import XCTest
@testable import NetworkingKit

final class UserRegistrationRequestTests: XCTestCase {

    func testEncodingToMultipart() throws {
        let photoData = Data(repeating: 0xFF, count: 10) // simulate small JPEG
        let request = UserRegistrationRequest(
            name: "John Doe",
            email: "john@example.com",
            phone: "+380991112233",
            positionId: 5,
            photo: photoData
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let data = try encoder.encode(request)
        let json = String(data: data, encoding: .utf8)

        XCTAssertTrue(json?.contains("John Doe") ?? false)
        XCTAssertTrue(json?.contains("john@example.com") ?? false)
        XCTAssertTrue(json?.contains("+380991112233") ?? false)
        XCTAssertTrue(json?.contains("5") ?? false)
        XCTAssertTrue(json?.contains("photo") ?? false)
    }
}
