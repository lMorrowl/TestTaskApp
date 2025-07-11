//
//  HeaderView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct HeaderView: View {
    @State var message: String
    
    public init(message: String) {
        _message = .init(initialValue: message)
    }
    
    public var body: some View {
        HStack {
            Spacer()
            Text(message)
                .font(AppFonts.heading())
                .foregroundColor(.black)
            Spacer()
        }
        .frame(height: 56)
        .background(AppColors.primary)
    }
}

#Preview {
    HeaderView(message: "Hello, World!")
}
