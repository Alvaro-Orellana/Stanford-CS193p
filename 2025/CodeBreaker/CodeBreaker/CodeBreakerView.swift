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
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
            pegsRow(for: game.masterCode)
            Divider()
            pegsRow(for: game.guess)
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    pegsRow(for: game.attempts[index])
                }
            }
            pegChooser
                .padding(.bottom)
            Button(action: newGame) {
                Text("New Game")
            }
        }
        .padding()
        .onAppear(perform: newGame)
    }
    
    private var pegChooser: some View {
        HStack {
            ForEach(game.pegChoices, id: \.self) { peg in
                PegView(peg)
                    .onTapGesture {
                        game.setGuessPeg(to: peg, at: selection)
                    }
            }
        }
    }
    
    private func pegsRow(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                PegView(code.pegs[index])
                    .padding(5)
                    .background {
                        if code.kind == .guess, index == selection {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray(0.85))
                        }
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            selection = index
                        }
                    }
            }
            RoundedRectangle(cornerRadius: 15)
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(.clear)
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
        Button {
            if game.isGuessNew {
                withAnimation { game.submitGuess() }
            } else {
                isRepeatedGuess = true
            }
        } label: {
            Text("Submit")
                .font(.system(size: 80))
                .minimumScaleFactor(0.1)
        }
        .disabled(!game.hasAnySelectedPeg)
        .alert("You already tried this combination", isPresented: $isRepeatedGuess) {
            Button("OK") { }
        } message: {
            Text("Check it and try another one")
        }
    }
}