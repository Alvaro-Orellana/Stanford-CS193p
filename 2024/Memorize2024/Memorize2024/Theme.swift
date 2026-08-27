//
//  Theme.swift
//  Memorize2024
//
//  Created by Alvaro Orellana on 19-05-24.
//

import SwiftUI // No deberia importar algo de vista si este es parte del modelo

struct Theme: Identifiable, Hashable {
    var id: String { name }
    let name: String
    let emoji: Set<String>
    let numberOfPairs: Int?
    let color: Color
    
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
