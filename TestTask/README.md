# TestTask App

## Overview

This iOS application is a sample project demonstrating a modern SwiftUI-based architecture that interacts with a remote API to display and register users. The app supports features like pagination, form validation, image picking, offline handling, and more.

---

## Features

- Fetch users with pagination
- User registration with image upload
- Inline form validation
- Snapshot and unit testing
- Handling of no-internet scenarios
- Modularized architecture using SPM-based internal libraries

---

## Project Structure

The app is split into several Swift packages for modularity and testability:

### 1. **App**
Main application layer that integrates UI and ViewModels.

### 2. **NetworkingKit**
Handles all API communication, including:
- Fetching users and positions
- Token generation and user registration
- Error mapping and logging

### 3. **DomainKit**
Contains data models like `User`, `Position`, and request/response DTOs.

### 4. **DesignSystemKit**
Provides reusable UI components and styles:
- `PrimaryButtonStyle`, `SecondaryButtonStyle`
- `StyledTextField`, `SelectionCellView`, `HeaderView`, etc.

---

## Dependencies & External Libraries

### 1. **Alamofire**
Used for HTTP requests and multipart upload. Chosen for its reliability and easy integration with Combine via response publishers.

### 2. **SnapshotTesting**
Used for UI snapshot testing. Helps catch regressions in UI appearance.

### 3. **Combine**
Apple's declarative framework for managing asynchronous events and data streams.

---

## Building the App

1. **Open the project** in Xcode (`TestTask.xcodeproj).
2. Make sure the package dependencies are resolved via File > Packages > Resolve.
3. Build the app using ⌘B.
4. Run tests with ⌘U or from the `Test navigator`.

---

## APIs

This app uses the [abz.agency test API](https://frontend-test-assignment-api.abz.agency/api/v1). No authentication is required to fetch data. Token authentication is used for registration endpoint. Full API handled in `NetworkingKit/APIClient.swift`.

---

## Testing

- Unit tests for `SignUpViewModel`, `UsersListViewModel`
- Snapshot tests for UI components in `DesignSystemKit`

Run tests with:
```bash
⌘U
```
