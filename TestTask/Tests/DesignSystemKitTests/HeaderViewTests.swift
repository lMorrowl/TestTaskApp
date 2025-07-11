//
//  HeaderViewTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class HeaderViewTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testHeaderView_withMessage() {
        let view = HeaderView(message: "Test Header")
            .frame(width: 300, height: 56)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
