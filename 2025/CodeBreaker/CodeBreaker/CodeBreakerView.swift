//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    // [.blue, .yellow, .red, .green, .orange, .purple]
    static let themes: [String: [String]] = [
        "emoji faces": "😀😃🥲🥰😋".map(String.init),
        "emoji balls": "⚽️🏈🏀🎾🎱🏐🏉".map(String.init),
        "emoji vehicles": "🚕🏎️🚚🚓🚜🚌🛵".map(String.init),
        "colors": "green red blue orange purple yellow".components(separatedBy: .whitespaces)
    ]

    @State var model = CodeBreaker(
        pegChoices: themes["emoji faces"]!,
        pegsNumber: Int.random(in: 3...6)
    )
    @State private var isRepeatedGuess = false

    var body: some View {
        VStack {
            pegsRow(for: model.masterCode)
            Rectangle().fill(Color.gray).frame(height: 2)
            pegsRow(for: model.guess)
            ScrollView {
                ForEach(model.attempts.indices.reversed(), id: \.self) { index in
                    pegsRow(for: model.attempts[index])
                }
            }
            Button(action: { model.resetGame() }) {
                Text("New Game")
            }
        }
        .padding()
    }
    
    
    func pegsRow(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(named: code.pegs[index]) ?? .clear)
                    .strokeBorder(lineWidth: 2)
                    .aspectRatio(1, contentMode: .fit)
                    .contentShape(Circle())
                    .overlay {
                        let contentIsColor = Color(named: code.pegs[index]) != nil
                        Text(contentIsColor ? "" : code.pegs[index])
                            .font(.system(size: 80))
                            .minimumScaleFactor(0.2)
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
    
    var submitButton: some View {
        Button {
            if model.isNewGuess {
                model.submitAttempt()
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

extension Color {
    init?(named name: String) {
        switch name.lowercased() {
        case "red": self = .red
        case "blue": self = .blue
        case "green": self = .green
        case "yellow": self = .yellow
        case "orange": self = .orange
        case "purple": self = .purple
        case "pink": self = .pink
        case "gray", "grey": self = .gray
        case "black": self = .black
        case "white": self = .white
        default: return nil
        }
    }
}

