//
//  PokemonQuizAppApp.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import SwiftUI

@main
struct PokemonQuizApp: App {
    private let game = PokemonQuizGame()
    
    var body: some Scene {
        WindowGroup {
            PokemonGameView(game: game)
        }
    }
}
