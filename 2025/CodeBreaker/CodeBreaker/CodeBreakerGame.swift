//
//  CodeBreakerGame.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 31-08-26.
//

typealias Peg = String

enum Match {
    case exact
    case inexact
    case noMatch
}

struct CodeBreakerGame {
    private(set) var pegChoices: [Peg]
    private(set) var masterCode: Code
    private(set) var guess: Code
    private(set) var attempts: [Code]
    
    init(pegChoices: [Peg], pegsNumber: Int) {
        self.pegChoices = pegChoices
        
        let masterCodePegs = Array(pegChoices.shuffled().prefix(pegsNumber))
        let guessPegs = Array(repeating: Code.missingPeg, count: masterCodePegs.count)
        
        self.masterCode = Code(pegs: masterCodePegs, kind: .master(isHidden: true))
        self.guess = Code(pegs: guessPegs, kind: .guess)
        self.attempts = []
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    var hasAnySelectedPeg: Bool {
        guess.pegs.contains { guessPeg in guessPeg != Code.missingPeg }
    }
    
    var isGuessNew: Bool {
        !attempts.contains { attempt in attempt.pegs == guess.pegs }
    }
    
    mutating func setGuessPeg(to peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        guess.pegs[index] = peg
    }
    
    mutating func submitGuess() {
        guard isGuessNew, hasAnySelectedPeg else { return }
        
        let matches = guess.match(against: masterCode)
        attempts.append(Code(pegs: guess.pegs, kind: .attempt(matches)))
        
        guess.clear()
        
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
}


