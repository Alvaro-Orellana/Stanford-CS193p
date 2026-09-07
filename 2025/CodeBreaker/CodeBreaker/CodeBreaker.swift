//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 31-08-26.
//

typealias Peg = String

struct CodeBreaker {
    
    enum Match {
        case exact
        case inexact
        case noMatch
    }
    private(set) var pegChoices: [Peg]
    private(set) var masterCode: Code
    private(set) var guess: Code
    private(set) var attempts: [Code]
    
    init(pegChoices: [Peg], pegsNumber: Int) {
        let masterCodePegs = Array(pegChoices.shuffled().prefix(pegsNumber))
        let guessPegs = Array(repeating: Code.clear, count: masterCodePegs.count)
        
        self.pegChoices = pegChoices
        self.masterCode = Code(kind: .master, pegs: masterCodePegs)
        self.guess = Code(kind: .guess, pegs: guessPegs)
        self.attempts = []
    }
    
    /// Calculates exact matches first, then calculates inexact matches from the remaining pegs and returns both together.
    func matches(for attempt: Code) -> [Match] {
        let exactIndices = masterCode.pegs.indices.filter { masterCode.pegs[$0] == attempt.pegs[$0] }
        let nonExactIndices = masterCode.pegs.indices.filter { !exactIndices.contains($0) }
        
        let nonExactMasterPegs = nonExactIndices.map { masterCode.pegs[$0] }
        let nonExactAttemptPegs = nonExactIndices.map { attempt.pegs[$0] }
        let inexactMatchesCount = nonExactMasterPegs.count(where: { nonExactAttemptPegs.contains($0) })
        
        let exactMatches = Array(repeating: Match.exact, count: exactIndices.count)
        let inexactMatches = Array(repeating: Match.inexact, count: inexactMatchesCount)
        
        return exactMatches + inexactMatches
    }
    
    var hasAnySelectedPeg: Bool {
        guess.pegs.contains { $0 != Code.clear }
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
        
        attempts.append(Code(kind: .attempt, pegs: guess.pegs))
        guess.clear()
    }
    
    mutating func resetGame() {
        let randomTheme = CodeBreakerView.themes.keys.randomElement()!
        pegChoices = CodeBreakerView.themes[randomTheme]!
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
//    static let clear = Color.clear
    static let clear = ""
    let kind: Kind
    var pegs: [Peg]
    
    mutating func clear() {
        for index in pegs.indices {
            pegs[index] = Code.clear
        }
    }
}
