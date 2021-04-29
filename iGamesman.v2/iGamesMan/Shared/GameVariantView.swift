//
//  GameVariantView.swift
//  iGamesman
//
//  Created by Sina Dalir on 3/23/21.
//

import SwiftUI

struct VariantResponse: Codable {
    var response: GameVariant
    var status: String
 
}

struct GameVariant: Codable {
    var gameId: String
    var name : String
    var variants: [Variants]
}

struct Variants: Codable  {
    
    var description: String
    var startPosition: String
    var status: String
    var variantId: String
}



struct GameVariantView: View {
    
     var game: Game
    @State var variants = [Variants]()
    @State var chosen = false
    
    func fetch() {
       
        let url = URL(string: "https://nyc.cs.berkeley.edu/universal/v1/games/\(game.gameId)")!
               // 2.
               URLSession.shared.dataTask(with: url) {(data, response, error) in
                   do {
                       if let todoData = data {
                           // 3.
                           let decodedData = try JSONDecoder().decode(VariantResponse.self, from: todoData)
                           DispatchQueue.main.async {
                            self.variants = decodedData.response.variants
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
    

    var body: some View {
        
        if !chosen {
            List(variants, id: \.variantId){ variant in
                Button {
                    self.chosen = true
                    self.game.setVariant(variant: variant.variantId)
                    self.game.setStartingValue(startingPosition: variant.startPosition)
                        } label: {
                            ListItemsDesign(name:variant.description , imgName:"")
                        }
                }.navigationBarTitle("Variants").onAppear(perform: fetch)
        } else {
            GameBoardView(game: game).navigationBarTitle(game.name)
        }
       
        
        

           
    }
    
    
}



struct GameVariantView_Previews: PreviewProvider {
    static var previews: some View {
        GameVariantView(game: TicTacToe(name: "TicTacToe", imageName : "tictactoe", gameId: "ttt" , xmlId: "tictactoe"))
    }
}
