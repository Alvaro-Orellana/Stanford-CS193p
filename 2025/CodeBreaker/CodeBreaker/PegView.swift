//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI



private struct PegView: View {
    private let peg: Peg
    private let pegColor: Color?
    
    init(_ peg: Peg) {
        self.peg = peg
        pegColor = Color(named: peg)
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(pegColor ?? .clear)
            .strokeBorder(lineWidth: peg == Code.missingPeg ? 1 : 0)
            .contentShape(Circle())
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                let contentIsColor = pegColor != nil
                Text(contentIsColor ? "" : peg)
                    .font(.system(size: 120))
                    .minimumScaleFactor(9/120)
            }
    }
}

#Preview {
    CodeBreakerView()
}
