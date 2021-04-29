//
//  TicTacToe.swift
//  iGamesman
//
//  Created by Sina Dalir on 3/11/21.
//

import SwiftUI
import Foundation


class TicTacToe: Game {
    

    
    override func doMove(position: Int) {
        var value : Character
        if self.playerAplay {
            value = "x"
        } else {
            value = "o"
        }
        if let move = self.moves.filter({ $0.move == "A_\(value)_" + String(position) }).first {
            self.position = move.position[8..<move.position.count]
            self.positionPrefix = move.position[0..<8]
            
        }
        
        self.playerAplay = !self.playerAplay
        self.fetchMoves()
        
    }
    
    override func getPositionView(position: Int) -> AnyView {
        
        AnyView(ZStack {
            Rectangle()
                .fill(Color.white)
                .scaledToFit()
            if self.position[position] == "x" {
                Image(systemName: "xmark").scaledToFit()
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            } else if self.position[position] == "o" {
                Image(systemName: "circle").scaledToFit()
                    .font(.largeTitle)
                    .foregroundColor(.red)
                
            }
        })
    }
    
    override func isPositionDisabeled(position: Int) -> Bool {
        return self.position[position] != "-"
    }
    
    
}
