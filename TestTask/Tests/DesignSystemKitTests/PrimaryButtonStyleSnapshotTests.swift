//
//  SecondaryButtonStyle.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class PrimaryButtonStyleSnapshotTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testPrimaryButtonStyle_enabled() {
        let view = ZStack {
            Color.white
            Button("Primary") {}
                .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        .frame(width: 200, height: 60)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }

    func testPrimaryButtonStyle_disabled() {
        let view = ZStack {
            Color.white
            Button("Disabled") {}
                .buttonStyle(PrimaryButtonStyle())
                .disabled(true)
        }
        .padding()
        .frame(width: 200, height: 60)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
