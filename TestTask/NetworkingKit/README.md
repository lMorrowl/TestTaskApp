# NetworkingKit

`NetworkingKit` is a lightweight and testable Swift module built on top of [Alamofire](https://github.com/Alamofire/Alamofire) that handles all networking operations for the TestTask app. It provides a clean API surface for data fetching and user registration, along with structured error handling and logging.

---

## 📦 Features

- ✅ Fetch users with pagination support
- ✅ Fetch available user positions
- ✅ Register new users with multipart/form-data
- ✅ Built-in network error mapping (including offline detection)
- ✅ Plug-and-play Alamofire-based implementation
- ✅ Dependency inversion via `APIClient` protocol
- ✅ Debug logging via `NetworkLogger`

---

## 🧱 Architecture

### `APIClient`

A protocol that defines all available network operations:

```swift
public protocol APIClient {
    func fetchUsers(page: Int) -> AnyPublisher<([User], Bool), APIError>
    func fetchPositions() -> AnyPublisher<[Position], APIError>
    func registerUser(request: UserRegistrationRequest) -> AnyPublisher<Void, APIError>
}
```

### `APIClientImpl`

An Alamofire-based implementation of `APIClient`. It handles token-based registration and automatically maps errors using the provided Combine extension.

---

## 🧪 Error Handling

All networking errors are abstracted into a unified `APIError` enum:

```swift
public enum APIError: LocalizedError, Equatable {
    case underlying(Error)
    case message(String)
    case noInternetConnection
}
```

To integrate this with Alamofire and Combine, use:

```swift
.mapAFErrorToAPIError()
```

which transforms `AFError` into `APIError`, recognizing `URLError.notConnectedToInternet` as `.noInternetConnection`.

---

## 🔍 Network Logging

Enable logging by injecting a `NetworkLogger` when constructing the client:

```swift
let apiClient = APIClientImpl(eventMonitors: [NetworkLogger()])
```

---

## 🧪 Testing

You can inject a mock `APIClient` to test view models or UI components:

```swift
final class MockAPIClient: APIClient {
    func fetchUsers(page: Int) -> AnyPublisher<([User], Bool), APIError> { /* ... */ }
    func fetchPositions() -> AnyPublisher<[Position], APIError> { /* ... */ }
    func registerUser(request: UserRegistrationRequest) -> AnyPublisher<Void, APIError> { /* ... */ }
}
```

---

## 📂 Internal Models

These are used only inside `NetworkingKit`:

- `UsersResponse`
- `PositionsResponse`
- `TokenResponse`
- `ErrorResponse`

They are `Decodable` and used to deserialize server responses.

---

## ✅ Requirements

- iOS 15.0+
- Swift 5.9+
- Combine
- Alamofire 5.8+

---

## 🧩 Dependencies

- [Alamofire](https://github.com/Alamofire/Alamofire)
