//
//  SelectionCellViewTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import DesignSystemKit

final class SelectionCellViewTests: XCTestCase {
    // MARK: - Snapshot recording toggle (true = will update snapshots)
    static let isRecording = false

    func testSelectionCell_selected() {
        let view = SelectionCellView(title: "Selected", isSelected: true)
            .frame(width: 300)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }

    func testSelectionCell_unselected() {
        let view = SelectionCellView(title: "Unselected", isSelected: false)
            .frame(width: 300)

        assertSnapshot(
            of: view,
            as: .image,
            record: Self.isRecording
        )
    }
}
