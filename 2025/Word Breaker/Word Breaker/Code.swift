//
//  Code.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import Foundation

enum Match {
    case exact
    case inexact
    case noMatch
}

struct Code {
    var kind: Kind
    var word: String = Code.empty
    
    static let empty = " "
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
    }
    
    // Main Algorithm of the game. The matching logic
    func match(against guess: Code) -> [Match] {
        var masterLetters = word.map(Optional.some)
        let guessLetters = Array(guess.word)
        var matches = Array(repeating: Match.noMatch, count: guessLetters.count)

        for i in matches.indices where guessLetters[i] == masterLetters[i] {
            matches[i] = .exact
            masterLetters[i] = nil
        }
        for i in matches.indices where matches[i] != .exact {
            if let matchIndex = masterLetters.firstIndex(of: guessLetters[i]) {
                matches[i] = .inexact
                masterLetters[matchIndex] = nil
            }
        }
        return matches
    }
    
    mutating func clear() {
        word = String(repeating: Code.empty, count: word.count)
    }
}
