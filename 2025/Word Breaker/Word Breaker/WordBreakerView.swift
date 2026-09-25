//
//  WordBreakerView.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import SwiftUI

struct WordBreakerView: View {
    
    @Environment(\.words) var words: Words
    @State private var game = WordBreakerGame(masterWord: "AWAIT")
    @State private var selection: Int = 0
    @State private var requestedWordLength = 4
    @State private var didSubmitInvalidWord = false
    @State private var isShowingRestartPrompt = false
    @State private var dict: [Character: Match] = [:]

    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            Divider()
            if !game.isOver {
                CodeView(code: game.guessCode, selection: $selection, ancillaryView: { submitButton })
            }
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index])
                }
            }
            restartButton
            ChoicesView(
                choices: WordBreakerGame.choices,
                dict: dict,
            ) { character in
                game.setGuess(to: character, at: selection)
                moveSelection(by: +1)
            } backButtonPressed: {
                game.deleteLetter(at: selection)
                moveSelection(by: -1)
            }
        }
        .padding()
        .onChange(of: words.wordsDidLoad, initial: true) {
            startNewGame(length: requestedWordLength)
        }
    }
    
    private var restartButton: some View {
        Button("Restart") {
            isShowingRestartPrompt = true
        }
        .font(.largeTitle)
        .alert("Ingresa un número", isPresented: $isShowingRestartPrompt) {
            TextField("Número", value: $requestedWordLength, format: .number)
                .keyboardType(.numberPad)
            Button("Cancelar", role: .cancel) {}
            Button("Aceptar") { startNewGame(length: requestedWordLength) }
                .disabled(!isValidWordLength)
        } message: {
            Text("El número debe estar entre 3 y 6")
        }
    }
    
    private var submitButton: some View {
        Button("Submit", action: submitGuess)
            .alert("\(game.guessCode.word) doesn't exist in the English language", isPresented: $didSubmitInvalidWord) {
                Button("OK") { }
            } message: {
                Text("Check it and try another one")
            }
    }

    private var isValidWordLength: Bool {
        (3...6).contains(requestedWordLength)
    }

    private func submitGuess() {
        let guess = game.guessCode.word.lowercased()
//        guard UITextChecker().isAWord(guess) else {
//            didSubmitInvalidWord = true
//            return
//        }
        game.submitGuess()
        updateDictionary(game.attempts.last?.matches ?? [])
        
        selection = 0
    }
    
    func updateDictionary(_ latestMatches: [Match]) {
        for (character, match) in zip(Array(game.masterCode.word), latestMatches) {
            switch match {
            case .exact:
                dict[character] = match
            case .inexact where dict[character] != .exact:
                dict[character] = match
            default: break
            }
        }
    }
    
    private func moveSelection(by offset: Int) {
        let count = game.guessCode.word.count
        guard count > 0 else { return }

        selection = (selection + offset + count) % count
    }

    private func startNewGame(length: Int) {
        selection = 0
        let randomWord = words.random(length: length) ?? "AWAIT"
        game = WordBreakerGame(masterWord: randomWord)
    }
}

#Preview {
    WordBreakerView()
}
