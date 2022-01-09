//
//  HighscoreView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 08/01/2022.
//

import SwiftUI

struct HighscoreView: View {
    @EnvironmentObject var game: PokemonQuizGame
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack {
                        Text("Highscores")
                            .font(.title)
                            .foregroundColor(.yellow)
                            .shadow(color: .black, radius: 2)
                        ForEach(game.pokemonRegions) { region in
                            Text("\(region.name): \(region.highestScore)")
                                .font(.title)
                                .foregroundColor(HighscoresConstants.textColor)
                        }
                    }
                }
            }
        }
        .background(
            Image("background")
                .asBackgroundModifier()
        )
    }
    
    struct HighscoresConstants {
        static let textColor = Color.black
    }
}

struct HighscoreView_Previews: PreviewProvider {
    static var previews: some View {
        HighscoreView()
    }
}
