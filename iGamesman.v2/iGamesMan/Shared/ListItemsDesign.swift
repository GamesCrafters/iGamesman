//
//  ListItemsDesign.swift
//  iGamesman
//
//  Created by Sina Dalir on 4/9/21.
//

import SwiftUI

struct ListItemsDesign: View {
    var name: String
    var imgName: String
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 11).fill(Color("GamesCraftersColor"))
            
            HStack {
                if imgName != "" {
                    Image(imgName)
                                    .resizable()
                        .frame(width: 50.0, height:50)
                        .cornerRadius(/*@START_MENU_TOKEN@*/8.0/*@END_MENU_TOKEN@*/)
                }
            
                    
                    
                Spacer()
                Text(name).foregroundColor(Color.white).font(.title)
                Spacer()
            }
            
        }
        
    }
}

struct ListItemsDesign_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsDesign(name: "Game", imgName: "tictactoe")
    }
}
