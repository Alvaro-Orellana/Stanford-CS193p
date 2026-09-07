//
//  Color+extension.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 07-09-26.
//

import SwiftUI

extension Color {
    init?(named name: String) {
        switch name.lowercased() {
            case "red": self = .red
            case "blue": self = .blue
            case "green": self = .green
            case "yellow": self = .yellow
            case "orange": self = .orange
            case "purple": self = .purple
            case "pink": self = .pink
            case "gray", "grey": self = .gray
            case "black": self = .black
            case "white": self = .white
            case "brown": self = .brown
            case "cyan": self = .cyan
            default: return nil
        }
    }
    
    var name: String? {
        switch self {
            case .red: "red"
            case .blue: "blue"
            case .green: "green"
            case .yellow: "yellow"
            case .orange: "orange"
            case .purple: "purple"
            case .pink: "pink"
            case .gray: "gray"
            case .black: "black"
            case .white: "white"
            case .brown: "brown"
            case .cyan: "cyan"
            default: nil
        }
    }
}
