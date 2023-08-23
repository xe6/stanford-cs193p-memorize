//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Max Ellisen on 22.08.2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameViewModel: EmojiMemoryGame
    
    //    let winterEmojis: [String] = ["🥶", "🥶", "❄️", "❄️", "☃️", "☃️", "🧣", "🧣", "🏂", "🏂", "🎅", "🎅", "🌨️", "🌨️", "🧤", "🧤", "🎿", "🎿", "⛸️", "⛸️", "🤧", "🤧", "🛷", "🛷"]
    //    let fruitsEmojis: [String] = ["🍒", "🍒", "🍓", "🍓", "🍇", "🍇", "🥑", "🥑", "🍎", "🍎", "🍉", "🍉", "🍑", "🍑", "🍋", "🍋", "🥝", "🥝", "🫐", "🫐", "🍌", "🍌", "🍐", "🍐"]
    
    @State var cardCount: Int = 24
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle).padding(.bottom)
            ScrollView {
                cards
                    .animation(.default, value: gameViewModel.cards)
            }
            Spacer()
            Button("Shuffle") {
                gameViewModel.shuffle()
            }
        }
        .padding()
    }
    
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)], spacing: 0) {
            ForEach(gameViewModel.cards) { card in
                CardView(card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        gameViewModel.choose(card)
                    }
            }
        }
        .foregroundColor(.red)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(gameViewModel: EmojiMemoryGame())
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content).font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}
