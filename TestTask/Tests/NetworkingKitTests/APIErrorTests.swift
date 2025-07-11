//
//  APIErrorTests.swift
//  DomainKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Alamofire
@testable import NetworkingKit

final class APIErrorTests: XCTestCase {

    func testEquatableCases() {
        let err1 = APIError.message("Something")
        let err2 = APIError.message("Something")
        let err3 = APIError.message("Other")

        XCTAssertEqual(err1, err2)
        XCTAssertNotEqual(err1, err3)
        XCTAssertEqual(APIError.noInternetConnection, .noInternetConnection)

        let afError1 = AFError.explicitlyCancelled
        let afError2 = AFError.explicitlyCancelled
        XCTAssertEqual(APIError.underlying(afError1), APIError.underlying(afError2))
    }

    func testErrorDescription() {
        let error = APIError.message("Oops")
        XCTAssertEqual(error.errorDescription, "Oops")

        let noNet = APIError.noInternetConnection
        XCTAssertEqual(noNet.errorDescription, "No internet connection")
    }
}
