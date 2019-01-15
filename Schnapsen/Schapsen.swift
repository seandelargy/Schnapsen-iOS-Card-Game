//
//  Schapsen.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

class Schnapsen {
    
    var deck: [Card] = [Card]()
    var playerOneCardsWon: [Card] = [Card]() // will use when implementing more advamced bot
    var playerTwoCardsWon: [Card] = [Card]() // will use when implementing more advamced bot
    var playerOneHand: [Card] = [Card]()
    var playerTwoHand: [Card] = [Card]()
    var trumpCard: Card = Card(suit: .heart, val: .ace) // initialized to arbitrary card -> figure out lazy initialization
    var playerOnePoints = 0
    var playerTwoPoints = 0
    var gameOver = false
    var playerOneOnLead = true
    
    init() {
        for suit in Card.Suit.allCases {
            for val in Card.Value.allCases {
                deck.append(Card(suit: suit, val: val))
            }
        }
        deck.shuffle()
        dealCards()
    }
    
    // this method unneccessary
    func drawCard() -> Card {
        return deck.remove(at: 0)
    }
    
    // deals traditional schnapsen way, 3, 3, trump card, 2, 2
    func dealCards() {
        for _ in 1...3 {
            playerOneHand.append(drawCard())
        }
        for _ in 1...3 {
            playerTwoHand.append(drawCard())
        }
        trumpCard = drawCard()
        for _ in 1...2 {
            playerOneHand.append(drawCard())
        }
        for _ in 1...2 {
            playerTwoHand.append(drawCard())
        }
    }
    
    // 3 move options:
    // declare marriage
    // close stock
    // play card
    
    func declareMarriage(_ marriageCard: Card) {
        // TODO: implement
    }
    
    func closeStock() {
        //TODO: implement this
    }
    
    
    func playCards(_ playerOneCard: Card, _ playerTwoCard: Card) {
    
        // TODO: remove cards from hand here, not in view
        
        let winner = getTrickWinner(playerOneCard, playerTwoCard)
      
        if winner < 0 {
            playerOnePoints += playerOneCard.val.rawValue + playerTwoCard.val.rawValue
            playerOneCardsWon += [playerOneCard, playerTwoCard]
            playerOneOnLead = true
        } else {
            playerTwoPoints += playerOneCard.val.rawValue + playerTwoCard.val.rawValue
            playerTwoCardsWon += [playerOneCard, playerTwoCard]
            playerOneOnLead = false
        }
        
        if deck.count > 0 {
            let card1 = drawCard()
            var card2: Card? = nil
            if deck.count > 0 {
                card2 = drawCard()
            } else {
                card2 = trumpCard
            }
            if winner < 0 {
                playerOneHand += [card1]
                playerTwoHand += [card2!]
            } else {
                playerTwoHand += [card1]
                playerOneHand += [card2!]
            }
        }
        
        if playerOnePoints >= 66 || playerTwoPoints >= 66 {
            gameOver = true
        }
    }
    
    // computer picks card to lead hand with
    func getComputerLeadMove() -> Card {
        return playerTwoHand.remove(at: 0)
    }
    
    // returns first card in hand that beats opponent's move, or first card if no card in hand beats opponent
    func getComputerMove(_ playerOneMove: Card) -> Card{
        for cardIndex in 0..<playerTwoHand.count {
            if getTrickWinner(playerOneMove, playerTwoHand[cardIndex]) > 1 {
                return playerTwoHand.remove(at: cardIndex)
            }
        }
        return playerTwoHand.remove(at: 0)
    }
    
    // returns negative number if player one wins, positive number if player two wins
    func getTrickWinner(_ playerOneCard: Card, _ playerTwoCard: Card) -> Int {
        if (playerOneCard.suit == playerTwoCard.suit) {
            return playerTwoCard.val.rawValue - playerOneCard.val.rawValue // negative val for player one win, positve for player two
        } else if (playerOneCard.suit == trumpCard.suit) {
            return -1
        } else if (playerTwoCard.suit == trumpCard.suit) {
            return 1
        } else if (playerOneOnLead) {
            return -1
        } else {
            return 1
        }
    }
}
