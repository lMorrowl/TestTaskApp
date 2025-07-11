import SwiftUI
import DesignSystemKit

enum MainTab: CaseIterable {
    case users
    case signup
}

struct RootTabView: View {
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
                    case .users: UsersListView()
                    case .signup: SignUpView()
                    }
                }
            )
        }
    }
}

#Preview {
    RootTabView()
}
