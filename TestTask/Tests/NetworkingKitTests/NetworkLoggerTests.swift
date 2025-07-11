//
//  NetworkLoggerTests.swift
//  DomainKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Alamofire
@testable import NetworkingKit

final class NetworkLoggerTests: XCTestCase {
    func testLoggingEnabled_logsCorrectly() {
        let exp1 = expectation(description: "requestDidResume")
        let exp2 = expectation(description: "didParseResponse")

        let logger = NetworkLogger(isLoggingEnabled: true) { log in
            if log.contains("Resuming request") {
                exp1.fulfill()
            } else if log.contains("Finished request") {
                exp2.fulfill()
            }
        }

        let request = AF.request(DummyRequestConvertible())
        let response = DataResponse<String, AFError>(
            request: nil,
            response: nil,
            data: nil,
            metrics: nil,
            serializationDuration: 0,
            result: .success("OK")
        )

        logger.requestDidResume(request)
        logger.request(request, didParseResponse: response)

        wait(for: [exp1, exp2], timeout: 1)
    }
    
    func testLoggingDisabled_doesNotLog() {
        let logger = NetworkLogger(isLoggingEnabled: false) { _ in
            XCTFail("Log handler should not be called")
        }

        let request = AF.request(DummyRequestConvertible())
        let response = DataResponse<String, AFError>(
            request: nil,
            response: nil,
            data: nil,
            metrics: nil,
            serializationDuration: 0,
            result: .success("ok")
        )

        logger.requestDidResume(request)
        logger.request(request, didParseResponse: response)

        // no expectation needed — test passes if nothing crashes or logs
    }
}

struct DummyRequestConvertible: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: URL(string: "https://example.com")!)
    }
}
