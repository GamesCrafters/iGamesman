//
//  Game.swift
//  iGamesman
//
//  Created by Sina Dalir on 3/11/21.
//

import Foundation
import SwiftUI

//protocol Game {
//    var id: Int {get}
//    var name: String{get}
//    var imageName: String{get}
//}


enum GameStatus {
    case Win, Lose, Tie, Draw, InProcess
}

enum GameMode {
    case Player, Computer
}


class Game : Identifiable, ObservableObject {
    var id = UUID()
    var name: String
    var imageName: String
    var gameId: String
    var xmlId : String
    @Published var variant: String = "regular"
    @Published var positionPrefix: String = ""
    @Published var mode: GameMode = GameMode.Player
    @Published var playerAplay = true
    @Published var x: Int = 0
    @Published var y: Int = 0
    @Published var status = GameStatus.InProcess
    @Published var moves : [Move] = []
    @Published var position = ""

    
    init(name:String, imageName:String, gameId: String, xmlId: String) {
        self.name = name
        self.imageName = imageName
        self.gameId = gameId
        self.xmlId = xmlId
    }
   
    
    func setStartingValue(startingPosition: String) {
        self.positionPrefix = startingPosition[0..<8]
        self.x = Int(String(startingPosition[6]))!
        self.y = Int(String(startingPosition[4]))!
        self.position = startingPosition[8..<startingPosition.count]
        self.status = GameStatus.InProcess
        self.fetchMoves()
    }
    
    func setVariant(variant: String) {
        self.variant = variant
    }
    
    
    func getPositionView(position: Int) -> AnyView {
        
        AnyView(EmptyView())
    }
    
    func doMove(position: Int) {
        //Implement in subclasses
        print("KIIIR")
    }
    
    func isPositionDisabeled(position: Int) -> Bool {
        //Implement in subclasses
        return false
    }
    
    
    
    
    
    func fetchMoves() {
        let currentPosition = self.positionPrefix + self.position
       
        let url = URL(string: "https://nyc.cs.berkeley.edu/universal/v1/games/\(self.gameId)/variants/\(self.variant)/positions/\(currentPosition)")!
               // 2.
               URLSession.shared.dataTask(with: url) {(data, response, error) in
                   do {
                       if let todoData = data {
                           // 3.
                           let decodedData = try JSONDecoder().decode(MovesResponse.self, from: todoData)
                           DispatchQueue.main.async {
                            if (decodedData.response.moves.count == 0) {
                                if (decodedData.response.positionValue == "lose"){
                                    self.status = GameStatus.Win
                                } else if (decodedData.response.positionValue == "win") {
                                    self.status = GameStatus.Lose
                                } else {
                                    self.status = GameStatus.Tie
                                }
                            }
                            self.moves = decodedData.response.moves
                            
                           }
                       } else {
                           print("No data")
                       }
                   } catch {
                       print("Error")
                        print("Error info: \(error)")
                   }
               }.resume()
    }
    
    
}


let Games = [
    TicTacToe(name: "TicTacToe", imageName : "tictactoe", gameId: "ttt" , xmlId: "tictactoe"),
    Chomp(name: "Chomp", imageName : "chomp",gameId: "chomp", xmlId: "chomp" ),
    Nto0By1or2(name: "n to 0 by 1 or 2", imageName : "nto0",gameId: "nto0" , xmlId: "1210" )
] as [Game]
