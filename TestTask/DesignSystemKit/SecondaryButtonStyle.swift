//
//  SecondaryButtonStyle.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor(configuration: configuration))
            .foregroundColor(foregroundColor())
            .cornerRadius(24)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private func backgroundColor(configuration: Configuration) -> Color {
        if configuration.isPressed {
            return AppColors.secondaryPressed
        } else {
            return .clear
        }
    }
    
    private func foregroundColor() -> Color {
        isEnabled ? AppColors.textSecondary : AppColors.textSecondaryDisabled
    }
}

struct SecondaryButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Button("Secondary") {}
                .buttonStyle(SecondaryButtonStyle())

            Button("Disabled") {}
                .buttonStyle(SecondaryButtonStyle())
                .disabled(true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

