# Casa Ajedrez

**iOS Chess App with AI (Open Source)** – Built with Swift and SwiftUI, Casa Ajedrez offers a native chess experience featuring full piece logic, rule validation, and a Minimax‑based AI opponent. The project focuses on precise game state management, responsive animations, and clean board rendering.

## Features

- Full chess rules and piece movement, including castling, en passant and pawn promotion
- Minimax-based AI opponent
- SwiftUI interface with a welcome screen, color selection,
  animations and touch interaction
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

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contributing to this project.

## License

This project is released under the MIT License. See [LICENSE](LICENSE) for
details.
