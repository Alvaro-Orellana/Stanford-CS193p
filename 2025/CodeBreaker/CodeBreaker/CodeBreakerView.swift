//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    static let themes: [String: [String]] = [
        "Colors":
            "green,red,blue,orange,purple,yellow,white,black,brown,cyan".components(separatedBy: .punctuationCharacters),
        "Faces": "😀😃🥲🥰😋".map(String.init),
        "Balls": "⚽️🏈🏀🎾🎱🏐🏉".map(String.init),
        "Vehicles": "🚕🏎️🚚🚓🚜🚌🛵".map(String.init),
    ]

    // Model is initializated with no useful parameters and is populated with them on appear
    @State var model = CodeBreaker(pegChoices: [], pegsNumber: 0)
    @State private var isRepeatedGuess = false
    @State private var title: String = ""
    
    private func newGame() {
        let randomtheme = Self.themes.randomElement()!
        title = randomtheme.key
        model = CodeBreaker(pegChoices: randomtheme.value, pegsNumber: Int.random(in: 3...6))
    }

    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle)
                .bold()
            pegsRow(for: model.masterCode)
            Rectangle()
                .fill(Color.gray)
                .frame(height: 2)
            pegsRow(for: model.guess)
            ScrollView {
                ForEach(model.attempts.indices.reversed(), id: \.self) { index in
                    pegsRow(for: model.attempts[index])
                }
            }
            Button(action: newGame) {
                Text("New Game")
            }
        }
        .padding()
        .onAppear(perform: newGame)
    }
    
    private func pegsRow(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                let peg = code.pegs[index]
                let pegColor = Color(named: peg)
                
                RoundedRectangle(cornerRadius: 15)
                    .fill(pegColor ?? .clear)
                    .strokeBorder(lineWidth: peg == Code.clear ? 1 : 0)
                    .aspectRatio(1, contentMode: .fit)
                    .contentShape(Circle())
                    .overlay {
                        let contentIsColor = pegColor != nil
                        Text(contentIsColor ? "" : peg)
                            .font(.system(size: 120))
                            .minimumScaleFactor(9/120)
                    }
                    .onTapGesture {
                        if code.kind == .guess {
                            model.tappedGuessPeg(at: index)
                        }
                    }
            }
            MatchMarkersView(matches: model.matches(for: code))
                .opacity(code.kind == .guess ? 0 : 1)
                .overlay {
                    if code.kind == .guess {
                        submitButton
                    }
                }
        }
    }
    
    private var submitButton: some View {
        Button {
            if model.isGuessNew {
                model.submitGuess()
            } else {
                isRepeatedGuess = true
            }
        } label: {
            Text("Submit")
                .font(.largeTitle)
                .minimumScaleFactor(0.2)
        }
        .disabled(!model.hasAnySelectedPeg)
        .alert("You already tried this combination", isPresented: $isRepeatedGuess) {
            Button("OK") { }
        } message: {
            Text("Check it and try another one")
        }
    }
}

#Preview {
    CodeBreakerView()
}
