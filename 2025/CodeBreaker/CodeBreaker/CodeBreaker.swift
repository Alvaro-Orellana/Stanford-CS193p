//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 31-08-26.
//

import Foundation
import SwiftUI

struct CodeBreaker {
    
    enum Match {
        case exact
        case inexact
        case noMatch
    }
    
    var matches: [Match]
    let masterCode: [Color] = [.red, .green, .blue]
    
    func choose(color: Color) {
        
    }
}
