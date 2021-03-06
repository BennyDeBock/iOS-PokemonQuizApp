//
//  PokemonQuizAppApp.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import SwiftUI

@main
struct PokemonQuizApp: App {
    @StateObject var game = PokemonQuizGame()
    
    var body: some Scene {
        WindowGroup {
            StartupView()
                .environmentObject(game)
//            PokemonGameView(game: game)
        }
    }
}
