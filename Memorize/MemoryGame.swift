//
//  MemoryGame.swift
//  Memorize
//
//  Model
//
//  Created by Max Ellisen on 22.08.2023.
//

import Foundation

struct MemoryGame<CardContent> {
    // What does this thing do?
    // What data does it have associated with it?
    private(set) var cards: Array<Card> // private(set) only disallows mutation, but allows to get the value publicly
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        // Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content))
            cards.append(Card(content: content))
        }
    }
    
    func choose(_ card: Card) {
        
    }
    
    mutating func shuffle() {
        cards.shuffle()
        print(cards)
    }
    
    // Nested struct will be available as MemoryGame.Card
    struct Card {
        var isFaceUp = true
        var isMatched = false
        let content: CardContent
    }
}
