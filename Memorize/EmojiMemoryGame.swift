//
//  EmojiMemoryGame.swift
//  Memorize
//
//  ViewModel
//
//  Created by Max Ellisen on 22.08.2023.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    // Mark initializing shit used in other initializers as static & private to not pollute global namespace
    private static let halloweenEmojis = ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙", "🙀", "👹", "😱", "☠️", "🍭"]
    
    private static func createMemoryGame() -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: 16) { pairIndex in
            if halloweenEmojis.indices.contains(pairIndex) {
                return halloweenEmojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var gameModel = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return gameModel.cards
    }
    
    // MARK: - Intents
    
    func shuffle() {
        gameModel.shuffle()
    }
    
    // Intent function
    // _ as a first arg word allows to bypass necessity to pass card: card as an argument
    func choose(_ card: MemoryGame<String>.Card) {
        gameModel.choose(card)
    }
}
