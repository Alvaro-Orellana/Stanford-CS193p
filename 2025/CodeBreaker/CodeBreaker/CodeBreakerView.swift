//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI

struct CodeBreakerView: View {
    
    @State var model = CodeBreaker(matches: [.exact, .inexact, .inexact])

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
            MatchMarkers(matches: model.matches)
        }
    }
}

#Preview {
    CodeBreakerView()
}
