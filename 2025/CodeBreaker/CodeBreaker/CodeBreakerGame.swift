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
        let masterCodePegs = Array(pegChoices.shuffled().prefix(pegsNumber))
        let guessPegs = Array(repeating: Code.missingPeg, count: masterCodePegs.count)
        
        self.pegChoices = pegChoices
        self.masterCode = Code(pegs: masterCodePegs, kind: .master)
        self.guess = Code(pegs: guessPegs, kind: .guess)
        self.attempts = []
    }
    
    var hasAnySelectedPeg: Bool {
        guess.pegs.contains { $0 != Code.missingPeg }
    }
    
    var isGuessNew: Bool {
        !attempts.contains { $0.pegs == guess.pegs }
    }

    mutating func tappedGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        let pegChoicesIndex = pegChoices.firstIndex(of: guess.pegs[index]) ?? 0
        let nextIndex = (pegChoicesIndex + 1) % pegChoices.count
        guess.pegs[index] = pegChoices[nextIndex]
    }
    
    mutating func submitGuess() {
        guard isGuessNew, hasAnySelectedPeg else { return }
        
        let matches = guess.match(against: masterCode)
        attempts.append(Code(pegs: guess.pegs, kind: .attempt(matches)))
    }
}


