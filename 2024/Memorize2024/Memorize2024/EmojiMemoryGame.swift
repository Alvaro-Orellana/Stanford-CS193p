//
//  EmojiMemoryGame.swift
//  Memorize2024
//
//  Created by Alvaro Orellana on 04-05-24.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    
    @Published private var model: MemoryGame<String>
    private var currentTheme: Theme
    
    init(theme: Theme) {
        self.currentTheme = theme
        self.model = Self.createNewGame(using: theme)
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var title: String {
        currentTheme.name
    }
    
    var color: Color {
        currentTheme.color
    }
    
    var score: Int {
        model.score
    }
    
    
    // MARK: - Intents
    
    func choose(_ card : MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffleCards()
    }
    
    func newGame() {
        self.model = Self.createNewGame(using: currentTheme)
    }
}


extension EmojiMemoryGame {
    
    static let themes = [
        Theme(
            name: "Sports",
            emoji: ["🏉", "🏐", "🏀", "⚽️", "🎾", "⚾️", "🏈", "🏓", "🏏", "🏒", "🏸" ,"🥏"],
            numberOfPairs: 7,
            color: .blue
        ),
        Theme(
            name: "Halloween",
            emoji: ["💀", "👻", "🎃", "🍬", "🕷️", "🕸️", "😱", "🙀", "😈", "👹"],
            numberOfPairs: nil,
            color: .orange
        ),
        Theme(
            name: "Vehicules",
            emoji: ["✈️", "🚕", "🚍", "🚅", "🚁", "🚑", "🚜", "🚂", "🚒", "🏎️", "🏸", "⛴️" ,"🚛"],
            numberOfPairs: 13,
            color: .yellow
        )
    ]
    
    private static func createNewGame(using theme: Theme) -> MemoryGame<String> {
        let numberOfPairs: Int
        if let pairs = theme.numberOfPairs {
            numberOfPairs = min(pairs, theme.emoji.count)
        } else {
            numberOfPairs = Int.random(in: 0..<theme.emoji.count)
        }
        
        var emojis = theme.emoji
        return MemoryGame(numberOfPairsOfCards: numberOfPairs) { emojiIndex in
            if !emojis.isEmpty {
                emojis.removeFirst()
            } else {
                "⁉️"
            }
        }
    }
}
