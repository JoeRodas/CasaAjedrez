import Testing
@testable import CasaAjedrez

@Test func boardSetup() async throws {
    let game = Game()
    // White pawn at starting rank
    #expect(game.board[1, 0]?.type == .pawn)
    #expect(game.board[1, 0]?.color == .white)
    // Black pawn at opposite side
    #expect(game.board[6, 0]?.color == .black)

    // Major pieces
    #expect(game.board[0, 0]?.type == .rook)
    #expect(game.board[0, 1]?.type == .knight)
    #expect(game.board[0, 3]?.type == .queen)

    // Rook placement
    #expect(game.board[0, 0]?.type == .rook)

}

@Test func aiMove() async throws {
    let game = Game()
    let ai = MinimaxAI()
    let move = ai.chooseMove(from: game.board)
    #expect(move != nil)

    if let m = move {
        let piece = game.board[m.from.0, m.from.1]!
        #expect(game.board.isValidMove(for: piece, from: m.from, to: m.to))
    }
}

    #expect(move?.from.0 == 1)
    #expect(move?.to.0 == 2)
}


@Test func invalidMove() async throws {
    var game = Game()
    do {
        try game.applyMove(from: (0, 0), to: (1, 1))
        #expect(Bool(false)) // should not reach
    } catch {
        #expect(error is GameError)
    }
    #expect(game.board[0, 0]?.type == .rook)
    #expect(game.board[1, 1]?.type == .pawn)
}

@Test func pawnCapture() async throws {
    var game = Game()
    try game.applyMove(from: (1, 0), to: (3, 0))
    try game.applyMove(from: (6, 1), to: (4, 1))
    try game.applyMove(from: (3, 0), to: (4, 1))
    #expect(game.board[4, 1]?.color == .white)
    #expect(game.board[4, 1]?.type == .pawn)
}

@Test func knightMove() async throws {
    var game = Game()
    try game.applyMove(from: (0, 1), to: (2, 2))
    #expect(game.board[2, 2]?.type == .knight)
}

@Test func bishopMove() async throws {
    var board = Board()
    board[1, 3] = nil // clear pawn in front of bishop
    let bishop = board[0, 2]!
    #expect(board.isValidMove(for: bishop, from: (0, 2), to: (3, 5)))
}


@Test func checkDetection() async throws {
    var board = Board(empty: true)
    board[0, 4] = Piece(.king, .white)
    board[7, 4] = Piece(.king, .black)
    board[1, 4] = Piece(.rook, .white)
    #expect(board.isKingInCheck(.black))
}

@Test func checkmateDetection() async throws {
    var board = Board(empty: true)
    board[0, 0] = Piece(.king, .white)
    board[7, 7] = Piece(.king, .black)
    board[1, 0] = Piece(.rook, .black)
    board[0, 1] = Piece(.rook, .black)
    board[1, 1] = Piece(.queen, .black)
    let game = Game(board: board)
    #expect(game.isCheckmate(for: .white))
}

@Test func castlingMove() async throws {
    var board = Board(empty: true)
    board[0, 4] = Piece(.king, .white)
    board[0, 7] = Piece(.rook, .white)
    board[7, 4] = Piece(.king, .black)
    let game = Game(board: board)
    var g = game
    try g.applyMove(from: (0,4), to: (0,6))
    #expect(g.board[0,6]?.type == .king)
    #expect(g.board[0,5]?.type == .rook)
}

@Test func pawnPromotion() async throws {
    var board = Board(empty: true)
    board[6, 0] = Piece(.pawn, .white)
    board[0, 4] = Piece(.king, .white)
    board[7, 4] = Piece(.king, .black)
    var game = Game(board: board)
    try game.applyMove(from: (6,0), to: (7,0))
    #expect(game.board[7,0]?.type == .queen)
    #expect(game.board[7,0]?.color == .white)
}

