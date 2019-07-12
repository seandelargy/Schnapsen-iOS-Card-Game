//
//  Deck.swift
//  Schnapsen
//
//  Created by Sean Delargy on 8/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

struct Deck {
    private var deck: [Card] = [Card]()
    var initialDeal = false
    var numCards: Int {
        get {
            return deck.count
        }
    }
    
    init() {
        for suit in Card.Suit.allCases {
            for val in Card.Value.allCases {
                deck.append(Card(suit: suit, val: val))
            }
        }
        deck.shuffle()
    }
    
    mutating func dealCard() -> Card {
        return deck.remove(at: 0)
    }
    
    mutating func removeCard(_ removedCard: Card) -> Bool {
        for i in 0...deck.count - 1 {
            if deck[i] == removedCard {
                deck.remove(at: i)
                return true
            }
        }
        return false
    }
    
    // deals traditional schnapsen way, 3, 3, trump card, 2, 2
    mutating func dealCardsStartGame() -> ([Card], [Card], Card)  {
        if initialDeal {
            assert(false) // TODO: change to exception
            //throw new RuntimeException("A custom message here")
        }
        var playerOneHand = [Card]()
        var playerTwoHand = [Card]()
        
        for _ in 1...3 {
            playerOneHand.append(deck.remove(at: 0))
        }
        for _ in 1...3 {
            playerTwoHand.append(deck.remove(at: 0))
        }
        let trumpCard = deck.remove(at: 0)
        for _ in 1...2 {
            playerOneHand.append(deck.remove(at: 0))
        }
        for _ in 1...2 {
            playerTwoHand.append(deck.remove(at: 0))
        }
        initialDeal = true
        
        return (playerOneHand, playerTwoHand, trumpCard)
    }
    
}
