import SwiftUI
import DesignSystemKit
import NetworkingKit
import DomainKit

struct UsersListView: View {
    @StateObject private var viewModel = UsersListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height:1)
            HeaderView(message: "Working with GET request")
            
            if !viewModel.users.isEmpty {
                List {
                    ForEach(viewModel.users) { user in
                        UserListCell(user: user, isLast: viewModel.users.last == user)
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .onAppear {
                                if user == viewModel.users.last {
                                    viewModel.fetchUsers()
                                }
                            }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
                .listStyle(.plain)
                .background(AppColors.background)
                .refreshable {
                    viewModel.refresh()
                }
            } else {
                ScrollView {
                    Spacer()
                        .frame(height: 113)
                    Image("no_users")
                        .frame(width: 200, height: 200)
                    Spacer()
                        .frame(height: 24)
                    Text("There are no users yet")
                        .font(AppFonts.heading())
                    Spacer()
                }
                .refreshable {
                    viewModel.refresh()
                }
            }
        }
        .onAppear(perform: {
            if viewModel.users.isEmpty {
                viewModel.refresh()
            }
        })
        .fullScreenCover(isPresented: $viewModel.showNoInternet) {
            NoInternetErrorView {
                viewModel.refresh()
            }
        }
    }
}

#Preview {
    UsersListView()
}
