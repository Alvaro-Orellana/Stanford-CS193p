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

struct MatchMarkers: View {
    let markers: [Match]
    
    var body: some View {
        VStack {
            HStack {
                matchMarker(pegNumber: 0)
                matchMarker(pegNumber: 1)
            }
            HStack {
                matchMarker(pegNumber: 2)
                matchMarker(pegNumber: 3)
            }
        }
    }
    
    @ViewBuilder
    func matchMarker(pegNumber: Int) -> some View {
        let exactCount = markers.count(where: { $0 == .exact})
        let foundCount = markers.count(where: { $0 != .noMatch})
        
        Circle()
            .fill(exactCount > pegNumber ? Color.primary : Color.clear)
            .strokeBorder(foundCount > pegNumber ? Color.pink : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
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
