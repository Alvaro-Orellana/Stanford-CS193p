//
//  MemoryGame.swift
//  Memorize2024
//
//  Created by Alvaro Orellana on 04-05-24.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score: Int
    private var previouslySeenCards: Set<Card.ID>
    private var firstPickDate: Date
    
    init(numberOfPairsOfCards: Int, cardContentGenerator: (Int) -> CardContent) {
        cards = []
        previouslySeenCards = []
        score = 0
        firstPickDate = .now
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let cardContent = cardContentGenerator(pairIndex)
            cards.append(Card(id: "\(pairIndex+1)A", content: cardContent))
            cards.append(Card(id: "\(pairIndex+1)B", content: cardContent))
        }
        cards.shuffle()
    }
    
    // Holds the index only when exactly one card is face up; setting it turns all other cards face down.
    private var singleFaceUpIndex: Int? {
        get {
            cards.indices.filter{ cards[$0].isFaceUp }.onlyOne
        }
        set {
            // Turn all cards face down except the newly selected index.
            cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue }
        }
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(with: card.id),
                !cards[chosenIndex].isMatched,
                !cards[chosenIndex].isFaceUp
        else { return }
        
        // If there was one and only one card face up, check for a match.
        if let singleFaceUpIndex {
            cards[chosenIndex].isFaceUp = true
            
            if cards[singleFaceUpIndex].content == cards[chosenIndex].content {
                cardsDidMatch(at: chosenIndex, and: singleFaceUpIndex)
            } else {
                penalizeIfPreviouslySeen(chosenIndex)
                penalizeIfPreviouslySeen(singleFaceUpIndex)
            }
            previouslySeenCards.formUnion([cards[chosenIndex].id, cards[singleFaceUpIndex].id])
        } else {
        // Either two cards were face up or all cards were face down
            singleFaceUpIndex = chosenIndex
            firstPickDate = .now
        }
    }
    
    private mutating func cardsDidMatch(at firstIndex: Int, and secondIndex: Int) {
        cards[firstIndex].isMatched = true
        cards[secondIndex].isMatched = true
        
        let secondsPassed = Date().timeIntervalSince(firstPickDate)
        score += 200 - Int(secondsPassed) * 20
    }
    
    private mutating func penalizeIfPreviouslySeen(_ index: Int) {
        if previouslySeenCards.contains(cards[index].id) {
            score -= 100
        }
    }

    struct Card: Identifiable, Equatable {
        let id: String
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
    }
}


func factorial(n: Int) -> Int {
    (1...n).product()
}
