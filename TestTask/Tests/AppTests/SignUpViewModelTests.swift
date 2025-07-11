//
//  SignUpViewModelTests.swift
//  AppTests
//
//  Created by Kostiantyn Danylchenko on 11.07.2025.
//

import XCTest
import Combine
@testable import App
@testable import DomainKit
@testable import NetworkingKit

final class SignUpViewModelTests: XCTestCase {
    
    private var viewModel: SignUpViewModel!
    private var apiClient: MockAPIClient!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        viewModel = SignUpViewModel(apiClient: apiClient)
    }

    // MARK: - Validation

    func testValidateName_valid() {
        viewModel.name = "John"
        viewModel.validateName()
        XCTAssertTrue(viewModel.isNameValid)
    }

    func testValidateName_invalid() {
        viewModel.name = "J"
        viewModel.validateName()
        XCTAssertFalse(viewModel.isNameValid)
        
        viewModel.name = String(repeating: "a", count: 61)
        viewModel.validateName()
        XCTAssertFalse(viewModel.isNameValid)
    }

    func testValidateEmail_valid() {
        viewModel.email = "test@example.com"
        viewModel.validateEmail()
        XCTAssertTrue(viewModel.isEmailValid)
    }

    func testValidateEmail_invalid() {
        viewModel.email = "test@.com"
        viewModel.validateEmail()
        XCTAssertFalse(viewModel.isEmailValid)
        
        viewModel.email = "test.example.com"
        viewModel.validateEmail()
        XCTAssertFalse(viewModel.isEmailValid)
        
        viewModel.email = "@example.com"
        viewModel.validateEmail()
        XCTAssertFalse(viewModel.isEmailValid)
    }

    func testValidatePhone_valid() {
        viewModel.phone = "+380931234567"
        viewModel.validatePhone()
        XCTAssertTrue(viewModel.isPhoneValid)
    }

    func testValidatePhone_invalid() {
        viewModel.phone = "0931234567"
        viewModel.validatePhone()
        XCTAssertFalse(viewModel.isPhoneValid)
    }

    func testValidatePhoto_valid() {
        viewModel.photoData = Data([0x01])
        viewModel.isPhotoValid = true
        viewModel.validatePhoto()
        XCTAssertTrue(viewModel.isPhotoValid)
    }

    func testValidatePhoto_invalid() {
        viewModel.photoData = nil
        viewModel.isPhotoValid = true
        viewModel.validatePhoto()
        XCTAssertFalse(viewModel.isPhotoValid)
        
        viewModel.photoData = Data([0x01])
        viewModel.isPhotoValid = false
        viewModel.validatePhoto()
        XCTAssertFalse(viewModel.isPhotoValid)
    }

    // MARK: - Fetch Positions

    func testFetchPositions_success() {
        let expectation = self.expectation(description: "Positions loaded")
        let dummyPositions = [Position(id: 1, name: "Dev")]
        apiClient.fetchPositionsResult = Just(dummyPositions)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        viewModel.fetchPositions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.positions.count, 1)
            XCTAssertEqual(self.viewModel.selectedPositionId, 1)
            XCTAssertFalse(self.viewModel.showNoInternet)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testFetchPositions_showNoInternet() {
        let expectation = self.expectation(description: "No internet handled")
        apiClient.fetchPositionsResult = Fail(error: APIError.noInternetConnection)
            .eraseToAnyPublisher()

        viewModel.fetchPositions()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showNoInternet)
            XCTAssertEqual(self.viewModel.pendingRetryAction, .fetchPositions)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    // MARK: - Submit

    func testRegisterUser_success() {
        let expectation = self.expectation(description: "User registered")

        viewModel.name = "John"
        viewModel.email = "john@example.com"
        viewModel.phone = "+380931234567"
        viewModel.photoData = Data([0x01])
        viewModel.positions = [Position(id: 1, name: "QA")]
        viewModel.selectedPositionId = 1

        apiClient.registerUserResult = Just(())
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()

        viewModel.validateAndSubmit()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showSuccess)
            XCTAssertFalse(self.viewModel.showNoInternet)
            XCTAssertEqual(self.viewModel.name, "")
            XCTAssertEqual(self.viewModel.email, "")
            XCTAssertEqual(self.viewModel.phone, "")
            XCTAssertNil(self.viewModel.photoData)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testRegisterUserNoInternet_setsRetry() {
        let expectation = self.expectation(description: "No internet retry stored")

        let request = UserRegistrationRequest(
            name: "John",
            email: "john@example.com",
            phone: "+380931234567",
            positionId: 1,
            photo: Data([0x01])
        )

        apiClient.registerUserResult = Fail(error: .noInternetConnection)
            .eraseToAnyPublisher()

        viewModel.validateAndSubmit(incomingRequest: request)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showNoInternet)
            if case .registerUser(let storedRequest)? = self.viewModel.pendingRetryAction {
                XCTAssertEqual(storedRequest.name, "John")
            } else {
                XCTFail("Expected .registerUser with request")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func testRegisterUserGenericError_showsError() {
        let expectation = self.expectation(description: "Generic error handled")

        let request = UserRegistrationRequest(
            name: "John",
            email: "john@example.com",
            phone: "+380931234567",
            positionId: 1,
            photo: Data([0x01])
        )

        apiClient.registerUserResult = Fail(error: .message("Something went wrong"))
            .eraseToAnyPublisher()

        viewModel.validateAndSubmit(incomingRequest: request)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.showError)
            XCTAssertEqual(self.viewModel.errorMessage, "Something went wrong")
            XCTAssertFalse(self.viewModel.showNoInternet)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
    }
}
