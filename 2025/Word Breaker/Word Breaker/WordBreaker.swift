
//
//  WordBreaker.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import Foundation


struct WordBreaker {
    var masterCode: Code
    var guessCode: Code
    var attempts: [Code] = []
    let choices: [Character] = Array("QWERTYUIOPASDFGHJKLZXCVBNM")
    
    init(masterWord: String) {
        masterCode = Code(kind: .master(isHidden: false), word: masterWord)
        guessCode = Code(kind: .guess, word: String(repeating: Code.empty, count: masterWord.count))
    }
    
    mutating func setGuess(to character: Character, at index: Int) {
        var characters = Array(guessCode.word)
        characters[index] = character
        guessCode.word = String(characters)
    }
    
    mutating func submitWord() {
        attempts.append(Code(kind: .attempt, word: guessCode.word))
    }
}
