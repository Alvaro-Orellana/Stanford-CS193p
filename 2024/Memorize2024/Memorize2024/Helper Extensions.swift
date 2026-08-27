//
//  Helper Extensions.swift
//  Memorize2024
//
//  Created by Alvaro Orellana on 25-06-24.
//

import Foundation

extension Collection {
    var onlyOne: Self.Element? {
        count == 1 ? first : nil
    }
}


extension Collection where Element: Identifiable {
    func firstIndex(with id: Element.ID) -> Self.Index? {
        firstIndex(where: { $0.id == id })
    }
    
    func first(with id: Element.ID) -> Self.Element? {
        first(where: { $0.id == id })
    }
}

extension Sequence where Element: Numeric {
    func sum() -> Self.Element {
        reduce(0, +)
    }
    
    func product() -> Self.Element {
        reduce(1, *)
    }
}
