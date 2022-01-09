//
//  HighscoreView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 08/01/2022.
//

import SwiftUI

struct HighscoreView: View {
    @ObservedObject var game: PokemonQuizGame
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HighscoreView_Previews: PreviewProvider {
    static var previews: some View {
        let game = PokemonQuizGame()
        HighscoreView(game: game)
    }
}
