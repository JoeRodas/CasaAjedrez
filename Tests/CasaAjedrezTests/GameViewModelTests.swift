#if canImport(SwiftUI)
import Testing
@testable import CasaAjedrez

@available(iOS 13.0, *)
@Test func aiMovesFirstWhenHumanPlaysBlack() async throws {
    let viewModel = GameViewModel(humanColor: .black)
    #expect(viewModel.game.currentTurn == .black)
}

@available(iOS 13.0, *)
@Test func messageAppearsOnCheckmate() async throws {
    var board = Board(empty: true)
    board[0,0] = Piece(.king, .black)
    board[7,7] = Piece(.king, .white)
    board[1,0] = Piece(.rook, .white)
    board[0,2] = Piece(.rook, .white)
    let game = Game(board: board, currentTurn: .white)
    let viewModel = GameViewModel(humanColor: .white, game: game)
    viewModel.tapSquare(rank: 0, file: 2)
    viewModel.tapSquare(rank: 0, file: 1)
    #expect(viewModel.message != nil)
}
#endif
