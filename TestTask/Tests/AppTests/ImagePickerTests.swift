//
//  ImagePickerTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import UIKit
import SwiftUI
@testable import App

final class ImagePickerTests: XCTestCase {
    
    func testUpdateParentWithImage_validImage_setsDataAndValidTrue() {
        var imageData: Data? = nil
        var isValid = false
        let bindingData = Binding<Data?>(get: { imageData }, set: { imageData = $0 })
        let bindingValid = Binding<Bool>(get: { isValid }, set: { isValid = $0 })

        let image = makeImage(width: 100, height: 100)
        let picker = ImagePicker(imageData: bindingData, isDataValid: bindingValid, sourceType: .camera)
        let coordinator = ImagePicker.Coordinator(picker)
        
        coordinator.updateParentWithImage(image)
        
        XCTAssertNotNil(imageData)
        XCTAssertTrue(isValid)
    }
    
    func testUpdateParentWithImage_smallImage_setsValidFalse() {
        var imageData: Data? = nil
        var isValid = true // deliberately true to see if it flips
        let bindingData = Binding<Data?>(get: { imageData }, set: { imageData = $0 })
        let bindingValid = Binding<Bool>(get: { isValid }, set: { isValid = $0 })

        let image = makeImage(width: 10, height: 10) // < 70
        let picker = ImagePicker(imageData: bindingData, isDataValid: bindingValid, sourceType: .photoLibrary)
        let coordinator = ImagePicker.Coordinator(picker)
        
        coordinator.updateParentWithImage(image)
        
        XCTAssertNotNil(imageData)
        XCTAssertFalse(isValid)
    }

    func testUpdateParentWithImage_largeFile_setsValidFalse() {
        var imageData: Data? = nil
        var isValid = true
        let bindingData = Binding<Data?>(get: { imageData }, set: { imageData = $0 })
        let bindingValid = Binding<Bool>(get: { isValid }, set: { isValid = $0 })

        let image = makeSolidColorImage(size: CGSize(width: 10000, height: 10000)) // huge
        let picker = ImagePicker(imageData: bindingData, isDataValid: bindingValid, sourceType: .camera)
        let coordinator = ImagePicker.Coordinator(picker)
        
        coordinator.updateParentWithImage(image)
        
        XCTAssertNotNil(imageData)
        XCTAssertFalse(isValid)
    }

    // MARK: - Helpers

    private func makeImage(width: CGFloat, height: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: width, height: height))
        }
    }

    private func makeSolidColorImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { ctx in
            UIColor.black.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
