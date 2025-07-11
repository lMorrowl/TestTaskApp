//
//  AddUserFailureView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI
import DesignSystemKit

struct AddUserFailureView: View {
    var message: String?
    var action: () -> Void = {}
    var body: some View {
        VStack {
            Spacer()
            Image("failure")
                .frame(width: 200, height: 200)
            Spacer()
                .frame(height: 24)
            if let message {
                Text(message)
                    .font(AppFonts.body3())
            } else {
                Text("That email is already registered")
                    .font(AppFonts.body3())
            }
            Spacer()
                .frame(height: 24)
            Button(action: action) {
                Text("Try again")
            }
            .buttonStyle(PrimaryButtonStyle())
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    action()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black.opacity(48))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {    
        AddUserFailureView()
    }
}
