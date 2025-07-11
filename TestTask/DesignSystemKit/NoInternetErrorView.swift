//
//  NoInternetErrorView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI

public struct NoInternetErrorView: View {
    var action: () -> Void = {}
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Spacer()
        Image("no_internet", bundle: .designSystem)
            .frame(width: 200, height: 200)
        Spacer()
            .frame(height: 24)
        Text("There is no internet connection")
            .font(AppFonts.body3())
        Spacer()
            .frame(height: 24)
        Button(action: action) {
            Text("Try again")
        }
        .buttonStyle(PrimaryButtonStyle())
        Spacer()
        
    }
}

#Preview {
    NoInternetErrorView {}
}

final class _DesignSystemBundleLocator {}

extension Bundle {
    static var designSystem: Bundle {
        Bundle(for: _DesignSystemBundleLocator.self)
    }
}
