//
//  MatchMarkers.swift
//  
//
//  Created by Alvaro Orellana on 30-08-26.
//


import SwiftUI

struct MatchMarkers: View {
    let markers: [Match]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                matchMarker(pegNumber: 0)
                matchMarker(pegNumber: 1)
                matchMarker(pegNumber: 2)

            }
            HStack {
//                ForEach((markers.count / 2)..<markers.count, id: \.self) { index in
//                    matchMarker(pegNumber: index)
//                }
                matchMarker(pegNumber: 3)
                matchMarker(pegNumber: 4)
                matchMarker(pegNumber: 5)
            }
        }
    }
    
    @ViewBuilder
    func matchMarker(pegNumber: Int) -> some View {
        let exactCount = markers.count(where: { $0 == .exact})
        let foundCount = markers.count(where: { $0 != .noMatch})
        
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
    let matches: [Match]
    
    var body: some View {
        HStack {
            ForEach(0..<matches.count, id: \.self, content: { _ in Circle() })
            MatchMarkers(markers: matches)
            Spacer()
        }
        .frame(height: pegSize)
        .padding(5)
    }
    
}

