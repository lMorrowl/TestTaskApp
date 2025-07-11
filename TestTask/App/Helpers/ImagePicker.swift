//
//  SignUpViewModelTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 10.07.2025.
//

import SwiftUI
import UIKit
import PhotosUI

/// Enum to represent image source types.
enum ImagePickerSource {
    case camera
    case photoLibrary
}

// A SwiftUI wrapper for UIImagePickerController and PHPickerViewController,
// supporting both camera and photo library as image sources.
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    @Binding var isDataValid: Bool
    var sourceType: ImagePickerSource

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        switch sourceType {
        case .camera:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                // If camera is not available, show an alert
                return context.coordinator.alertController(title: "Camera Not Available")
            }
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .camera
            picker.mediaTypes = ["public.image"]
            return picker
        case .photoLibrary:
            // Create a photo picker configuration
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
