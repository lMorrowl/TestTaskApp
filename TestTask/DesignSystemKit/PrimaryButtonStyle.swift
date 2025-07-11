//
//  AddUserFailureView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(backgroundColor(configuration: configuration))
            .foregroundColor(foregroundColor())
            .cornerRadius(24)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(configuration: Configuration) -> Color {
        if !isEnabled {
            return AppColors.primaryDisabled
        } else if configuration.isPressed {
            return AppColors.primaryPressed
        } else {
            return AppColors.primary
        }
    }
    
    private func foregroundColor() -> Color {
        isEnabled ? AppColors.textPrimary : AppColors.textPrimaryDisabled
    }
}

#Preview {
    VStack(spacing: 16) {
        Button("Primary") {}
            .buttonStyle(PrimaryButtonStyle())
        
        Button("Disabled") {}
            .buttonStyle(PrimaryButtonStyle())
            .disabled(true)
    }
    .padding()
}
