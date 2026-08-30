//
//  ContentView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            pegs(for: [.blue, .red, .yellow, .orange])
            pegs(for: [.blue, .red, .yellow, .pink])
            pegs(for: [.blue, .red, .yellow, .primary])
        }
        .padding()
    }
    
    func pegs(for colors: [Color]) -> some View {
        HStack {
            ForEach(colors.indices, id: \.self) { index in
                Circle().foregroundStyle(colors[index])
            }
            MatchMarkers(markers: [.exact, .inexact, .inexact])
        }
    }
}



enum Match {
    case exact
    case inexact
    case noMatch
}

#Preview {
    ContentView()
}
