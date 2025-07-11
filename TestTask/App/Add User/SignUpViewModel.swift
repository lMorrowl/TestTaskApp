import Foundation
import Combine
import DomainKit
import NetworkingKit

/// Enum representing actions that can be retried after an internet connection is restored.
enum RetryableAction: Equatable {
    case fetchPositions
    case registerUser(UserRegistrationRequest)
}

/// ViewModel handling user registration logic, validation, and networking.
class SignUpViewModel: ObservableObject {
    // MARK: - Published Properties (State)

    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var selectedPositionId: Int?
    @Published var photoData: Data?
    @Published var showSuccess = false
    @Published var isSubmitting = false
    @Published var positions: [Position] = []
    
    // Validation flags
    @Published var isNameValid = true
    @Published var isEmailValid = true
    @Published var isPhoneValid = true
    @Published var isPhotoValid: Bool = true
    
    // UI flags
    @Published var showError: Bool = false
    @Published var showNoInternet: Bool = false
    
    // Error message for alerts
    var errorMessage: String?
    
    // Stores pending action in case of no internet
    var pendingRetryAction: RetryableAction?
    
    // MARK: - Private Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient: APIClient

    // MARK: - Init
    
    init(apiClient: APIClient = APIClientImpl()) {
        self.apiClient = apiClient
    }

    // MARK: - API Requests
    
    /// Fetches the list of available positions from the server.
    /// Sets `showNoInternet` if offline and stores retry action.
    func fetchPositions() {
        apiClient.fetchPositions()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion, case .noInternetConnection = error {
                    self?.showNoInternet = true
                    self?.pendingRetryAction = .fetchPositions
                }
            } receiveValue: { [weak self] positions in
                self?.showNoInternet = false
                self?.positions = positions.sorted { $0.id < $1.id }
                self?.selectedPositionId = self?.positions.first?.id
            }
            .store(in: &cancellables)
    }

    /// Validates input (if needed), builds registration request and sends it to the server.
    /// If request fails due to internet issues, stores retry action.
    func validateAndSubmit(incomingRequest: UserRegistrationRequest? = nil) {
        var request: UserRegistrationRequest
        
        // Use provided request or build one after validation
        if let incomingRequest {
            request = incomingRequest
        } else {
            validateName()
            validateEmail()
            validatePhone()
            validatePhoto()
            
            guard isNameValid,
                  isEmailValid,
                  isPhoneValid,
                  isPhotoValid,
                  let photo = photoData,
                  let positionId = selectedPositionId else {
                return
            }
            
            
            request = UserRegistrationRequest(
                name: name,
                email: email,
                phone: phone,
                positionId: positionId,
                photo: photo
            )
        }

        isSubmitting = true
        apiClient.registerUser(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isSubmitting = false
                if case let .failure(error) = completion {
                    switch error {
                    case .noInternetConnection:
                        self?.showNoInternet = true
                        self?.pendingRetryAction = .registerUser(request)
                    default:
                        self?.showNoInternet = false
                        self?.errorMessage = error.localizedDescription
                        self?.showError = true
                    }
                }
            } receiveValue: { [weak self] in
                self?.showNoInternet = false
                self?.showSuccess = true
                self?.resetFields()
            }
            .store(in: &cancellables)
    }

    // MARK: - Validation
        
    /// Validates the name length (must be 2–60 characters).
    func validateName() {
        isNameValid = name.count >= 2 && name.count < 60
    }
    
    /// Validates email using a regular expression.
    func validateEmail() {
        let emailRegex = #"^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$"#
        isEmailValid = email.range(of: emailRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Validates Ukrainian phone format (+380XXXXXXXXX).
    func validatePhone() {
        let phoneRegex = #"^[\+]{0,1}380([0-9]{9})$"#
        isPhoneValid = phone.range(of: phoneRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Validates that the photo is not nil and marked as valid externally.
    func validatePhoto() {
        isPhotoValid =  isPhotoValid && photoData != nil
    }
    
    // MARK: - State Reset

    /// Resets all input fields and sets default position ID.
    func resetFields() {
        name = ""
        email = ""
        phone = ""
        selectedPositionId = positions.first?.id
        photoData = nil
    }
}
