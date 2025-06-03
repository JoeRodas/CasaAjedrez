import Foundation

public struct Game {
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor

    public init() {
        self.board = Board()
        self.currentTurn = .white
    }

    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) {
        let piece = board[from.0, from.1]
        board[from.0, from.1] = nil
        board[to.0, to.1] = piece
        currentTurn = currentTurn == .white ? .black : .white
    }
}
