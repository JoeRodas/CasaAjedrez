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
