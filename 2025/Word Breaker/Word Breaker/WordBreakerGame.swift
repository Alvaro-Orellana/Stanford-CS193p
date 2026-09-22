
//
//  WordBreaker.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import Foundation


struct WordBreakerGame {
    private(set) var masterCode: Code
    private(set) var guessCode: Code
    private(set) var attempts: [Code] = []
    static let choices: [Character] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    init(masterWord: String) {
        masterCode = Code(kind: .master(isHidden: false), word: masterWord)
        guessCode = Code(kind: .guess, word: String(repeating: Code.empty, count: masterWord.count))
    }
    
    var isOver: Bool {
        attempts.last?.word == masterCode.word
    }
    
    var keyBoardMatches: [Character: Match] {
        guard let lastWord = attempts.last?.word, let matches = attempts.last?.matches else { return [:] }
        
        let dict = (Dictionary(uniqueKeysWithValues: zip(lastWord, matches)))
        return dict
        
    }
    
    mutating func deleteLetter(at index: Int) {
        replaceGuessCharacter(at: index, with: Character(Code.empty))
    }
    
    mutating func setGuess(to character: Character, at index: Int) {
        replaceGuessCharacter(at: index, with: character)
    }

    private mutating func replaceGuessCharacter(at index: Int, with character: Character) {
        var characters = Array(guessCode.word)
        guard characters.indices.contains(index) else { return }

        characters[index] = character
        guessCode.word = String(characters)
    }
    
    mutating func submitGuess() {
        let matches = masterCode.match(against: guessCode)
        attempts.append(Code(kind: .attempt(matches), word: guessCode.word))
        guessCode.clear()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
}
