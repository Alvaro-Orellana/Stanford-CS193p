//
//  CodeBreakerView 2.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 15-09-26.
//


import SwiftUI

struct CodeBreakerView: View {
    
    // Model is initializated with no useful parameters and is populated with them on appear
    @State private var game = CodeBreakerGame(pegChoices: [], pegsNumber: 0)
    @State private var isRepeatedGuess = false
    @State private var title: String = ""
    @State private var selection: Int = 0
            
    static let themes: [String: [String]] = [
        "Colors": "green,red,blue,orange,purple,yellow,brown,cyan".components(separatedBy: .punctuationCharacters),
        "Faces": "😇😃🥲🥰😋".map(String.init),
        "Balls": "⚽️🏈🏀🎾🎱🏐🏉".map(String.init),
        "Vehicles": "🚕🏎️🚚🚓🚜🚌🛵".map(String.init),
    ]
    
    private func newGame() {
        let randomtheme = Self.themes.randomElement()!
        title = randomtheme.key
        game = CodeBreakerGame(pegChoices: randomtheme.value, pegsNumber: Int.random(in: 3...6))
        selection = 0
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
            view(for: game.masterCode)
            Divider()
            ScrollView {
                if !game.isOver {
                    view(for: game.guess)
                }
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index])
                }
            }
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(to: peg, at: selection)
                selection = (selection + 1) % game.guess.pegs.count
            }
            Button(action: newGame) {
                Text("New Game")
            }
        }
        .padding()
        .onAppear(perform: newGame)
    }
    
    private func view(for code: Code) -> some View {
        HStack {
            CodeView(code: code, selection: $selection)
            Color.clear
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches {
                        MatchMarkersView(matches: matches)
                    } else if code.kind == .guess {
                        submitButton
                    }
                }
        }
    }
    
    private var submitButton: some View {
        Button("Guess") {
            if game.isGuessNew {
                withAnimation { game.submitGuess(); selection = 0 }
                print(game.masterCode.pegs)
            } else {
                isRepeatedGuess = true
            }
        }
        .font(.system(size: 80))
        .minimumScaleFactor(0.1)
        .disabled(!game.hasAnySelectedPeg)
        .alert("You already tried this combination", isPresented: $isRepeatedGuess) {
            Button("OK") { }
        } message: {
            Text("Check it and try another one")
        }
    }
}

private struct CodeView: View {
    let code: Code
    @Binding var selection: Int
    
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.padding)
                .background {
                    if code.kind == .guess && index == selection {
                        Selection.shape.foregroundStyle(Selection.color)
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
    
    struct Selection {
        static let padding: CGFloat = 5
        static let shape = RoundedRectangle(cornerRadius: cornerRadius)
        static let cornerRadius: CGFloat = 10
        static let color = Color.gray(0.85)
    }
}

#Preview {
    CodeBreakerView()
}
