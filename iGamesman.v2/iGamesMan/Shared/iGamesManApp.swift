//
//  iGamesmanApp.swift
//  Shared
//
//  Created by Sina Dalir on 3/11/21.
//

import SwiftUI

@main
struct iGamesmanApp: App {
    
    var body: some Scene {
        WindowGroup {
            GamesView(games: Games)
        }
    }
}
