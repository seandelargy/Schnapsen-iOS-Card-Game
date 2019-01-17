//
//  Schapsen.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

class Schnapsen {
    
    private(set) var deck: [Card] = [Card]()
    private(set) var playerOneCardsWon: [Card] = [Card]() // will use when implementing more advamced bot
    private(set) var playerTwoCardsWon: [Card] = [Card]() // will use when implementing more advamced bot
    private(set) var playerOneHand: [Card] = [Card]()
    private(set) var playerTwoHand: [Card] = [Card]()
    private(set) var trumpCard: Card = Card(suit: .heart, val: .ace)  // initialized to arbitrary card -> lazy initialization?
    private(set) var playerOnePoints = 0
    private(set) var playerTwoPoints = 0
    private(set) var gameOver = false
    private(set) var playerOneOnLead = true
    
    init() {
        for suit in Card.Suit.allCases {
            for val in Card.Value.allCases {
                deck.append(Card(suit: suit, val: val))
            }
        }
        deck.shuffle()
        dealCards()
    }
    
    // deals traditional schnapsen way, 3, 3, trump card, 2, 2
    private func dealCards() {
        for _ in 1...3 {
            playerOneHand.append(deck.remove(at: 0))
        }
        for _ in 1...3 {
            playerTwoHand.append(deck.remove(at: 0))
        }
        trumpCard = deck.remove(at: 0)
        for _ in 1...2 {
            playerOneHand.append(deck.remove(at: 0))
        }
        for _ in 1...2 {
            playerTwoHand.append(deck.remove(at: 0))
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
    
    
    // SideEffect: remove playerOnceCard and playerTwoCard from their respective hands
    private func removeCards(_ playerOneCard: Card, _ playerTwoCard: Card) {
        var index = findIndexOfCard(playerOneHand, playerOneCard)
        print(index)
        playerOneHand.remove(at: index)
        index = findIndexOfCard(playerTwoHand, playerTwoCard)
        playerTwoHand.remove(at: index)
    }
    
    func findIndexOfCard(_ playerHand: [Card], _ card:Card) -> Int {
        for cardIndex in 0..<playerHand.count {
            if card == playerHand[cardIndex] {
                return cardIndex
            }
        }
        return -1;
    }
    
    // plays cards and updates hands and game points
    func playCards(_ playerOneCard: Card, _ playerTwoCard: Card) {
        removeCards(playerOneCard, playerTwoCard)
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
        drawCards(winner)

        // check if game is over
        if playerOnePoints >= 66 || playerTwoPoints >= 66 {
            gameOver = true
        }
    }
    
    // SideEffect: adds cards from deck to player hands if stock still open
    private func drawCards(_ winner: Int) {
        // stock is still open
        if deck.count > 0 {
            let card1 = deck.remove(at: 0)
            var card2: Card?
            if deck.count > 0 {
                card2 = deck.remove(at: 0)
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
    }
    
    
    // Return's computer move on lead
    func getComputerLeadMove() -> Card {
        return playerTwoHand[0]
    }
    
    // Returns computer's move
    func getComputerMove(_ playerOneMove: Card) -> Card{
        // returns first card in hand that beats opponent's move, or first card in hand if no card beats opponent
        for cardIndex in 0..<playerTwoHand.count {
            if getTrickWinner(playerOneMove, playerTwoHand[cardIndex]) > 1 {
                return playerTwoHand[cardIndex]
            }
        }
        return playerTwoHand[0]
    }
    
    // Returns negative integer if player one wins, positive number if player two wins
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
