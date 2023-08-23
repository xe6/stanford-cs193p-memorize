//
//  MemoryGame.swift
//  Memorize
//
//  Model
//
//  Created by Max Ellisen on 22.08.2023.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // What does this thing do?
    // What data does it have associated with it?
    private(set) var cards: Array<Card> // private(set) only disallows mutation, but allows to get the value publicly
    private(set) var score: Int = 0
    private(set) var gameEnded = false
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> (CardContent, String)) {
        cards = []
        // Add numberOfPairsOfCards x 2 cards
        for pairIndex in 0..<max(2, numberOfPairsOfCards) {
            let (content, color) = cardContentFactory(pairIndex)
            cards.append(Card(content: content, bgColor: color, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, bgColor: color, id: "\(pairIndex+1)b"))
        }
        cards.shuffle()
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { index in cards[index].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
    }
    
    mutating func choose(_ card: Card) {
        
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) {
            var substracted = false
            // Substract score if card has already been seen and not matched OR opened second time as a first card to be matched
            if cards[chosenIndex].hasBeenSelectedAtLeastOnce &&
                !cards[chosenIndex].isFaceUp &&
                !cards[chosenIndex].isMatched { score -= 1; substracted = true }
            
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        // if substraction occurred earlier - compensate it since the match was successful
                        score += substracted ? 3 : 2
                    } else {
                        if cards[potentialMatchIndex].hasBeenSelectedAtLeastOnce &&
                            !cards[potentialMatchIndex].isFaceUp &&
                            !cards[potentialMatchIndex].isMatched { score -= 1 }
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
                cards[chosenIndex].hasBeenSelectedAtLeastOnce = true
                
                if cards.indices.filter({ index in !cards[index].isMatched }).isEmpty {
                    // Game has ended
                    indexOfTheOneAndOnlyFaceUpCard = nil
                    cards[chosenIndex].isFaceUp = false
                    gameEnded = true
                }
            }
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    // Nested struct will be available as MemoryGame.Card
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" : "")"
        }
        
        static func == (lhs: Card, rhs: Card) -> Bool {
            return lhs.isFaceUp == rhs.isFaceUp &&
            lhs.isMatched == rhs.isMatched &&
            lhs.content == rhs.content
        }
        
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var bgColor: String
        var hasBeenSelectedAtLeastOnce = false
        
        let id: String
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
