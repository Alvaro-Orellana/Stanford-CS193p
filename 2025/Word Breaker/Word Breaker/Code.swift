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
    func match(against otherCode: Code) -> [Match] {
        let word = Array(self.word)
        let otherWord = Array(otherCode.word)
        
        let exactMatches: [Match] = word.indices.map { i in
            if i < otherWord.count && word[i] == otherWord[i] {
                return .exact
            } else {
                return .noMatch
            }
        }
        let inexactMatches: [Match] = word.indices.reversed().map { i in
            if i < otherWord.count && word[i] != otherWord[i] {
                if word.contains(otherWord[i]) {
                    
                }
            }
            
        }
        
    }
    
    mutating func clear() {
        let spacesCount = word.count
        word = String(repeating: Code.empty, count: spacesCount)
    }
}
