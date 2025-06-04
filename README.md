# Casa Ajedrez

**iOS Chess App with AI (Open Source)** – Built with Swift and SwiftUI, Casa Ajedrez offers a native chess experience featuring full piece logic, rule validation, and a Minimax‑based AI opponent. The project focuses on precise game state management, responsive animations, and clean board rendering.

## Features

- Full chess rules and piece movement, including castling, en passant and pawn promotion
- Minimax-based AI opponent
- SwiftUI interface with animations and touch interaction
- Move history with undo/redo

## Project Tasks

The following list outlines the major tasks planned for the project:

1. **Project setup** – create a Swift Package Manager project and configure Git.
2. **Chess game logic** – implement piece models and movement rules.
3. **AI opponent** – add a Minimax-based algorithm for the computer player.
4. **SwiftUI interface** – build a responsive chessboard UI with animations.
5. **Game state management** – track moves, turns and game status.
6. **Testing** – write unit tests for move validation and AI logic.
7. **Documentation** – keep this README and source comments up to date.
8. **Open-source compliance** – provide a license and contribution guidelines.

## Repository Status

The repository now provides a working chess engine with check detection,
castling and pawn promotion, plus a Minimax AI. A GitHub Actions workflow
runs the test suite on each pull request.

## Building

Ensure you have Swift 5.9 or later installed. To build the package:

```bash
swift build
```

### Running Tests

Execute the test suite with:

```bash
swift test
```
The test suite depends on the `swift-testing` package. Swift Package Manager
fetches this dependency from GitHub the first time the tests are run, so
internet access is required. If you are working offline you can vendor the
package by cloning `swift-testing` locally and changing the dependency in
`Package.swift` to use `.package(path: "../swift-testing")`.

## Creating an iOS App Target

1. Open the package in Xcode and choose **File > New > Target...**.
2. Select the **App** template under iOS.
3. Add this repository using **File > Add Packages...** and pick the `CasaAjedrez` product.
4. Import `CasaAjedrez` in your new target.

Example minimal application:

```swift
import SwiftUI
import CasaAjedrez

@main
struct ChessApp: App {
    @StateObject private var viewModel = GameViewModel(humanColor: .white)

    var body: some Scene {
        WindowGroup {
            BoardView(viewModel: viewModel)
        }
    }
}
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contributing to this project.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for
details.
