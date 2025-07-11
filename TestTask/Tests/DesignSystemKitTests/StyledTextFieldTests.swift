//
//  StyledTextFieldTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class StyledTextFieldTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testStyledTextField_normal() {
        let view = StyledTextField(
            title: "Normal",
            text: .constant("Some text"),
            isValid: .constant(true)
        )
        .frame(width: 300)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }

    func testStyledTextField_invalid_withHint() {
        let view = StyledTextField(
            title: "Invalid",
            text: .constant(""),
            isValid: .constant(false),
            hintText: "Required field"
        )
        .frame(width: 300)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }

    func testStyledTextField_phone_withHint() {
        let view = StyledTextField(
            title: "Phone",
            text: .constant(""),
            isValid: .constant(true),
            keyboardType: .phonePad,
            hintText: "+7 (123) 456-78-90"
        )
        .frame(width: 300)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
