//
//  MockURLProtocol.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    static var mockResponse: ((URLRequest) -> (Data?, URLResponse?, Error?))?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = Self.mockResponse else {
            fatalError("No handler set")
        }

        let (data, response, error) = handler(request)

        if let data = data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let response = response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let error = error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() { }
}
