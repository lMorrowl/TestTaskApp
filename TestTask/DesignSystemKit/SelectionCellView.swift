//
//  SelectionCellView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct SelectionCellView: View {
    private let title: String
    private let isSelected: Bool
    var action: () -> Void = { }
    
    public init(title: String, isSelected: Bool, action: @escaping () -> Void = { }) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Spacer()
                .frame(width: 17)
            if isSelected {
                Circle()
                    .stroke(lineWidth: 4)
                    .frame(width: 14, height: 14)
                    .foregroundColor(AppColors.secondary)
            } else {
                Circle()
                    .stroke(lineWidth: 1)
                    .frame(width: 14, height: 14)
                    .foregroundColor(AppColors.dotLine)

            }
            Spacer()
                .frame(width: 17)
            Text(title)
                .font(AppFonts.body1())
        }
        .frame(height: 48)
        .background(AppColors.background)
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 0) {
        SelectionCellView(title: "Selected", isSelected: true)
        SelectionCellView(title: "Unselected", isSelected: false)
    }
    .padding()
}
