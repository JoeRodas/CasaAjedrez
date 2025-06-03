import Foundation

public enum GameError: Error {
    case invalidMove
}

public struct Game {
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor

    public init() {
        self.board = Board()
        self.currentTurn = .white
    }

    public init(board: Board, currentTurn: PieceColor = .white) {
        self.board = board
        self.currentTurn = currentTurn
    }

    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) throws {
        guard let piece = board[from.0, from.1], piece.color == currentTurn,
              board.isValidMove(for: piece, from: from, to: to) else {
            throw GameError.invalidMove
        }

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
}
