//
//  Player.swift
//  Schnapsen
//
//  Created by Sean Delargy on 8/10/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

class Player {
    private(set) var cardsWon: [Card] = [Card]() // will use when implementing more advamced bot
    private(set) var cardsLost: [Card] = [Card]() // will use when implementing more advamced bot
    private(set) var currentHand: [Card] = [Card]()
    private(set) var playerPoints = 0
    private(set) var opponentPoints = 0
    
    
    
    // What does a player need to play the game
    //      needs cards played
    //      need both player points
    //      need current hand obviously
    
    
    // TODO: How to enforce class used correctly
    // could add a counter of some sort to ensure that points are getting updated
    
    

    
    // return card played
    func makeMove() -> Card {
        return currentHand.remove(at: 0)
    }
    
    func makeMove(with card: Card) -> Card {
        return currentHand.remove(at: 0)
    }
    
    func addCardsToHand(with cards: [Card]) {
        currentHand.append(contentsOf: cards)
    }
    
    func addCardToHand(with card: Card) {
        currentHand.append(card)
    }
    
    func getHand() -> [Card] {
        return currentHand
    }
    
    
    // TODO: decouple playerpoints from cards won
    // calculate points from this
    func addToCardsWon(_ cards: [Card]) {
        for card in cards {
            playerPoints += card.val.rawValue
            cardsWon.append(card)
        }
    }
    
    func addToCardsLost(_ cards: [Card]) {
        for card in cards {
            opponentPoints += card.val.rawValue
            cardsLost.append(card)
        }
    }
    
    // recalculates this player's match points
    func updatePlayerPoints() -> Int {
        var myPoints = 0
        for card in cardsWon {
            myPoints += card.val.rawValue
        }
        playerPoints = myPoints
        return playerPoints
    }
    
    func getPlayerPoints() -> Int {
        return playerPoints
    }
    
}
