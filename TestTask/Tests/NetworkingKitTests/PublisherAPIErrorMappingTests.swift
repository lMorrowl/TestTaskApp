//
//  PublisherAPIErrorMappingTests.swift
//  DomainKitTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Combine
import Alamofire
@testable import NetworkingKit

final class PublisherAPIErrorMappingTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []

    func testMapAFErrorToNoInternet() {
        let urlError = URLError(.notConnectedToInternet)
        let afError = AFError.sessionTaskFailed(error: urlError)

        let expectation = self.expectation(description: "Should receive APIError.noInternetConnection")

        Fail<Void, AFError>(error: afError)
            .mapAFErrorToAPIError()
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        XCTAssertEqual(error, .noInternetConnection)
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in
                    XCTFail("Should not emit value")
                }
            )
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }
}
