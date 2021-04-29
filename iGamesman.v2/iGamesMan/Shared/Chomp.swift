//
//  Chomp.swift
//  iGamesman
//
//  Created by Sina Dalir on 3/12/21.
//

import Foundation
import SwiftUI
class Chomp : Game {
    
    override func getPositionView(position: Int) -> AnyView{
        if self.position[position] == "x" {
            return AnyView(
                Image("chocloatequare").resizable().scaledToFit()
            
                
            )
        } else {
            return AnyView(Rectangle()
                            .fill(Color.white)
                            .scaledToFit())
        }
        
       
    }
    
    override func doMove(position: Int) {
        if let move = self.moves.filter({ $0.move == "A_x_" + String(position) }).first {
            self.position = move.position[8..<move.position.count]
            self.positionPrefix = move.position[0..<8]
            
        }
        self.fetchMoves()
        
    }
    
    override func isPositionDisabeled(position: Int) -> Bool {
        return self.position[position] != "x"
    }
    
    
}

