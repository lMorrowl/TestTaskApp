# DesignSystemKit

`DesignSystemKit` is a Swift framework that contains reusable visual components and styling used throughout the TestTask app.

## Features

- **PrimaryButtonStyle**: A styled primary action button with custom background and foreground colors depending on the state (enabled, disabled, pressed).
- **SecondaryButtonStyle**: A secondary action button with outlined visual feedback on press and state-dependent color changes.
- **StyledTextField**: A custom `TextField` with validation feedback and optional hint text.
- **SelectionCellView**: A selectable row view with a circular selection indicator.
- **NoInternetErrorView**: A full-screen error view that shows when there’s no internet connection, with retry button.
- **HeaderView**: A reusable centered title header view with consistent height and styling.
- **AppColors**: An app-wide used color scheme.
- **AppFonts**: An app-wide used fonts scheme.

## Preview Examples

Each component has SwiftUI previews for easy visualization and snapshot testing coverage.

## Dependencies

- SwiftUI
- SnapshotTesting (for tests)


## Requirements

- iOS 15.0+
- Swift 5.9+
