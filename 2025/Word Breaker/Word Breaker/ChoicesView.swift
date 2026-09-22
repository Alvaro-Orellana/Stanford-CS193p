//
//  ChoicesView.swift
//  
//
//  Created by Alvaro Orellana on 22-09-26.
//


private struct ChoicesView: View {
    let choices: [Character]
    let choiceTapped: (Character) -> Void
    private let columns = [
        GridItem(.adaptive(minimum: 30))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(choices.indices, id: \.self) { index in
                Circle()
                    .stroke()
                    .overlay {
                        Text(String(choices[index]))
                    }
                    .onTapGesture {
                        choiceTapped(choices[index])
                    }
            }
        }.aspectRatio(10/3, contentMode: .fit)
    }
}