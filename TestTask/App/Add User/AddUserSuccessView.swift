//
//  AddUserSuccessView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI
import DesignSystemKit

struct AddUserSuccessView: View {
    var action: () -> Void = {}
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image("success")
                .frame(width: 200, height: 200)
            Spacer()
                .frame(height: 24)
            Text("User successfully registered")
                .font(AppFonts.body3())
            Spacer()
                .frame(height: 24)
            Button(action: action) {
                Text("Got it")
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
        AddUserSuccessView()
    }
}
