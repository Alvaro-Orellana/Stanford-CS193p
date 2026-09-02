//
//  MatchMarkers.swift
//  
//
//  Created by Alvaro Orellana on 30-08-26.
//


import SwiftUI

struct MatchMarkers: View {
    let matches: [CodeBreaker.Match]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                matchMarker(pegNumber: 0)
                matchMarker(pegNumber: 1)
                matchMarker(pegNumber: 2)
            }
            HStack {
                matchMarker(pegNumber: 3)
                matchMarker(pegNumber: 4)
                matchMarker(pegNumber: 5)
            }
        }
    }
    
    @ViewBuilder
    private func matchMarker(pegNumber: Int) -> some View {
        let exactCount = matches.count(where: { $0 == .exact})
        let foundCount = matches.count(where: { $0 != .noMatch})
        Circle()
            .fill(exactCount > pegNumber ? Color.primary : Color.clear)
            .strokeBorder(foundCount > pegNumber ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}


#Preview {
    MatchMarkersPreview(matches: [.inexact,])
    MatchMarkersPreview(matches: [.exact, .inexact, .noMatch,])
    MatchMarkersPreview(matches: [.exact, .inexact, .inexact])
    MatchMarkersPreview(matches: [.exact, .inexact, .inexact, .inexact ])
    MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact, .inexact])
    MatchMarkersPreview(matches: [.exact, .exact, .inexact, .inexact, .inexact, .noMatch])
}

private struct MatchMarkersPreview: View {
    let pegSize: CGFloat = 47
    let matches: [CodeBreaker.Match]
    
    var body: some View {
        HStack {
            dummyPegs
            MatchMarkers(matches: matches)
            Spacer()
        }
        .frame(height: pegSize)
        .padding(5)
    }
    
    var dummyPegs: some View {
        ForEach(matches.indices, id: \.self) { _ in
            Circle()
        }
    }
}

