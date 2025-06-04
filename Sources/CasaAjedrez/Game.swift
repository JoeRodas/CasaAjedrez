import Foundation


public enum GameError: Error {
    case invalidMove
}

struct CastlingRights {
    var whiteKingside = true
    var whiteQueenside = true
    var blackKingside = true
    var blackQueenside = true
}

public struct Game {
    private struct GameState {
        var board: Board
        var currentTurn: PieceColor
        var castlingRights: CastlingRights
        var enPassantSquare: (Int, Int)?
    }

    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor
    private var castlingRights = CastlingRights()
    private var enPassantSquare: (Int, Int)? = nil
    private var history: [GameState] = []
    private var redoStack: [GameState] = []
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor
    private var castlingRights = CastlingRights()

public struct Game {
    public private(set) var board: Board
    public private(set) var currentTurn: PieceColor

    public init() {
        self.board = Board()
        self.currentTurn = .white
        self.castlingRights = CastlingRights()
    }

    public init(board: Board, currentTurn: PieceColor = .white) {
        self.board = board
        self.currentTurn = currentTurn
        self.castlingRights = CastlingRights()

    }

    public init(board: Board, currentTurn: PieceColor = .white) {
        self.board = board
        self.currentTurn = currentTurn
    }

    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) throws {
        guard let piece = board[from.0, from.1], piece.color == currentTurn else {
            throw GameError.invalidMove
        }
        history.append(GameState(board: board, currentTurn: currentTurn, castlingRights: castlingRights, enPassantSquare: enPassantSquare))
        redoStack.removeAll()

        var captured = board[to.0, to.1]

        if board.isValidMove(for: piece, from: from, to: to, enPassant: enPassantSquare) {
            var copy = board
            copy[from.0, from.1] = nil
            var movedPiece = piece

            if piece.type == .pawn, let ep = enPassantSquare, ep == to, captured == nil {
                let capPos = (from.0, to.1)
                captured = board[capPos.0, capPos.1]
                copy[capPos.0, capPos.1] = nil
            }

            if piece.type == .pawn && (to.0 == 7 || to.0 == 0) {
                movedPiece = Piece(.queen, piece.color)
            }

        let destinationPiece = board[to.0, to.1]

        if board.isValidMove(for: piece, from: from, to: to) {
            var copy = board
            copy[from.0, from.1] = nil
            var movedPiece = piece
            if piece.type == .pawn && (to.0 == 7 || to.0 == 0) {
                movedPiece = Piece(.queen, piece.color)
            }
            copy[to.0, to.1] = movedPiece

            if copy.isKingInCheck(currentTurn) {
                throw GameError.invalidMove
            }

            board = copy
        } else if piece.type == .king && from.1 == 4 && (to.1 == 6 || to.1 == 2) {
            try castle(from: from, to: to, color: piece.color)
            captured = nil
        } else {
            history.removeLast()
            throw GameError.invalidMove
        }

        if piece.type == .pawn && abs(to.0 - from.0) == 2 {
            let direction = piece.color == .white ? 1 : -1
            enPassantSquare = (from.0 + direction, from.1)
        } else {
            enPassantSquare = nil
        }

        updateCastlingRights(piece: piece, from: from, to: to, captured: captured)

        } else {
            throw GameError.invalidMove
        }

        updateCastlingRights(piece: piece, from: from, to: to, captured: destinationPiece)

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
        board.isKingInCheck(color) && board.generateMoves(for: color, enPassant: enPassantSquare).isEmpty
    }

    public func isStalemate(for color: PieceColor) -> Bool {
        !board.isKingInCheck(color) && board.generateMoves(for: color, enPassant: enPassantSquare).isEmpty
        board.isKingInCheck(color) && board.generateMoves(for: color).isEmpty
    }

    public func isStalemate(for color: PieceColor) -> Bool {
        !board.isKingInCheck(color) && board.generateMoves(for: color).isEmpty
    }

    private func canCastleKingside(color: PieceColor) -> Bool {
        let rank = color == .white ? 0 : 7
        let opponent: PieceColor = color == .white ? .black : .white
        if color == .white && !castlingRights.whiteKingside { return false }
        if color == .black && !castlingRights.blackKingside { return false }
        guard board[rank, 4]?.type == .king, board[rank, 7]?.type == .rook else {
            return false
        }
        if board[rank,5] != nil || board[rank,6] != nil { return false }
        if board.isSquareAttacked((rank,4), by: opponent) ||
            board.isSquareAttacked((rank,5), by: opponent) ||
            board.isSquareAttacked((rank,6), by: opponent) { return false }
        return true
    }

    private func canCastleQueenside(color: PieceColor) -> Bool {
        let rank = color == .white ? 0 : 7
        let opponent: PieceColor = color == .white ? .black : .white
        if color == .white && !castlingRights.whiteQueenside { return false }
        if color == .black && !castlingRights.blackQueenside { return false }
        guard board[rank, 4]?.type == .king, board[rank, 0]?.type == .rook else {
            return false
        }
        if board[rank,1] != nil || board[rank,2] != nil || board[rank,3] != nil { return false }
        if board.isSquareAttacked((rank,4), by: opponent) ||
            board.isSquareAttacked((rank,3), by: opponent) ||
            board.isSquareAttacked((rank,2), by: opponent) { return false }
        return true
    }

    private mutating func castle(from: (Int, Int), to: (Int, Int), color: PieceColor) throws {
        let rank = color == .white ? 0 : 7
        if to.1 == 6 {
            guard canCastleKingside(color: color) else { throw GameError.invalidMove }
            board[rank,4] = nil
            board[rank,6] = Piece(.king, color)
            board[rank,7] = nil
            board[rank,5] = Piece(.rook, color)
        } else {
            guard canCastleQueenside(color: color) else { throw GameError.invalidMove }
            board[rank,4] = nil
            board[rank,2] = Piece(.king, color)
            board[rank,0] = nil
            board[rank,3] = Piece(.rook, color)
        }
    }

    private mutating func updateCastlingRights(piece: Piece, from: (Int, Int), to: (Int, Int), captured: Piece?) {
        switch piece.type {
        case .king:
            if piece.color == .white {
                castlingRights.whiteKingside = false
                castlingRights.whiteQueenside = false
            } else {
                castlingRights.blackKingside = false
                castlingRights.blackQueenside = false
            }
        case .rook:
            if piece.color == .white {
                if from == (0,0) { castlingRights.whiteQueenside = false }
                if from == (0,7) { castlingRights.whiteKingside = false }
            } else {
                if from == (7,0) { castlingRights.blackQueenside = false }
                if from == (7,7) { castlingRights.blackKingside = false }
            }
        default: break
        }

        if let cap = captured, cap.type == .rook {
            if cap.color == .white {
                if to == (0,0) { castlingRights.whiteQueenside = false }
                if to == (0,7) { castlingRights.whiteKingside = false }
            } else {
                if to == (7,0) { castlingRights.blackQueenside = false }
                if to == (7,7) { castlingRights.blackKingside = false }
            }
        }
    }

    public mutating func undo() {
        guard let last = history.popLast() else { return }
        redoStack.append(GameState(board: board, currentTurn: currentTurn, castlingRights: castlingRights, enPassantSquare: enPassantSquare))
        board = last.board
        currentTurn = last.currentTurn
        castlingRights = last.castlingRights
        enPassantSquare = last.enPassantSquare
    }

    public mutating func redo() {
        guard let next = redoStack.popLast() else { return }
        history.append(GameState(board: board, currentTurn: currentTurn, castlingRights: castlingRights, enPassantSquare: enPassantSquare))
        board = next.board
        currentTurn = next.currentTurn
        castlingRights = next.castlingRights
        enPassantSquare = next.enPassantSquare
    }

    public mutating func applyMove(from: (Int, Int), to: (Int, Int)) {
        let piece = board[from.0, from.1]
        board[from.0, from.1] = nil
        board[to.0, to.1] = piece
        currentTurn = currentTurn == .white ? .black : .white
    }

}
