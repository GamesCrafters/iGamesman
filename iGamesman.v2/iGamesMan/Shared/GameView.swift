//
//  GameView.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/28/21.
//

import SwiftUI
import SwiftyXMLParser


struct GameView: View {
    
    var game: Game
    @State private var showingSheet = false
    
    
    
    var body: some View {
        VStack{
            Spacer()
            NavigationLink(destination: GameVariantView(game: game)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color("GamesCraftersColor"))
                        .scaledToFit()
                        .padding(.horizontal)
                    Text("Play").foregroundColor(Color.white).font(.title)
                }
            }
            
            
            
            Spacer()
            
            
            Button(action: {
                showingSheet = true
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color("GamesCraftersColor"))
                        .scaledToFit()
                        .padding(.horizontal)
                    
                    Text("Learn \(game.name)").foregroundColor(Color.white).font(.title)
                }})
            Spacer()
            
            
            
        }.sheet(isPresented: $showingSheet) {
            XMLView(game: game)
        }
        
        
        
        
        
    }
    
    
}

struct XMLView: View {
    
    @State var game: Game
    @State var xml : XML.Accessor? = nil
    @Environment(\.presentationMode) var presentationMode
    
    
    func fetchXML() {
        
        let url = URL(string: "http://gamescrafters.berkeley.edu/games/\(game.xmlId).xml")!
        // 2.
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            do {
                if let xmlData = data {
                    
                    DispatchQueue.main.async {
                        let str = String(decoding: xmlData, as: UTF8.self)
                        xml = try! XML.parse(str)
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
        VStack{
            Group{
            Text("History").foregroundColor(Color("GamesCraftersColor")).font(.title)
            Spacer()
                    .frame(height: 2)
            Text(xml?["game","history"].text ?? "").font(.body)
            Spacer()
                    .frame(height: 8)
            Text("Board").foregroundColor(Color("GamesCraftersColor")).font(.title)
            Spacer()
                    .frame(height: 2)
            Text(xml?["game","board"].text ?? "").font(.body)
            Spacer()
                    .frame(height: 8)

            }
            Group {
                Text("Pieces").foregroundColor(Color("GamesCraftersColor")).font(.title)
                Spacer()
                        .frame(height: 2)
                Text(xml?["game","pieces"].text ?? "").font(.body)
                Spacer()
                        .frame(height: 8)
                
                Text("Rules").foregroundColor(Color("GamesCraftersColor")).font(.title)
                Spacer()
                        .frame(height: 2)
                Text(xml?["game","rules"].text ?? "").font(.body)
                Spacer()
                        .frame(height: 8)
            }
        }.onAppear(perform: fetchXML)
        
        
    }
    
    
}




struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameVariantView(game: TicTacToe(name: "TicTacToe", imageName : "tictactoe", gameId: "ttt" , xmlId: "tictactoe"))
    }
}
