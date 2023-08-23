//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Max Ellisen on 22.08.2023.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var gameViewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Text("🏆 " + String(gameViewModel.score)).font(.largeTitle).padding(.bottom)
            if gameViewModel.gameEnded {
                Text("Congratulations!").font(.largeTitle)
                Button(action: {
                    gameViewModel.startNewGame(themes: EmojiMemoryGame.predefinedSetOfGameThemes)
                }, label:
                        {
                    VStack {
                        Image(systemName: "arrow.clockwise.circle").imageScale(.large).font(.largeTitle)
                        Text("New Game")
                    }.padding(.top)
                }
                )
            }
            ScrollView {
                cards
                    .animation(.default, value: gameViewModel.cards)
            }
            Spacer()
            if !gameViewModel.gameEnded {
                Button(action: {
                    gameViewModel.startNewGame(themes: EmojiMemoryGame.predefinedSetOfGameThemes)
                }, label:
                        {
                    VStack {
                        Image(systemName: "arrow.clockwise.circle").imageScale(.large).font(.largeTitle)
                        Text("Reset Game")
                    }.padding(.top)
                }
                )
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
    
    func getColor() -> Color {
        switch card.bgColor {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        default: return .black
        }
    }
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill((card.isMatched ? .mint : .white))
                base.strokeBorder(lineWidth: 2)
                Text(card.content).font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(1, contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1)
                .foregroundColor(getColor())
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}
