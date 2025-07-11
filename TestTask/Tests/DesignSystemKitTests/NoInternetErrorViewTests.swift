//
//  NoInternetErrorViewTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class NoInternetErrorViewTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testNoInternetErrorView() {
        let view = NoInternetErrorView(action: {})
            .frame(width: 300, height: 500)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
