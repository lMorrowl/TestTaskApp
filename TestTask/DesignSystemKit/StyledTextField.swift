//
//  AddUserFailureView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct StyledTextField: View {
    let title: String
    @Binding var text: String
    var hintText: String?
    var keyboardType: UIKeyboardType
    @Binding var isValid: Bool

    public init(
        title: String,
        text: Binding<String>,
        isValid: Binding<Bool>,
        keyboardType: UIKeyboardType = .default,
        hintText: String? = nil
    ) {
        self.title = title
        self._text = text
        self.hintText = hintText
        self.keyboardType = keyboardType
        self._isValid = isValid
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField(title, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(keyboardType == .emailAddress ? .never : .sentences)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(isValid ? AppColors.dotLine : AppColors.errorLine))
                .font(AppFonts.body1())
                .foregroundColor(AppColors.textPrimary)
            if let hintText, !hintText.isEmpty {
                Spacer()
                    .frame(height: 4)
                Text(hintText)
                    .foregroundColor(isValid ? AppColors.textPrimary.opacity(0.6) : AppColors.errorLine)
                    .font(AppFonts.body1())
                    .padding(.horizontal, 16)
            }
            Spacer().frame(height: hintText?.isEmpty == false ? 12 : 32)
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        StyledTextField(title: "Normal", text: .constant("Preview Text"), isValid: .constant(true))
        StyledTextField(title: "Empty", text: .constant(""), isValid: .constant(true))
        StyledTextField(title: "Phone", text: .constant(""), isValid: .constant(true), hintText: "+7 (123) 456-78-90")
        StyledTextField(title: "Phone", text: .constant("+7 (123) 456-78-90"), isValid: .constant(false), hintText: "Required field")
    }
    .padding()
}
