import Foundation

//  <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
// =======
//<<<<<<< makkxq-codex/develop-native-chess-app-with-ai
//>>>>>>> main
public enum GameError: Error {
    case invalidMove
}

// <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
// =======
// // =======
// // >>>>>>> main
// >>>>>>> main
public struct Game {
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor

    public init() {
        self.board = Board()
        self.currentTurn = .white
    }

// <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
    public init(board: Board, currentTurn: PieceColor = .white) {
        self.board = board
        self.currentTurn = currentTurn
    }

// =======
//<<<<<<< makkxq-codex/develop-native-chess-app-with-ai
// >>>>>>> main
    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) throws {
        guard let piece = board[from.0, from.1], piece.color == currentTurn,
              board.isValidMove(for: piece, from: from, to: to) else {
            throw GameError.invalidMove
        }

//  <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
        var copy = board
        copy[from.0, from.1] = nil
        copy[to.0, to.1] = piece

        if copy.isKingInCheck(currentTurn) {
            throw GameError.invalidMove
        }

        board = copy
        currentTurn = currentTurn == .white ? .black : .white
    }

    public func isCheck(for color: PieceColor) -> Bool {
        board.isKingInCheck(color)
    }

    public func isCheckmate(for color: PieceColor) -> Bool {
        board.isKingInCheck(color) && board.generateMoves(for: color).isEmpty
    }

    public func isStalemate(for color: PieceColor) -> Bool {
        !board.isKingInCheck(color) && board.generateMoves(for: color).isEmpty
    }
//=======
// =======
    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) {
        let piece = board[from.0, from.1]
// >>>>>>> main
        board[from.0, from.1] = nil
        board[to.0, to.1] = piece
        currentTurn = currentTurn == .white ? .black : .white
    }
//>>>>>>> main
}
