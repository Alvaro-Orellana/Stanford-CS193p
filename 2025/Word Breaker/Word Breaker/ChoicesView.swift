//
//  ChoicesView.swift
//  
//
//  Created by Alvaro Orellana on 22-09-26.
//
import SwiftUI

struct ChoicesView: View {
    let choices: [Character]
    let dict: [Character: Match]
    let choiceTapped: (Character) -> Void
    let backButtonPressed: (() -> Void)?
    private let columns = [GridItem(.adaptive(minimum: 30))]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(choices.indices, id: \.self) { index in
                Circle()
                    .stroke()
                    .fill(color(for: choices[index]))
                    .overlay {
                        Text(String(choices[index]))
                    }
                    .onTapGesture {
                        choiceTapped(choices[index])
                    }
            }
            Button {
                backButtonPressed?()
            } label: {
                Text("🔙")
            }
        }
        .aspectRatio(10/3, contentMode: .fit)
    }
   
    private func color(for character: Character) -> Color {
        switch dict[character] {
        case .exact: .green
        case .inexact: .yellow
        default: .clear
        }
    }
}

#Preview {
    ChoicesView(choices: Array("ABCDE"), dict: [:]) { character in
        print("Character \(character) was tapped")
    } backButtonPressed: { }
}
