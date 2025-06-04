#if canImport(SwiftUI)
import SwiftUI

public class GameViewModel: ObservableObject {
    @Published public private(set) var game: Game
    @Published public var selected: (Int, Int)? = nil

    public init(game: Game = Game()) {
        self.game = game
    }

    public func tapSquare(rank: Int, file: Int) {
        if let sel = selected {
            do {
                try game.applyMove(from: sel, to: (rank, file))
                withAnimation { self.game = game }
            } catch {
                // ignore invalid
            }
            selected = nil
        } else {
            if let piece = game.board[rank, file], piece.color == game.currentTurn {
                selected = (rank, file)
            }
        }
    }

    public func undo() { game.undo() }
    public func redo() { game.redo() }
}

public struct BoardView: View {
    @ObservedObject var viewModel: GameViewModel

    public init(viewModel: GameViewModel) { self.viewModel = viewModel }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach((0..<8).reversed(), id: \.self) { rank in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { file in
                        SquareView(piece: viewModel.game.board[rank, file])
                            .background((rank + file) % 2 == 0 ? Color(.systemGray6) : Color(.systemGreen))
                            .onTapGesture { viewModel.tapSquare(rank: rank, file: file) }
                    }
                }
            }
        }
    }
}

private struct SquareView: View {
    let piece: Piece?
    var body: some View {
        Text(symbol(for: piece))
            .font(.system(size: 32))
            .frame(width: 44, height: 44)
    }

    func symbol(for piece: Piece?) -> String {
        guard let piece = piece else { return "" }
        switch (piece.type, piece.color) {
        case (.king, .white): return "\u{2654}"
        case (.queen, .white): return "\u{2655}"
        case (.rook, .white): return "\u{2656}"
        case (.bishop, .white): return "\u{2657}"
        case (.knight, .white): return "\u{2658}"
        case (.pawn, .white): return "\u{2659}"
        case (.king, .black): return "\u{265A}"
        case (.queen, .black): return "\u{265B}"
        case (.rook, .black): return "\u{265C}"
        case (.bishop, .black): return "\u{265D}"
        case (.knight, .black): return "\u{265E}"
        case (.pawn, .black): return "\u{265F}"
        }
    }
}
#endif

