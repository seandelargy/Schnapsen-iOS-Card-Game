//
//  ViewController.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //playGame()
        updateDisplay()
        moveCount = 0
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var playerOneScore: UILabel!
    
    @IBOutlet private weak var playerTwoScore: UILabel!

    @IBOutlet private weak var trumpCard: UILabel!
    
    @IBOutlet private weak var gameStatus: UILabel!
    
    @IBOutlet private weak var pastHand: UILabel!
    
    // used to keep track of when a move is completed and to update display
    private var moveCount = -1 {
        didSet {
            updateDisplay()
            // when turn changed to odd number a move was just played
            if moveCount % 2 == 0 && moveCount > 1 {
                displayLastMove(game.previousRound.playerOneCard!, game.previousRound.playerTwoCard!)
            }
            promptNextMove()
        }
    }

    private var game = Schnapsen(Player(), Player())
    
    private var computerMove: Card!
    
    // get one move from computer or wait until player move is made on screen
    private func promptNextMove() {

        if !game.gameOver {

            if !game.playerOneTurn {        // this can be on lead or not on lead
               
                // if computer on lead - use info, otherwise make move without
                if let playerCard = game.currentMoves.0 {
                    computerMove = game.playerTwo.makeMove(with: playerCard)
                } else {
                    computerMove = game.playerTwo.makeMove() // computer picks card to lead with
                }
                game.makePlayerTwoMove(computerMove)
                gameStatus.text = "Computer played \(computerMove!.toString()). Your turn"
                moveCount += 1
            } else {
                gameStatus.text = "You're on lead. Your turn."
                computerMove = nil
                // don't increase move count until move is actually made by player
            }
        }
    }
    

    // play player one card gotten from UI event
    @IBAction func playPlayerOneCard(_ sender: UIButton) {

        let indexOfCard = cardButtons.index(of: sender)!
        if !game.gameOver && indexOfCard <= game.playerOne.getHand().count - 1 {
            let playerOneCard = game.playerOne.getHand()[cardButtons.index(of: sender)!]
            game.makePlayerOneMove(playerOneCard)
            moveCount += 1
        }
    }
 
    private func displayLastMove(_ card1: Card, _ card2: Card) {
        var message = "Past hand: You played \(card1.toString()). Computer Played \(card2.toString()). "
        if game.playerOneTurn { // lead player was winner of last hand
            message += "You won that hand."
        } else {
            message += "Computer won that hand."
        }
        pastHand.text = message
    }
    
    private func updateDisplay() {
        //let handCount = game.playerOneHand.count - 1
        let handCount = game.playerOne.getHand().count
        
        for cardIndex in 0...4 {
            let button = cardButtons[cardIndex]
            if cardIndex <= handCount {
                let card: Card = game.playerOne.getHand()[cardIndex]
                button.setTitle("\(card.toString())", for: UIControl.State.normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.08970654756, green: 0.7447655797, blue: 0.2740525007, alpha: 1)
            }
        }
        
        playerOneScore.text = "Player One points: \(game.playerOnePoints)"
        playerTwoScore.text = "Computer points: \(game.playerTwoPoints)"
        trumpCard.text = "Trump Card: \(game.trumpCard.toString())"
        if game.gameOver {
            var message = ""
            if game.playerOnePoints > game.playerTwoPoints {
                message = "Game Over. You Won!"
            } else {
                message = "Game Over. You Lost."
            }
            gameStatus.text = message
        }
    }
}

