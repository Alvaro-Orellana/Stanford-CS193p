//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by Alvaro Orellana on 15-09-26.
//

import SwiftUI

struct PegChooser: View {
    let choices: [Peg]
    let pegTapped: ((Peg) -> Void)?
    
    var body: some View {
        HStack {
            ForEach(choices, id: \.self) { peg in
                PegView(peg: peg).onTapGesture { pegTapped?(peg) }
            }
        }
    }
}

#Preview {
    PegChooser(choices: ["red", "yellow", "blue"], pegTapped: nil)
}
