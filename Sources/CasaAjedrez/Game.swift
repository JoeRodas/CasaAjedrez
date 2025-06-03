import Foundation

//<<<<<<< makkxq-codex/develop-native-chess-app-with-ai
public enum GameError: Error {
    case invalidMove
}

// =======
// >>>>>>> main
public struct Game {
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor

    public init() {
        self.board = Board()
        self.currentTurn = .white
    }

//<<<<<<< makkxq-codex/develop-native-chess-app-with-ai
    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) throws {
        guard let piece = board[from.0, from.1], piece.color == currentTurn,
              board.isValidMove(for: piece, from: from, to: to) else {
            throw GameError.invalidMove
        }

// =======
    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) {
        let piece = board[from.0, from.1]
// >>>>>>> main
        board[from.0, from.1] = nil
        board[to.0, to.1] = piece
        currentTurn = currentTurn == .white ? .black : .white
    }
}
