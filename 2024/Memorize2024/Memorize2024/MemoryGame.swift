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
    private var previouslySeenCards: [Card.ID]
    private var dateFirstCardWasChosen: Date
    
    init(numberOfPairsOfCards: Int, cardContentGenerator: (Int) -> CardContent) {
        cards = []
        previouslySeenCards = []
        score = 0
        dateFirstCardWasChosen = .now
        
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let cardContent = cardContentGenerator(pairIndex)
            cards.append(Card(id: "\(pairIndex+1)A", content: cardContent))
            cards.append(Card(id: "\(pairIndex+1)B", content: cardContent))
        }
        cards.shuffle()
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter{ cards[$0].isFaceUp }.onlyOne
        }
        set {
            let faceUpCardsIDs = cards.filter(\.isFaceUp).map(\.id)
            previouslySeenCards.append(contentsOf: faceUpCardsIDs)
            
            // Turn all cards face down except the new setted index
            cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue }
        }
    }
    
    mutating func shuffleCards() {
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        // The index of the chosen card should always be in the cards array. Ignore a card if it's matched or face up
        guard
            let chosenCardIndex = cards.firstIndex(with: card.id), !cards[chosenCardIndex].isMatched, !cards[chosenCardIndex].isFaceUp
        else { return }
        
        // Check if there is one and only one card face up
        if let potencialMatchIndex = indexOfOneAndOnlyFaceUpCard {
            cards[chosenCardIndex].isFaceUp = true
            checkIfCardsMatch(card1Index: potencialMatchIndex, card2Index: chosenCardIndex)
        } else {
        // Either two cards were face up or all cards were face down
            indexOfOneAndOnlyFaceUpCard = chosenCardIndex
            dateFirstCardWasChosen = .now
        }
    }
    
    private mutating func checkIfCardsMatch(card1Index: Int, card2Index: Int) {
        
        if cards[card1Index].content == cards[card2Index].content {
            cards[card1Index].isMatched = true
            cards[card2Index].isMatched = true

            let secondsPassed = Date().timeIntervalSince(dateFirstCardWasChosen)
            score += 200 - Int(secondsPassed) * 20
        } else {
            // Cards did not match. Decrement score if they were already seen
            if previouslySeenCards.contains(cards[card1Index].id) {
                score -= 100
            }
            if previouslySeenCards.contains(cards[card2Index].id) {
                score -= 100
            }
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
