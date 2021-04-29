//
//  Computer.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/14/21.
//

import Foundation


func computerPlay(moves: [Move]) -> Move {
    var bestMove : Move = Move(deltaRemoteness: 0,move : "", moveValue : "lose", position: "", positionValue: "", remoteness: 0 )
    
    for move in moves {
        if bestMove.moveValue == "win" {
           break
        } else {
            if move.moveValue == "win" || move.moveValue == "tie" {
                bestMove = move
            } else if bestMove.moveValue != "tie"{
                bestMove = move
            }
        }
    }
    return bestMove
    
}
