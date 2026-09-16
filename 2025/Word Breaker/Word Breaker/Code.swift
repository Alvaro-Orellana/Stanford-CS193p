//
//  Code.swift
//  Word Breaker
//
//  Created by Alvaro Orellana on 16-09-26.
//

import Foundation

struct Code {
    var kind: Kind
    var word: String = Code.empty
    
    static let empty = " "
    
    enum Kind: Equatable {
        case master(isHidden: Bool)
        case guess
        case attempt
    }
}
