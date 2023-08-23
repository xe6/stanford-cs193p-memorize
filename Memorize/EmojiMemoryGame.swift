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
    private static let defaultGameTheme = GameTheme(emojis: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙", "🙀", "👹", "😱", "☠️", "🍭"], color: "red")
    
    private static func createMemoryGame(gameThemes: [GameTheme]) -> MemoryGame<String> {
        let gameTheme = gameThemes.randomElement() ?? defaultGameTheme
        return MemoryGame(numberOfPairsOfCards: 10) { pairIndex in
            if gameTheme.emojis.indices.contains(pairIndex) {
                return (gameTheme.emojis[pairIndex], gameTheme.color)
            } else {
                return ("⁉️", gameTheme.color)
            }
        }
    }
    
    static let predefinedSetOfGameThemes = [
        defaultGameTheme,
        GameTheme(emojis: ["🥶", "❄️", "☃️", "🧣", "🏂", "🎅", "🌨️", "🧤", "🎿", "⛸️", "🤧", "🛷"], color: "blue"),
        GameTheme(emojis: ["🍒", "🍓", "🍇", "🥑", "🍎", "🍉", "🍑", "🍋", "🥝", "🫐", "🍌", "🍐"], color: "green")
    ]
    
    @Published private var gameModel = createMemoryGame(gameThemes: predefinedSetOfGameThemes)
    
    var cards: Array<MemoryGame<String>.Card> {
        return gameModel.cards
    }
    
    var score: Int {
        return gameModel.score
    }
    
    var gameEnded: Bool {
        return gameModel.gameEnded
    }
    
    struct GameTheme {
        let emojis: [String]
        let color: String
    }
    
    // MARK: - Intents
    func startNewGame(themes gameThemes: [GameTheme]) {
        gameModel = EmojiMemoryGame.createMemoryGame(gameThemes: gameThemes)
        gameModel.shuffle()
    }
    
    // Intent function
    // _ as a first arg word allows to bypass necessity to pass card: card as an argument
    func choose(_ card: MemoryGame<String>.Card) {
        gameModel.choose(card)
    }
}
