//
//  Nto0By1or2.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/14/21.
//

import Foundation
import SwiftUI

class Nto0By1or2 : Game {
    

    
    
    override func getPositionView(position: Int) -> AnyView{
        if self.position[position] == Character(String(self.x - position - 1)) {
            return AnyView(
                ZStack {
                    if self.playerAplay {
                        Rectangle()
                            .fill(Color.init(red: 0, green: 128, blue: 255))
                        .scaledToFit()
                    } else {
                        Rectangle()
                            .fill(Color.init(red: 232, green: 71, blue: 65))
                        .scaledToFit()
                    }
                    Text("\(self.x - position - 1)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    
                }
            )
        } else {
            return AnyView(Rectangle()
                            .fill(Color.white)
                            .scaledToFit())
        }
        
       
    }
    
    override func doMove(position: Int) {
        var ind = 0
        for (index, char) in self.position.enumerated() {
            if char != "-" {
                ind = index
            }
        }
        if let move = self.moves.filter({ $0.move == "M_\(ind)_\(position)" }).first {
            print(move.position)
            self.position = move.position[8..<move.position.count]
            self.positionPrefix = move.position[0..<8]
            self.playerAplay = !self.playerAplay
            self.fetchMoves()
            
        }
        
    }
    
    override func isPositionDisabeled(position: Int) -> Bool {
        var ind = 0
        for (index, char) in self.position.enumerated() {
            if char != "-" {
                ind = index
            }
        }
        
        return position <= ind
    }
    
    
}
