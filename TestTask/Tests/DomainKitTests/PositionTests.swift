//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import XCTest
@testable import DomainKit

final class PositionTests: XCTestCase {

    func testPositionDecoding() throws {
        let json = """
        {
            "id": 1,
            "name": "Developer"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        let position = try decoder.decode(Position.self, from: json)

        XCTAssertEqual(position.id, 1)
        XCTAssertEqual(position.name, "Developer")
    }
}
