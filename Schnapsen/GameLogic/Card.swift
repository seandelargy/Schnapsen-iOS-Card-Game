//
//  Card.swift
//  Schnapsen
//
//  Created by Sean Delargy on 1/11/19.
//  Copyright © 2019 Sean Delargy. All rights reserved.
//

import Foundation

struct Card: Equatable {
    var suit: Suit
    var val: Value
    
    
    enum Value: Int, CaseIterable{
        case ace = 11
        case ten = 10
        case king = 4
        case queen = 3
        case jack = 2
    }
    
    enum Suit: CaseIterable {
        case club
        case spade
        case diamond
        case heart
    }
    
    func toString() -> String {
        var stringVal = ""
        
        let rank = self.val
        switch rank {
        case .ace:
            stringVal += "A"
        case .ten:
            stringVal += "10"
        case .king:
            stringVal += "K"
        case .queen:
            stringVal += "Q"
        case .jack:
            stringVal += "J"
        }
        
        let thisSuit = self.suit
        switch thisSuit {
        case .club:
            stringVal += "♣"
        case .spade:
            stringVal += "♠"
        case .diamond:
            stringVal += "♦"
        case .heart:
            stringVal += "❤"
        }
        return stringVal
    }
}
