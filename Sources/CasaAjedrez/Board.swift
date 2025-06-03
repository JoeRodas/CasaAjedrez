import Foundation

public enum PieceColor {
    case white
    case black
}

public enum PieceType {
    case king, queen, rook, bishop, knight, pawn
}

public struct Piece {
    public let type: PieceType
    public let color: PieceColor

    public init(_ type: PieceType, _ color: PieceColor) {
        self.type = type
        self.color = color
    }
}

public struct Board {
    // 8x8 board indexed by file and rank
    private(set) var squares: [[Piece?]]

    public init() {
        squares = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        setupInitialPosition()
    }

// <<<<<<< 721jq9-codex/develop-native-chess-app-with-ai
// =======
// <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
// >>>>>>> main
    public init(empty: Bool) {
        squares = Array(repeating: Array(repeating: nil, count: 8), count: 8)
        if !empty {
            setupInitialPosition()
        }
    }

// <<<<<<< 721jq9-codex/develop-native-chess-app-with-ai
// =======
// =======
// >>>>>>> main
// >>>>>>> main
    mutating func setupInitialPosition() {
        // Place pawns
        for file in 0..<8 {
            squares[1][file] = Piece(.pawn, .white)
            squares[6][file] = Piece(.pawn, .black)
        }
// <<<<<<< 64xolk-codex/develop-native-chess-app-with-ai
// =======
// makkxq-codex/develop-native-chess-app-with-ai
// >>>>>>> main
        // Place major pieces
        let backRank: [PieceType] = [.rook, .knight, .bishop, .queen,
                                     .king, .bishop, .knight, .rook]
        for file in 0..<8 {
            squares[0][file] = Piece(backRank[file], .white)
            squares[7][file] = Piece(backRank[file], .black)
        }
    }

    private func clearVertical(from: (Int, Int), to: (Int, Int)) -> Bool {
        let (start, end) = from.0 < to.0 ? (from.0 + 1, to.0) : (to.0 + 1, from.0)
        for r in start..<end { if squares[r][from.1] != nil { return false } }
        return true
    }

    private func clearHorizontal(from: (Int, Int), to: (Int, Int)) -> Bool {
        let (start, end) = from.1 < to.1 ? (from.1 + 1, to.1) : (to.1 + 1, from.1)
        for f in start..<end { if squares[from.0][f] != nil { return false } }
        return true
    }

    private func clearDiagonal(from: (Int, Int), to: (Int, Int)) -> Bool {
        let rankStep = from.0 < to.0 ? 1 : -1
        let fileStep = from.1 < to.1 ? 1 : -1
        var r = from.0 + rankStep
        var f = from.1 + fileStep
        while r != to.0 && f != to.1 {
            if squares[r][f] != nil { return false }
            r += rankStep
            f += fileStep
        }
        return true
    }

    public func isValidMove(for piece: Piece, from: (Int, Int), to: (Int, Int)) -> Bool {
        guard (0..<8).contains(to.0), (0..<8).contains(to.1) else { return false }
        if let dest = self[to.0, to.1], dest.color == piece.color { return false }

        switch piece.type {
        case .pawn:
            let direction = piece.color == .white ? 1 : -1
            let startRank = piece.color == .white ? 1 : 6
            if from.1 == to.1 {
                if to.0 - from.0 == direction && self[to.0, to.1] == nil { return true }
                if from.0 == startRank && to.0 - from.0 == 2 * direction {
                    let intermediate = from.0 + direction
                    if self[intermediate, from.1] == nil && self[to.0, to.1] == nil { return true }
                }
            } else if to.0 - from.0 == direction && abs(to.1 - from.1) == 1 {
                if let dest = self[to.0, to.1], dest.color != piece.color { return true }
            }
            return false
        case .rook:
            if from.0 == to.0 { return clearHorizontal(from: from, to: to) }
            if from.1 == to.1 { return clearVertical(from: from, to: to) }
            return false
        case .knight:
            let dr = abs(to.0 - from.0)
            let df = abs(to.1 - from.1)
            return (dr == 2 && df == 1) || (dr == 1 && df == 2)
        case .bishop:
            if abs(to.0 - from.0) == abs(to.1 - from.1) {
                return clearDiagonal(from: from, to: to)
            }
            return false
        case .queen:
            if from.0 == to.0 { return clearHorizontal(from: from, to: to) }
            if from.1 == to.1 { return clearVertical(from: from, to: to) }
            if abs(to.0 - from.0) == abs(to.1 - from.1) {
                return clearDiagonal(from: from, to: to)
            }
            return false
        case .king:
            return max(abs(to.0 - from.0), abs(to.1 - from.1)) == 1
        }

    }

    func kingPosition(for color: PieceColor) -> (Int, Int)? {
        for r in 0..<8 {
            for f in 0..<8 {
                if let p = squares[r][f], p.type == .king && p.color == color {
                    return (r, f)
                }
            }
        }
        return nil
    }

    func isSquareAttacked(_ square: (Int, Int), by color: PieceColor) -> Bool {
        for r in 0..<8 {
            for f in 0..<8 {
                if let piece = squares[r][f], piece.color == color {
                    if isValidMove(for: piece, from: (r, f), to: square) {
                        return true
                    }
                }
            }
        }
        return false
    }

    func isKingInCheck(_ color: PieceColor) -> Bool {
        guard let kingPos = kingPosition(for: color) else { return false }
        let opponent: PieceColor = color == .white ? .black : .white
        return isSquareAttacked(kingPos, by: opponent)
    }

    func generateMoves(for color: PieceColor) -> [((Int, Int), (Int, Int))] {
        var moves: [((Int, Int), (Int, Int))] = []
        for r in 0..<8 {
            for f in 0..<8 {
                guard let piece = squares[r][f], piece.color == color else { continue }
                for r2 in 0..<8 {
                    for f2 in 0..<8 {
                        if isValidMove(for: piece, from: (r, f), to: (r2, f2)) {
                            var copy = self
                            copy[r2, f2] = piece
                            copy[r, f] = nil
                            if !copy.isKingInCheck(color) {
                                moves.append(((r, f), (r2, f2)))
                            }
                        }
                    }
                }
            }
        }
        return moves

        // Simple placement for rooks as an example
        squares[0][0] = Piece(.rook, .white)
        squares[0][7] = Piece(.rook, .white)
        squares[7][0] = Piece(.rook, .black)
        squares[7][7] = Piece(.rook, .black)

    }

    public subscript(rank: Int, file: Int) -> Piece? {
        get { squares[rank][file] }
        set { squares[rank][file] = newValue }
    }
}
