//
//  Schapsen.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

class Schnapsen {
    
    private var deck: Deck
    private(set) var trumpCard: Card = Card(suit: .heart, val: .ace)  // initialized to arbitrary card for set -> lazy initialization?
    public var playerOne: Player
    public var playerTwo: Player
    private(set) var playerOnePoints = 0
    private(set) var playerTwoPoints = 0
    private(set) var gameOver = false
    private(set) var playerOneTurn = true
    private(set) var playerOneLeadHand = true
    private(set) var stockClosed = false
    
    // plays hands between players automatically when both players have played their move
    private(set) var currentMoves: (playerOneCard: Card?, playerTwoCard: Card?) = (nil, nil) {
        didSet {
            print("move just set")
            
            if currentMoves.0 != nil && currentMoves.1 != nil {
                
                print("player one move: \(currentMoves.playerOneCard!.toString())")
                print("player two move: \(currentMoves.playerTwoCard!.toString())")
                
                playCards(currentMoves.0!, currentMoves.1!)
                previousRound.0 = currentMoves.0
                previousRound.1 = currentMoves.1
                currentMoves = (nil, nil)
            }
        }
    }
    
    private(set) var previousRound: (playerOneCard: Card?, playerTwoCard: Card?) = (nil, nil)
    
    
    // private playerOne Move: Optional type
    // private playerTwo move: Optional type
    // Or I could use a tuple for both -- I think this makes more sense
            // observer that says when both nut None play cards -- this will be private
    // this makes sense because playCards doesn;t care the order the cards were played
    // only needs to make a decision of who the winner was and update who on lead
    
    // the viewcontroller will also have to enforce the game is being played correctly. It must abide by the contract of Schnapsen.
    
    // I think it makes sense to store cards then make move based on that
    // as opposed to making the view controller do that part
    // there needs to be asserts that the right person is making the right move
    
    
    // player <- abstract class?
    // get move
        // stock open
        // stock closed
    // hand
    // get card
    
    
    
    // with this playCards(card1, card2) method there is no notion of on lead so that game
    // can not enforce that -- this will turn into internal private method
    // Player makes move seperately and independently from the view
    // player passes that into make player one move
        // game checks to make sure it was that players turn
        // if it wasn't throw an exception
        // otherwise save it in an array that gets reset with every move
    //
    
    convenience init() {
        self.init(Player(), Player())
    }
    
    init(_ playerOne: Player, _ playerTwo: Player) {
        self.playerOne = playerOne
        self.playerTwo = playerTwo
        
        // set playerOne/playerTwo numbers
        deck = Deck()
        dealCards(playerOne, playerTwo, deck)
    }
    
    private func dealCards(_ playerOne: Player, _ playerTwo: Player, _ deck: Deck) {
        let deal = self.deck.dealCardsStartGame()
        playerOne.addCardsToHand(with: deal.0)
        playerTwo.addCardsToHand(with: deal.1)
        trumpCard = deal.2
    }
    
    // These functions are very similar and could be combined into one
    // but I think it makes for a better user experience and makes more
    // logical sense for the user to have two seperate functions
    // if I feel there is to much duplication I can call an internal private function
    // that they both call.
    
    // Note: make sure don't switch player one move turn after
    func makePlayerOneMove(_ move: Card) {
        // ensure that it was called on its turn
        // set playerOneMove
        assert(playerOneTurn)
        currentMoves.playerOneCard = move
        // this is wrong - don't switch off
        playerOneTurn = !playerOneTurn
    }
    
    func makePlayerTwoMove(_ move: Card) {
        // ensure that it was called on its turn
        // set playerTwoMove
        assert(!playerOneTurn)
        currentMoves.playerTwoCard = move
        playerOneTurn = !playerOneTurn
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
    
    // plays cards and updates hands and game points
    func playCards(_ playerOneCard: Card, _ playerTwoCard: Card) {
        
        // check that followed suit if stock closed
        if stockClosed {
            // assert something
        }
        
        let winner = getTrickWinner(playerOneCard, playerTwoCard)
        print("-1 = player one win, 1 = player two win: \(winner)")
      
        if winner < 0 { // player one win
            playerOnePoints += playerOneCard.val.rawValue + playerTwoCard.val.rawValue
            
            playerOne.addToCardsWon([playerOneCard, playerTwoCard])
            playerTwo.addToCardsLost([playerOneCard, playerTwoCard])
            playerOneTurn = true
            playerOneLeadHand = true
        } else { // player two win
            playerTwoPoints += playerOneCard.val.rawValue + playerTwoCard.val.rawValue
            
            playerTwo.addToCardsWon([playerOneCard, playerTwoCard])
            playerOne.addToCardsLost([playerOneCard, playerTwoCard])

            playerOneTurn = false
            playerOneLeadHand = false
        }
        drawCards()

        print(playerOne.currentHand)
        print(playerTwo.currentHand)
        
        // check if game is over
        if playerOnePoints >= 66 || playerTwoPoints >= 66 {
            gameOver = true
        }
 
    }
 
    
    // SideEffect: adds cards from deck to player hands if stock still open
    private func drawCards() {
        // stock is still open
        if deck.numCards > 0 {
            let card1 = deck.dealCard()
            var card2: Card?
            if deck.numCards > 0 {
                card2 = deck.dealCard()
            } else {
                card2 = trumpCard
            }
            if playerOneTurn { // if player one turn, player one won last hand
                playerOne.addCardToHand(with: card1)
                playerTwo.addCardToHand(with: card2!)
            } else {
                playerTwo.addCardToHand(with: card1)
                playerOne.addCardToHand(with: card2!)
            }
        }
 
    }
    
    /*
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
 
    */
    
    
    // Returns negative integer if player one wins, positive number if player two wins
    func getTrickWinner(_ playerOneCard: Card, _ playerTwoCard: Card) -> Int {
        if (playerOneCard.suit == playerTwoCard.suit) {
            return playerTwoCard.val.rawValue - playerOneCard.val.rawValue // negative val for player one win, positve for player two
        } else if (playerOneCard.suit == trumpCard.suit) {
            return -1
        } else if (playerTwoCard.suit == trumpCard.suit) {
            return 1
        } else if (playerOneLeadHand) {     // person who was on lead wins because follow did not match suit
            print("playerOneTurn(T/F): \(playerOneLeadHand)")
            return -1
        } else {
            print("playerOneTurn(T/F): \(playerOneLeadHand)")
            return 1
        }
    }
}
