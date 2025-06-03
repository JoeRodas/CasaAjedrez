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

    mutating func setupInitialPosition() {
        // Place pawns
        for file in 0..<8 {
            squares[1][file] = Piece(.pawn, .white)
            squares[6][file] = Piece(.pawn, .black)
        }
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
            }
            return false
        case .rook:
            if from.0 == to.0 { return clearHorizontal(from: from, to: to) }
            if from.1 == to.1 { return clearVertical(from: from, to: to) }
            return false
        default:
            // Other pieces not yet implemented
            return false
        }
    }

    public subscript(rank: Int, file: Int) -> Piece? {
        get { squares[rank][file] }
        set { squares[rank][file] = newValue }
    }
}
