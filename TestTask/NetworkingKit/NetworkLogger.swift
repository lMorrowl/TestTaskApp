//
//  APIError.swift
//  NetworkingKit
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import Foundation
import Alamofire

/// A custom event monitor for logging Alamofire network requests and responses.
public final class NetworkLogger: EventMonitor {
    /// Indicates whether logging is enabled.
    private let isLoggingEnabled: Bool
    
    /// Closure used for handling log messages.
    private let logHandler: @Sendable (String) -> Void

    /// Initializes the logger.
    /// - Parameters:
    ///   - isLoggingEnabled: Whether logging is active (default is `true`).
    ///   - logHandler: A closure to handle log output (defaults to `print`).
    public init(isLoggingEnabled: Bool = true, logHandler: @escaping @Sendable (String) -> Void = { print($0) }) {
        self.isLoggingEnabled = isLoggingEnabled
        self.logHandler = logHandler
    }

    /// Called when a request starts.
    public func requestDidResume(_ request: Request) {
        guard isLoggingEnabled else { return }
        logHandler("Resuming request: \(request)")
    }

    /// Called when a response is received and parsed.
    public func request<Value>(_ request: DataRequest,
                               didParseResponse response: DataResponse<Value, AFError>) {
        guard isLoggingEnabled else { return }
        logHandler("Finished request: \(response)")
    }
}
