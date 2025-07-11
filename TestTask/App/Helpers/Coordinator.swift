//
//  Coordinator.swift
//  App
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import SwiftUI
import UIKit
import PhotosUI

/// Coordinator class to handle image picking and communication with SwiftUI view.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
    var parent: ImagePicker

    init(_ parent: ImagePicker) {
        self.parent = parent
    }

    /// Creates an alert controller with a given title.
    func alertController(title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }

    /// Handles image selection from the photo picker.
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            if let uiImage = image as? UIImage {
                Task {
                    await MainActor.run { [weak self] in
                        self?.updateParentWithImage(uiImage)
                    }
                }
            }
        }
    }

    /// Handles image selection from the camera picker.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            updateParentWithImage(image)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    /// Validates the selected image and updates the parent view.
    func updateParentWithImage(_ image: UIImage) {
        let sizeInPixels = CGSize(
            width: image.size.width * image.scale,
            height: image.size.height * image.scale
        )
        
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        // Ensure image is at least 70x70 pixels and less than 5MB
        parent.isDataValid = sizeInPixels.width >= 70 && sizeInPixels.height >= 70 && imageData.count < 5 * 1024 * 1024
        parent.imageData = imageData
    }
}
