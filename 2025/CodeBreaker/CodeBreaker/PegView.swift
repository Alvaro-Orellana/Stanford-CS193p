//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 27-08-26.
//

import SwiftUI



struct PegView: View {
    let peg: Peg
    
    var body: some View {
        let pegColor = Color(named: peg)
        
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
    PegView(peg: "red")
}
