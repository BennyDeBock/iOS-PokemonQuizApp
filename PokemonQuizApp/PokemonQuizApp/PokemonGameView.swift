//
//  PokemonGameView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import SwiftUI

struct PokemonGameView: View {
    @ObservedObject var game: PokemonQuizGame
    
    var body: some View {
        ZStack {
            Image("background")
                .asBackgroundModifier()
            pokemonBody
        }
    }
    
    var pokemonBody: some View {
        VStack {
            Button("Choose pokemon") {
                choosePokemon()
            }
            
            ScrollView {
                VStack(alignment: .leading){
                    ForEach(game.pokemon) { pokemon in
                        HStack {
                            Group{
                                Text("ID: \(pokemon.id)")
                                Spacer()
                                Text("Name: \(pokemon.name)")
                            }
                            .font(.largeTitle)
                        }
                    }
                }
            }
        }.padding(50)
    }
    
    func choosePokemon() {
        game.chooseRandomPokemon()
    }
    
    
}



struct PokemonGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = PokemonQuizGame()
        PokemonGameView(game: game)
            .previewDevice("iPhone 11 Pro Max")
    }
}
