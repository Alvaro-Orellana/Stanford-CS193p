//
//  WordBreakerView.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import SwiftUI

struct WordBreakerView: View {
    
    @Environment(\.words) var words: Words
    @State private var game = WordBreakerGame(masterWord: "")
    @State private var selection: Int = 0
    @State private var didSubmitInvalidWord = false
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode, selection: $selection)
            Divider()
            if !game.isOver {
                CodeView(code: game.guessCode, selection: $selection)
            }
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index], selection: $selection)
                }
            }
            HStack {
                restart
                Spacer()
                submitButton
            }
            .font(.largeTitle)
            .padding(.horizontal)
            
            ChoicesView(choices: game.choices) { character in
                game.setGuess(to: character, at: selection)
                selection = (selection + 1) % game.guessCode.word.count
            }
        }
        .padding()
        .onChange(of: words.wordsLoaded, initial: true) {
            game = WordBreakerGame(masterWord: randomWord())
        }
    }
    
    var restart: some View {
        Button("Restart") {
            selection = 0
            game = WordBreakerGame(masterWord: randomWord())
        }
        .buttonStyle(.automatic)
    }
    
    var submitButton: some View {
        Button("Submit") {
            let guess = game.guessCode.word.lowercased()
            guard UITextChecker().isAWord(guess) else {
                didSubmitInvalidWord = true
                return
            }
            selection = 0
            game.submitGuess()
        }
        .alert("\(game.guessCode.word) doesn't exist in the english language", isPresented: $didSubmitInvalidWord) {
            Button("Ok") { }
        } message: {
            Text("Check it and try another one")
        }
    }
    
    private func randomWord() -> String {
        words.random(length: Int.random(in: 3...6)) ?? "VOID"
    }

}

private struct CodeView: View {
    let code: Code
    @Binding var selection: Int
    
    var body: some View {
        HStack {
            let characters = Array(code.word)
            ForEach(characters.indices, id: \.self) { index in
                Letter.shape
                    .fill(cardColor(for: code.kind, index: index))
                    .aspectRatio(Letter.aspectRatio, contentMode: .fit)
                    .overlay {
                        Text(characters[index].description)
                            .font(.largeTitle)
                            .foregroundStyle(Color(.systemBackground))
                    }
                    .onTapGesture { selection = index }
                    .padding(Letter.selectionPadding)
                    .background {
                        if code.kind == .guess && selection == index {
                            Letter.shape.foregroundStyle(Letter.selectionColor)
                        }
                    }
            }
        }
    }
    
    private func cardColor(for kind: Code.Kind, index: Int) -> Color {
        switch kind {
        case .master, .guess: return Color.primary
        case .attempt(let matches):
            switch matches[index] {
            case .exact: return Color.green
            case.inexact: return Color.yellow
            case .noMatch: return Color.primary
            }
        }
    }

    
    struct Letter {
        static let shape = RoundedRectangle(cornerRadius: 10)
        static let lineWidth: CGFloat = 2
        static let aspectRatio: CGFloat = 2/3
        static let selectionPadding: CGFloat = 9
        static let selectionColor = Color(hue: 148/360, saturation: 0, brightness: 0.8)
    }
}

private struct ChoicesView: View {
    let choices: [Character]
    let choiceTapped: (Character) -> Void
    private let columns = [
        GridItem(.adaptive(minimum: 30))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(choices.indices, id: \.self) { index in
                Circle()
                    .stroke()
                    .overlay {
                        Text(String(choices[index]))
                    }
                    .onTapGesture {
                        choiceTapped(choices[index])
                    }
            }
        }.aspectRatio(10/3, contentMode: .fit)
    }
}

#Preview {
    WordBreakerView()
}
