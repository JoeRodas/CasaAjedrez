#if canImport(SwiftUI)
import SwiftUI

@available(iOS 13.0, *)
public class GameViewModel: ObservableObject {
    @Published public private(set) var game: Game
    @Published public var selected: (Int, Int)? = nil
    @Published public var message: String? = nil

    private let humanColor: PieceColor
    private let ai = MinimaxAI()

    public init(humanColor: PieceColor, game: Game = Game()) {
        self.humanColor = humanColor
        self.game = game
        if humanColor == .black {
            makeAIMove()
        }
    }

    public func tapSquare(rank: Int, file: Int) {
        guard game.currentTurn == humanColor else { return }
        if let sel = selected {
            do {
                try game.applyMove(from: sel, to: (rank, file))
                withAnimation { self.game = game }
                selected = nil
                checkGameState()
                if game.currentTurn != humanColor {
                    makeAIMove()
                }
            } catch {
                selected = nil
            }
        } else if let piece = game.board[rank, file], piece.color == game.currentTurn {
            selected = (rank, file)
        }
    }

    private func makeAIMove() {
        guard let move = ai.chooseMove(from: game.board, for: game.currentTurn) else { return }
        do {
            try game.applyMove(from: move.from, to: move.to)
            withAnimation { self.game = game }
            checkGameState()
        } catch {}
    }

    private func checkGameState() {
        if game.isCheckmate(for: game.currentTurn) {
            message = game.currentTurn == humanColor ? "Checkmate. You lost." : "Checkmate! You won!"
        }
    }

    public func undo() { game.undo() }
    public func redo() { game.redo() }
}

@available(iOS 13.0, *)
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

@available(iOS 14.0, *)
public struct WelcomeView: View {
    @State private var selectedColor: PieceColor? = nil

    public init() {}

    public var body: some View {
        if let color = selectedColor {
            GameScreen(humanColor: color)
        } else {
            VStack(spacing: 16) {
                Text("Casa Ajedrez")
                    .font(.largeTitle)
                Text("Made by Casa Jose")
                    .font(.caption)
                Button("Play as White") { selectedColor = .white }
                Button("Play as Black") { selectedColor = .black }
            }
            .padding()
        }
    }
}

@available(iOS 14.0, *)
private struct GameScreen: View {
    @StateObject var viewModel: GameViewModel

    init(humanColor: PieceColor) {
        _viewModel = StateObject(wrappedValue: GameViewModel(humanColor: humanColor))
    }

    var body: some View {
        VStack {
            BoardView(viewModel: viewModel)
            if let msg = viewModel.message {
                Text(msg).font(.headline).padding(.top)
            }
        }
    }
}

private struct SquareView: View {
    let piece: Piece?
    @available(iOS 13.0.0, *)
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

