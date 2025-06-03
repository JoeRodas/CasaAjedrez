import Testing
@testable import CasaAjedrez

@Test func boardSetup() async throws {
    let game = Game()
    // White pawn at starting rank
    #expect(game.board[1, 0]?.type == .pawn)
    #expect(game.board[1, 0]?.color == .white)
    // Black pawn at opposite side
    #expect(game.board[6, 0]?.color == .black)
    // Rook placement
    #expect(game.board[0, 0]?.type == .rook)
}

@Test func aiMove() async throws {
    let game = Game()
    let ai = MinimaxAI()
    let move = ai.chooseMove(from: game.board)
    #expect(move != nil)
    #expect(move?.from.0 == 1)
    #expect(move?.to.0 == 2)
}
