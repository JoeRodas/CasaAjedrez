import Foundation

public struct MinimaxAI {
    public init() {}

// <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
    func evaluate(_ board: Board, for color: PieceColor) -> Int {
        var score = 0
        for r in 0..<8 {
            for f in 0..<8 {
                guard let piece = board[r, f] else { continue }
                let value: Int
                switch piece.type {
                case .pawn: value = 1
                case .knight, .bishop: value = 3
                case .rook: value = 5
                case .queen: value = 9
                case .king: value = 100
                }
                score += piece.color == color ? value : -value
            }
        }
        return score
    }

    func minimax(board: Board, depth: Int, maximizing: Bool, color: PieceColor, alpha: inout Int, beta: inout Int) -> (score: Int, move: ((Int, Int), (Int, Int))?) {
        if depth == 0 {
            return (evaluate(board, for: color), nil)
        }

        let currentColor: PieceColor = maximizing ? color : (color == .white ? .black : .white)
        let moves = board.generateMoves(for: currentColor)
        if moves.isEmpty {
            if board.isKingInCheck(currentColor) {
                return maximizing ? (-1000, nil) : (1000, nil)
            } else {
                return (0, nil)
            }
        }

        var bestMove: ((Int, Int), (Int, Int))? = nil

        if maximizing {
            var bestScore = Int.min
            for m in moves {
                var copy = board
                let piece = copy[m.0.0, m.0.1]!
                copy[m.0.0, m.0.1] = nil
                copy[m.1.0, m.1.1] = piece
                var a = alpha
                var b = beta
                let result = minimax(board: copy, depth: depth - 1, maximizing: false, color: color, alpha: &a, beta: &b)
                if result.score > bestScore {
                    bestScore = result.score
                    bestMove = m
                }
                alpha = max(alpha, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestMove)
        } else {
            var bestScore = Int.max
            for m in moves {
                var copy = board
                let piece = copy[m.0.0, m.0.1]!
                copy[m.0.0, m.0.1] = nil
                copy[m.1.0, m.1.1] = piece
                var a = alpha
                var b = beta
                let result = minimax(board: copy, depth: depth - 1, maximizing: true, color: color, alpha: &a, beta: &b)
                if result.score < bestScore {
                    bestScore = result.score
                    bestMove = m
                }
                beta = min(beta, bestScore)
                if beta <= alpha { break }
            }
            return (bestScore, bestMove)
        }
    }

    public func chooseMove(from board: Board, for color: PieceColor = .white, depth: Int = 2) -> (from: (Int, Int), to: (Int, Int))? {
        var alpha = Int.min
        var beta = Int.max
        let result = minimax(board: board, depth: depth, maximizing: true, color: color, alpha: &alpha, beta: &beta)
        return result.move
// =======
    // Placeholder evaluation that picks the first available move
    public func chooseMove(from board: Board) -> (from: (Int, Int), to: (Int, Int))? {
        for rank in 0..<8 {
            for file in 0..<8 {
                if let piece = board[rank, file], piece.color == .white {
                    // naive move: try to move pawn forward one square
                    if piece.type == .pawn && rank + 1 < 8 && board[rank + 1, file] == nil {
                        return ((rank, file), (rank + 1, file))
                    }
                }
            }
        }
        return nil
// >>>>>>> main
    }
}
