//
//  CustomTabView.swift
//  TestTask
//
//  Created by Kostiantyn Danylchenko on 09.07.2025.
//

import SwiftUI
import DesignSystemKit

struct CustomTabView<Tab: Hashable & CaseIterable>: View {
    @Binding var selection: Tab
    let tabs: [(Tab, String, String)]
    let content: () -> AnyView

    var body: some View {
        VStack(spacing: 0) {
            content()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: 0) {
                ForEach(tabs, id: \.0) { tab, title, icon in
                    Button(action: {
                        withAnimation {
                            selection = tab
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(icon)
                                .frame(width: 24, height: 24)
                            Text(title)
                                .font(AppFonts.body3())
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(selection == tab ? AppColors.secondary : AppColors.textTabBarUnselected)
                    }
                }
            }
            .background(AppColors.tabBarBackground)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var selectedTab: MainTab = .users

        var body: some View {
            CustomTabView(
                selection: $selectedTab,
                tabs: [
                    (.users, "Users", "people"),
                    (.signup, "Sign Up", "add_person")
                ]
            ) {
                AnyView(
                    Group {
                        switch selectedTab {
                        case .users:
                            Color.green
                                .overlay(Text("Users View").foregroundColor(.white))
                        case .signup:
                            Color.orange
                                .overlay(Text("Sign Up View").foregroundColor(.white))
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                )
            }
        }
    }

    return PreviewWrapper()
        .frame(height: 400)
}
