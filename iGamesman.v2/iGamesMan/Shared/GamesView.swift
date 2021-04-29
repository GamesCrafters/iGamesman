//
//  GamesView.swift
//  Shared
//
//  Created by Sina Dalir on 3/11/21.
//

import SwiftUI


struct GamesView: View {
   

    var games: [Game] = []
    
    
    
    
    init(games: [Game]) {
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(named: "GamesCraftersColor")!]
        self.games = games
    }
    
    var body: some View {
        

       
        NavigationView {

            List(games) { game in
                NavigationLink(destination: GameView(game: game)) {

                    ListItemsDesign(name: game.name, imgName: game.imageName)

                }
            }
            .navigationTitle(Text("Games"))
            
        }
        
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView(games: Games)
    }
}
