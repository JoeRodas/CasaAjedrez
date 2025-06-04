#if canImport(SwiftUI)
import SwiftUI

public struct WelcomeScreen: View {
    @State private var showChooser = false

    public init() {}

    public var body: some View {
        Group {
            if showChooser {
                ChooseColorView()
            } else {
                VStack {
                    Spacer()
                    Text("Casa Ajedrez")
                        .font(.largeTitle)
                    Text("Made by Feliz Software Miami")
                        .font(.caption)
                    Spacer()
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showChooser = true
                        }
                    }
                }
            }
        }
    }
}
#endif
