# Places

An iOS app that displays a list of locations in a grid and allows users to open them in the Wikipedia app via deep linking. Built as a demonstration of modern Swift/SwiftUI architecture with zero third-party dependencies.

## Architecture

The app uses a straightforward **MVVM** pattern with a `DependencyContainer` for injection. No coordinator pattern (MVVM-C) was used, for an app this simple, KISS vs over-engineering.

### Key decisions

- **Concrete ViewModels in Views**: SwiftUI's `@Bindable` macro requires concrete `@Observable` types; it does not work with protocols or existentials. Protocols are therefore only used where they enable testability through mocking: services, networking, and the URL opener.
- **`@MainActor` project default**: The project uses Xcode's default actor isolation setting, meaning all types are `@MainActor` unless explicitly marked `nonisolated`. Networking and service layer types are marked `nonisolated` to allow background execution. UI-bound types (ViewModels, deep link service, URL opener) remain on the main actor.
- **No external dependencies**: The entire networking stack, dependency injection, and deep linking are implemented from scratch using only Foundation and SwiftUI.

### Project structure

```
Places/
├── Models/              # nonisolated 
├── Networking/          # nonisolated — HTTPClient, services
├── ViewModels/          # @MainActor — observable state for views
├── Views/
│   └── LocationListView+Preview.swift
├── DeepLink/            # @MainActor — interacts with UIApplication
└── DependencyContainer.swift
```

## Features

- Grid view displaying location cards, tapping a card opens the Wikipedia app at that location's coordinates
- Pull-to-refresh to reload locations
- `+` button opens a sheet with coordinate input fields and simple validation for entering a custom location
- Deep linking via the `wikipedia://` URL scheme (added as a queried URL scheme in Info.plist)
- Error and empty state handling with retry
- Added some accessibility elements

## Testing

Tests are written using the **Swift Testing** framework (`@Test`, `#expect`, `@Suite`) rather than XCTest, partly to explore the newer framework and its more expressive syntax.

### Test coverage

- **HTTPClient** — success, HTTP error codes, decoding failures, invalid URLs
- **LocationService** — delegates to HTTPClient, maps errors
- **DeepLinkService** — URL opening success/failure, correct URL passthrough
- **ViewModels** — state transitions, loading, refresh, error recovery, validation
- **DependencyContainer** — factory methods produce correctly configured instances

View level testing is not included. The Views are intentionally thin (pure layout, no logic), so ViewModel tests effectively cover all behavior. Snapshot testing could be added for visual regression in SwiftUI, with for example TCA Snapshot testing.

### Mocking strategy

Protocols are defined for services and networking (`HTTPClientProtocol`, `LocationServiceProtocol`, `DeepLinkServiceProtocol`, `URLOpening`, `NetworkSession`). Mock implementations live in the test target.

- Mocks for `@MainActor` types are annotated `@MainActor`, no unsafe workarounds needed.
- Mocks for `nonisolated` types that need to cross isolation boundaries use `@unchecked Sendable`. This is acceptable because test mocks are only ever accessed from a single test at a time, never concurrently.

## Requirements

- iOS 17.0+
- Xcode 26+
- Swift 6 (strict concurrency)
- Wikipedia app installed (from branch https://github.com/avdwerff/wikipedia-ios/tree/feature/deeplink-places) for deep linking (graceful failure if not present)
