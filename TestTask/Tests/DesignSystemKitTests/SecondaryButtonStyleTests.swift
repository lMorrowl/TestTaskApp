//
//  SecondaryButtonStyleTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class SecondaryButtonStyleTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testSecondaryButton_enabled() {
        let view = Button("Secondary") {}
            .buttonStyle(SecondaryButtonStyle())
            .frame(width: 200, height: 50)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }

    func testSecondaryButton_disabled() {
        let view = Button("Disabled") {}
            .buttonStyle(SecondaryButtonStyle())
            .disabled(true)
            .frame(width: 200, height: 50)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
