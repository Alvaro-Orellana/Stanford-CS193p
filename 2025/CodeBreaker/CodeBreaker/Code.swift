//
//  Code.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 12-09-26.
//


struct Code {
    var pegs: [Peg]
    var kind: Kind
    
    static let missingPeg = ""

    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt([Match])
    }
    
    var isHidden: Bool {
        switch kind {
        case.master(let isHidden): isHidden
        default: false
        }
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches): matches
        default: nil
        }
    }
    /// Calculates exact matches and inexact matches and returns both together.
    /// This works because it is asumed that otherCode is the master code and contains no duplicates
    func match(against otherCode: Code) -> [Match] {
        let pairs = zip(self.pegs, otherCode.pegs)
        let exactCount = pairs.count(where: ==)
        let inexactCount = pairs.count { peg, otherPeg in peg != otherPeg && self.pegs.contains(otherPeg) }
        let exactMatches = Array(repeating: Match.exact, count: exactCount)
        let inexactMatches = Array(repeating: Match.inexact, count: inexactCount)
        return exactMatches + inexactMatches
    }
    
    mutating func clear() {
        for index in pegs.indices {
            pegs[index] = Code.missingPeg
        }
    }
}
