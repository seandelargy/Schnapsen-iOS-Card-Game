//
//  ViewController.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
        promptNextMove()
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var playerOneScore: UILabel!
    
    @IBOutlet private weak var playerTwoScore: UILabel!

    @IBOutlet private weak var trumpCard: UILabel!
    
    @IBOutlet private weak var gameStatus: UILabel!
    
    @IBOutlet private weak var pastHand: UILabel!
    
    private var game = Schnapsen()
    
    private var computerMove: Card!
    
    private func updateDisplay() {
        let handCount = game.playerOneHand.count - 1
        
        for cardIndex in 0...4 {
            let button = cardButtons[cardIndex]
            if cardIndex <= handCount {
                let card: Card = game.playerOneHand[cardIndex]
                button.setTitle("\(card.toString())", for: UIControl.State.normal)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.08970654756, green: 0.7447655797, blue: 0.2740525007, alpha: 1)
            }
        }
        
        playerOneScore.text = "Player One points: \(game.playerOnePoints)"
        playerTwoScore.text = "Player Two points: \(game.playerTwoPoints)"
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
    
    private func promptNextMove() {
        if !game.gameOver {
            if !game.playerOneOnLead {
                computerMove = game.getComputerLeadMove() // computer picks card to lead with
                gameStatus.text = "Computer played \(computerMove!.toString()). Your turn"
            } else {
                gameStatus.text = "You're on lead. Your turn."
                computerMove = nil
            }
        }
    }
    
    private func displayLastMove(_ card1: Card, _ card2: Card) {
        var message = "Past hand: You played \(card1.toString()). Computer Played \(card2.toString()). "
        if game.playerOneOnLead {
            message += "You won that hand."
        } else {
            message += "Computer won that hand."
        }
        pastHand.text = message
    }
    
    @IBAction func playCard(_ sender: UIButton) {
        let indexOfCard = cardButtons.index(of: sender)!
        if !game.gameOver && indexOfCard <= game.playerOneHand.count - 1 {
            let playerOneCard = game.playerOneHand[cardButtons.index(of: sender)!]
            if computerMove != nil { // computer is on lead
                game.playCards(playerOneCard, computerMove!)
            } else { // computer needs to respond to move
                computerMove = game.getComputerMove(playerOneCard)
                game.playCards(playerOneCard, computerMove!)
            }
            displayLastMove(playerOneCard, computerMove)
            updateDisplay()
            promptNextMove()
        }
    }
}

