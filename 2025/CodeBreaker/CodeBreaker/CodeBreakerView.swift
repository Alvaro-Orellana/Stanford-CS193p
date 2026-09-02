//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    @State var model = CodeBreaker()

    var body: some View {
        VStack {
            pegs(for: model.masterCode)
            Rectangle().fill(Color.gray).frame(height: 2)
            pegs(for: model.guess)
            ScrollView {
                ForEach(model.attempts.indices.reversed(), id: \.self) { index in
                    pegs(for: model.attempts[index])
                }
            }
            Button(action: { model.resetGame() }) {
                Text("New Game")
            }
        }
        .padding()
    }
    
    func pegs(for code: Code) -> some View {
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in
                Circle()
                    .fill(code.pegs[index])
                    .onTapGesture {
                        if code.kind == .guess {
                            model.tappedGuessPeg(at: index)
                        }
                    }
                    .overlay {
                        Circle().strokeBorder(lineWidth: 3)
                    }
            }
            MatchMarkers(matches: model.matches(for: code))
                .opacity(code.kind == .guess ? 0 : 1)
                .overlay {
                    if code.kind == .guess {
                        submitButton
                    }
                }
        }
    }
    
    var submitButton: some View {
        Button(action: { model.submitAttempt() }) {
            Text("Submit")
                .font(.largeTitle)
                .minimumScaleFactor(0.2)
        }
        .disabled(!model.hasAnySelectedPeg)
    }
}

#Preview {
    CodeBreakerView()
}
