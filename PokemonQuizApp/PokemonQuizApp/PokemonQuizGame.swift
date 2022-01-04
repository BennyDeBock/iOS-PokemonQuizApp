//
//  PokemonQuizGame.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 04/01/2022.
//

import SwiftUI
import Combine
import PokemonAPI

class PokemonQuizGame: ObservableObject {
    
    
    private static func createPokemonRegion() -> PokemonRegionModel {
        PokemonRegionModel(id: 1, name: "Kanto", lowerBound: 1, upperBound: 151)
    }
    
    @Published private var pokemonRegion = createPokemonRegion()
    
    
    // To return information of the given pokemon to the player if needed
    var pokemon: [PokemonRegionModel.Pokemon] { pokemonRegion.pokemon }
    
    // MARK: - Getting a pokemon
    @Published var spriteImage: UIImage?
    @Published var pokemonFetchStatus = PokemonFetchStatus.idle
    
    enum PokemonFetchStatus {
        case idle
        case fetching
        case failed(URL)
    }
    
    private var pokemonFetchCancellable: AnyCancellable?
    
    func chooseRandomPokemon() {
        let pokedexRange = pokemonRegion.upperBound - pokemonRegion.lowerBound
        
        if pokemon.count != pokedexRange {
            var chosenPokemon = pokemonRegion.chooseRandomPokemon()
            var newPokemon = false
            
            //Loop until it finds a pokemon that hasn't been added yet
            repeat {
                if !pokemon.contains(matching: chosenPokemon){
                    pokemonFetchCancellable = PokemonAPI().pokemonService.fetchPokemon(chosenPokemon)
                        .sink(receiveCompletion: { completion in
                            if case .failure(let error) = completion {
                                print(error.localizedDescription)
                            }
                        }, receiveValue: { pokemon in
                            let spriteUrl = URL(string: pokemon.sprites!.frontDefault!)
                            self.addPokemon(has: pokemon.id!, has: pokemon.name!, with: .url(spriteUrl!))
                            
                            print("\(pokemon.id ?? 0): \(pokemon.name ?? "MissingNo")")
                            //print("\(pokemon.sprites?.frontDefault ?? "NotFound")")
                        })
                    newPokemon = true
                } else {
                    chosenPokemon = pokemonRegion.chooseRandomPokemon()
                }
            } while (!newPokemon)
        }
        
        print("\(pokemon.count + 1)")
    }
    
    func addPokemon(has id: Int, has name: String, with sprite: Sprite) {
        pokemonRegion.addPokemon(id, name, sprite)
    }
    
}
