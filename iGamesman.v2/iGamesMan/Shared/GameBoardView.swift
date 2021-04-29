//
//  GameBoardView.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/14/21.
//

import SwiftUI
import ConfettiSwiftUI

struct GameBoardView: View {
    
    @ObservedObject var game: Game
    @State var counter:Int = 0
    
    
    
    var body: some View {
        
        if self.game.status == GameStatus.InProcess {
            VStack {
                ForEach(0..<game.y) { i in
                    HStack {
                        ForEach(0..<game.x) { j in
                            Button(action: {
                                game.doMove(position : i * game.x + j)
                                
                            }) {
                                
                                game.getPositionView(position: i * game.x + j)
                                
                                
                            }.disabled(game.isPositionDisabeled(position: i * game.x + j))
                            
                        }
                    }
                    
                    
                }
            }.background(Color.black).padding(.horizontal, 20.0)
        } else if self.game.status == GameStatus.Win {
            ZStack{
                Text("🎉Winner🎉").font(.system(size: 50)).onAppear(){counter += 10}
                ConfettiCannon(counter: $counter, repetitions: 3, repetitionInterval: 0.7)
            }
        } else if self.game.status == GameStatus.Tie {
            ZStack{
                Text("⚠️Tie⚠️").font(.system(size: 50)).onAppear(){counter += 10}
                ConfettiCannon(counter: $counter, confettis: [.text("⚠️")], repetitions: 3, repetitionInterval: 0.7)
            }
        } else {
            ZStack{
                Text("❌LOSERRR❌").font(.system(size: 50)).onAppear(){counter += 10}
                ConfettiCannon(counter: $counter, confettis: [.text("❌")], repetitions: 3, repetitionInterval: 0.7)
            }
        }
        
        
        
    }
}

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(game: TicTacToe(name: "TicTacToe", imageName : "tictactoe", gameId: "ttt", xmlId: "tictactoe"))
    }
}
