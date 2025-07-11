import SwiftUI
import DesignSystemKit
import DomainKit

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showPicker = false
    @State private var pickerSource: ImagePickerSource = .photoLibrary
    @State private var showSourceSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()
                .frame(height: 1)
            HeaderView(message: "Working with POST request")
            ScrollView {
                Spacer()
                    .frame(height: 32)
                StyledTextField(
                    title: "Your name",
                    text: $viewModel.name,
                    isValid: $viewModel.isNameValid,
                    hintText: viewModel.isNameValid ? nil : "Required field"
                )
                StyledTextField(
                    title: "Email",
                    text: $viewModel.email,
                    isValid: $viewModel.isEmailValid,
                    keyboardType: .emailAddress,
                    hintText: viewModel.isEmailValid ? nil : "Invalid email format"
                )
                StyledTextField(
                    title: "Phone",
                    text: $viewModel.phone,
                    isValid: $viewModel.isPhoneValid,
                    keyboardType: .phonePad,
                    hintText: viewModel.isPhoneValid ? "+38 (XXX) XXX - XX - XX" : "Required field"
                )
                Text("Select your position")
                    .font(AppFonts.body1())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer().frame(height: 12)
                ForEach(viewModel.positions) { position in
                    SelectionCellView(
                        title: position.name,
                        isSelected: (viewModel.selectedPositionId == position.id)
                    ) {
                        viewModel.selectedPositionId = position.id
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer().frame(height: 24)
                ZStack {
                    RoundedRectangle(cornerSize: .init(width: 4, height: 4))
                        .stroke(Color(viewModel.isPhotoValid ? AppColors.textHint : AppColors.errorLine), lineWidth: 1)
                    VStack {
                        HStack {
                            if let photoData = viewModel.photoData, let image = UIImage(data: photoData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(25)
                            } else {
                                Text("Upload your photo")
                                    .foregroundColor(viewModel.isPhotoValid ? AppColors.textHint : AppColors.errorLine)
                                    .font(AppFonts.body1())
                            }
                            Spacer()
                            Button("Upload") {
                                showSourceSheet = true
                            }
                            .buttonStyle(SecondaryButtonStyle())
                            .disabled(viewModel.isSubmitting)
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 12)
                }
                if !viewModel.isPhotoValid {
                    Spacer().frame(height: 4)
                    HStack {
                        Spacer().frame(width: 16)
                        Text("Photo is required")
                            .foregroundColor(AppColors.errorLine)
                            .font(AppFonts.body3())
                        Spacer()
                    }
                }
                
                Spacer().frame(height: 36)
                
                HStack {
                    Spacer()
                    
                    Button("Sign Up") {
                        viewModel.validateAndSubmit()
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(viewModel.email.isEmpty || viewModel.isSubmitting)
                    
                    Spacer()
                }
                
                if viewModel.isSubmitting {
                    ProgressView()
                        .padding(.top)
                }
            }
            .padding()
        }
        .onAppear() {
            viewModel.fetchPositions()
        }
        .confirmationDialog("Select Source", isPresented: $showSourceSheet) {
            Button("Camera") {
                pickerSource = .camera
                showPicker = true
            }
            Button("Photo Library") {
                pickerSource = .photoLibrary
                showPicker = true
            }
        }
        .fullScreenCover(isPresented: $showPicker) {
            ImagePicker(imageData: $viewModel.photoData, isDataValid: $viewModel.isPhotoValid,  sourceType: pickerSource)
        }
        .fullScreenCover(isPresented: $viewModel.showSuccess) {
            NavigationStack {
                AddUserSuccessView(action: { viewModel.showSuccess = false })
            }
        }
        .fullScreenCover(isPresented: $viewModel.showError) {
            NavigationStack {
                AddUserFailureView(message: viewModel.errorMessage) {
                    viewModel.showError = false
                    viewModel.errorMessage = nil
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showNoInternet) {
            NoInternetErrorView {
                switch viewModel.pendingRetryAction {
                case .fetchPositions:
                    viewModel.fetchPositions()
                case .registerUser(let userRegistrationRequest):
                    viewModel.validateAndSubmit(incomingRequest: userRegistrationRequest)
                case .none:
                    break
                }
            }
        }
    }
}

#Preview {
    SignUpView()
}
