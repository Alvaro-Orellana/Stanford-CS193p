//
//  WordBreakerView.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import SwiftUI

struct WordBreakerView: View {
    
    @Environment(\.words) var words
    @State private var game = WordBreaker(masterWord: Code.empty) // it is populated in onChange(of:)
    @State private var wordCount = 0
    @State private var selection: Int = 0
    @State private var didSubmitInvalidWord = false
    
    var body: some View {
        VStack {
            CodeView(code: game.masterCode, selection: $selection)
            Divider()
            CodeView(code: game.guessCode, selection: $selection)
            ScrollView {
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index], selection: $selection)
                }
            }
            submitButton
            ChoicesView(choices: game.choices) { character in
                game.setGuess(to: character, at: selection)
                selection = (selection + 1) % game.guessCode.word.count
            }
        }
        .padding()
        .onChange(of: words.count, initial: true) {
            guard game.attempts.isEmpty else { return } // don’t disrupt a game in progress
            
            wordCount = Int.random(in: 3...6)
            game.masterCode.word = words.isEmpty ? "AWAIT" : words.random(length: wordCount) ?? "ERROR"
            game.guessCode.word = String(repeating: Code.empty, count: wordCount)
        }
    }
    
    var submitButton: some View {
        Button("Submit") {
//            let guess = game.guessCode.word.lowercased()
//            guard UITextChecker().isAWord(guess) else {
//                didSubmitInvalidWord = true
//                return
//            }
            game.submitGuess()
        }
        .font(.title)
        .alert("\(game.guessCode.word) doesn't exist in the english language", isPresented: $didSubmitInvalidWord) {
            Button("Ok") { }
        } message: {
            Text("Check it and try another one")
        }
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
                    .fill(color(for: code.kind, index: index))
                    .stroke(Letter.borderColor, lineWidth: Letter.lineWidth)
                    .aspectRatio(Letter.aspectRatio, contentMode: .fit)
                    .overlay {
                        Text(characters[index].description)
                            .font(.largeTitle)
                    }
                    .onTapGesture { selection = index }
                    .padding(Letter.padding)
                    .background {
                        if code.kind == .guess && selection == index {
                            Letter.shape.foregroundStyle(Letter.selectionColor)
                        }
                    }
            }
        }
    }
    
    func color(for kind: Code.Kind, index: Int) -> Color {
        switch kind {
        case .master, .guess: return Color.white
        case .attempt(let matches):
            switch matches[index] {
            case .exact: return Color.green
            case.inexact: return Color.yellow
            case .noMatch: return Color.white
            }
        }
    }
    
    struct Letter {
        static let shape = RoundedRectangle(cornerRadius: 10)
        static let borderColor = Color.black
        static let lineWidth: CGFloat = 2
        static let aspectRatio: CGFloat = 2/3
        static let padding: CGFloat = 7
        static let selectionColor = Color(hue: 148/360, saturation: 0, brightness: 0.8)
    }
}

private struct ChoicesView: View {
    let choices: [Character]
    let choiceTapped: (Character) -> Void
    let rows = [
        GridItem(.adaptive(minimum: 38)),
    ]
    
    var body: some View {
        LazyHGrid(rows: rows) {
            ForEach(choices.indices, id: \.self) { index in
                Circle()
                    .stroke()
                    .overlay { Text(String(choices[index])) }
                    .onTapGesture { choiceTapped(choices[index]) }
            }
        }
    }
}

#Preview {
    WordBreakerView()
}
