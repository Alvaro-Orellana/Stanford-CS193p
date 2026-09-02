//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 31-08-26.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    
    enum Match {
        case exact
        case inexact
        case noMatch
    }
    
    let pegChoices: [Peg]
    private(set) var masterCode: Code
    private(set) var guess: Code
    private(set) var attempts: [Code]
    
    init(pegChoices: [Peg] = [.blue, .yellow, .red, .green, .orange, .purple], pegsNumber: Int = 4) {
        self.pegChoices = pegChoices
        
        let masterCodePegs = Array(pegChoices.shuffled().prefix(pegsNumber))
        let guessPegs = Array(repeating: Code.clear, count: masterCodePegs.count)
        
        self.masterCode = Code(kind: .master, pegs: masterCodePegs)
        self.guess = Code(kind: .guess, pegs: guessPegs)
        self.attempts = []
    }
    
    func matches(for attemptCode: Code) -> [Match] {
        let exactMatches = zip(masterCode.pegs, attemptCode.pegs).filter(==).map { _ in Match.exact }
        let remainingMasterPegs = masterCode.pegs.suffix(from: exactMatches.count)
        let remainingAttemptPegs = attemptCode.pegs.suffix(from: exactMatches.count)
       
        var inexactMatches: [Match] = []
        for peg in remainingMasterPegs {
            if remainingAttemptPegs.contains(where: { $0 == peg }) {
                inexactMatches.append(.inexact)
            }
        }
        
        return exactMatches + inexactMatches
    }
    
    var hasAnySelectedPeg: Bool {
        guess.pegs.contains { $0 != Code.clear }
    }
    
    mutating func tappedGuessPeg(at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        
        let pegChoicesIndex = pegChoices.firstIndex(of: guess.pegs[index]) ?? 0
        let nextIndex = (pegChoicesIndex + 1) % pegChoices.count
        guess.pegs[index] = pegChoices[nextIndex]
    }
    
    mutating func submitAttempt() {
        let isNewGuess = !attempts.contains { $0.pegs == guess.pegs }
        guard hasAnySelectedPeg, isNewGuess else { return }
        
        attempts.append(Code(kind: .attempt, pegs: guess.pegs))
        guess.clear()
    }
    
    mutating func resetGame() {
        let newMasterCodePegs = Array(pegChoices.shuffled().prefix(Int.random(in: 3...6)))
        let newGuessPegs = Array(repeating: Code.clear, count: newMasterCodePegs.count)
        
        masterCode.pegs = newMasterCodePegs
        guess.pegs = newGuessPegs
        attempts = []
    }
}

struct Code {
    
    enum Kind {
        case master
        case guess
        case attempt
    }
    static let clear = Color.gray.opacity(0.1)
    let kind: Kind
    var pegs: [Peg]
    
    mutating func clear() {
        for index in pegs.indices {
            pegs[index] = Code.clear
        }
    }
}
