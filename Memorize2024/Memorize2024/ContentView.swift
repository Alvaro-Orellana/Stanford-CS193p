//
//  ContentView.swift
//  Memorize2024
//
//  Created by Alvaro Orellana on 27-04-24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: EmojiMemoryGame
    
    init(theme: Theme) {
        _viewModel = StateObject(wrappedValue: EmojiMemoryGame(theme: theme))
    }
    
    var body: some View {
        VStack {
            ScrollView { cards }
                .padding(5)
            buttons
        }
        .navigationTitle(viewModel.title)
    }
    
    private var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70), spacing: 0)], spacing: 0) {
            ForEach(viewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(5)
                    .animation(.easeIn, value: viewModel.cards)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .foregroundStyle(viewModel.color)
    }
    
    private var buttons: some View {
        HStack(spacing: 50) {
            Button("Shuffle") {
                viewModel.shuffle()
            }
            .buttonStyle(.borderedProminent)
                
            Text("Score: \(viewModel.score)")
            
            Button("New Game") {
                viewModel.newGame()
            }
            .buttonStyle(.bordered)
        }
        .padding(20)
    }
}



struct CardView: View {
    
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 20)

            base.fill(.white)
            base.stroke(lineWidth: 2)
            Text(card.content)
                .font(.system(size: 100))
                .minimumScaleFactor(0.01)
                .aspectRatio(1, contentMode: .fit)
            
            base.opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isMatched ? 0 : 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView(theme: EmojiMemoryGame.themes[0])
        }
    }
}
