import Foundation

public struct MinimaxAI {
    public init() {}

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
    }
}
