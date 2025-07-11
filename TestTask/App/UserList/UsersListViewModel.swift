import Foundation
import Combine
import NetworkingKit
import DomainKit

/// ViewModel responsible for fetching paginated list of users and handling UI-related state.
class UsersListViewModel: ObservableObject {
    
    // MARK: - Published Properties (State)
    
    /// Array of fetched users to be displayed.
    @Published var users: [User] = []
    
    /// Indicates if data is currently loading.
    @Published var isLoading = false
    
    /// Flag to show no-internet error UI.
    @Published var showNoInternet: Bool = false

    // MARK: - Private State

    /// The current page being fetched.
    private var currentPage = 1
    
    /// Whether more pages can be fetched.
    private var canLoadMore = true
    
    /// Set of Combine subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    /// API client for performing network requests.
    private let apiClient: APIClient

    // MARK: - Init
    init(apiClient: APIClient = APIClientImpl()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods

    /// Fetches a page of users from the server.
    /// - Parameter reset: If true, clears existing data and restarts from page 1.
    func fetchUsers(reset: Bool = false) {
        guard !isLoading, canLoadMore else { return }
        
        if reset {
            currentPage = 1
            users = []
            canLoadMore = true
        }
        
        isLoading = true
        
        apiClient
            .fetchUsers(page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure = completion {
                    self?.showNoInternet = true
                }
            }, receiveValue: { [weak self] newUsers, canFetchMore in
                guard let self = self else { return }
                
                self.users.append(contentsOf: newUsers)
                self.currentPage += 1
                self.canLoadMore = canFetchMore
                self.showNoInternet = false
            })
            .store(in: &cancellables)
    }
    
    /// Triggers a full reload of users from the first page.
    func refresh() {
        fetchUsers(reset: true)
    }
}
