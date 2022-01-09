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
        PokemonRegionModel(id: 1, name: "Kanto", lowerBound: 252, upperBound: 254/*386*/)
        // 252 - 386
    }
    
    @Published private var pokemonRegion = createPokemonRegion()
    
    
    // To return information of the given pokemon to the player if needed
    var pokemon: [PokemonRegionModel.Pokemon] { pokemonRegion.pokemon }
    
    private var chosenPokemonId: Int = 0
    
    
    // MARK: - Sprite
    enum SpriteFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    private var spriteFetchCancellable: AnyCancellable?
    private var spriteFetchStatus = SpriteFetchStatus.idle
    
    private func fetchPokemonSpriteIfNecessary() {
        spriteImage = nil
        switch pokemonRegion.pokemon[chosenPokemonId].sprite {
        case .url(let url):
            spriteFetchStatus = .fetching
            spriteFetchCancellable?.cancel()
            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, urlResponse) in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            spriteFetchCancellable = publisher
                .sink { [weak self] sprite in
                    self?.spriteImage = sprite
                    self?.spriteFetchStatus = (sprite != nil) ? .idle : .failed(url)
                    
                }
        case .spriteData(let data):
            spriteImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Fetch a pokemon
    @Published var spriteImage: UIImage?
    @Published var pokemonFetchStatus = PokemonFetchStatus.idle
    
    enum PokemonFetchStatus {
        case idle
        case fetching
        case failed
    }
    
    private var pokemonFetchCancellable: AnyCancellable?
    
    //Choose a random pokemon from either the already stores list or get a pokemon not yet in the list
    func chooseRandomPokemon() {
        pokemonFetchStatus = PokemonFetchStatus.fetching
        let pokedexRange = pokemonRegion.upperBound - pokemonRegion.lowerBound + 1
        var chosenPokemon = pokemonRegion.chooseRandomPokemon()
        
        //Retrieve from the internet
        if pokemon.count != pokedexRange {
            var newPokemon = false
            
            //Loop until it finds a pokemon that hasn't been added yet
            repeat {
                if !pokemon.contains(matching: chosenPokemon){
                    //Get the pokemon information from the api
                    pokemonFetchCancellable = PokemonAPI().pokemonService.fetchPokemon(chosenPokemon)
                        .sink(receiveCompletion: { [weak self] completion in
                            if case .failure(let error) = completion {
                                self?.pokemonFetchStatus = PokemonFetchStatus.failed
                                print(error.localizedDescription)
                            }
                        }, receiveValue: { [weak self] pokemon in
                            let spriteUrl = URL(string: pokemon.sprites!.frontDefault!)
                            let pokemonName = pokemon.name!.hasPrefix("deoxys") ? "deoxys" : pokemon.name!
                            self?.addPokemon(has: pokemon.id!, has: pokemonName, with: .url(spriteUrl!))
                            self?.pokemonFetchStatus = PokemonFetchStatus.idle
                            self?.fetchPokemonSpriteIfNecessary()
                            self?.chosenPokemonId += 1
                            print(pokemonName)
                        })
                    newPokemon = true
                } else {
                    chosenPokemon = pokemonRegion.chooseRandomPokemon()
                }
            } while (!newPokemon)
        } else if !pokemonRegion.checkGameEnded() {
            var notGuessedPokemon = false
            repeat {
                //Check if chosen pokemon has been guessed
                if ((pokemon.getPokemon(matching: chosenPokemon)?.guessed) != nil) {
                    chosenPokemon = pokemonRegion.chooseRandomPokemon()
                } else {
                    notGuessedPokemon = true
                }
            } while (!notGuessedPokemon)
        } else {
            print("Got all pokemon: \(pokemon.count):\(pokedexRange)")
        }
    }
    
    
    // MARK: - Intent(s)
    func addPokemon(has id: Int, has name: String, with sprite: Sprite) {
        pokemonRegion.addPokemon(id, name, sprite)
    }
    
    func guessPokemon(guess name: String) -> Bool {
        if pokemon[chosenPokemonId - 1].name == name.lowercased() {
            pokemonRegion.pokemon[chosenPokemonId - 1].guessed = true
            return true
        } else {
            return false
        }
    }
    
    func checkGameEnded() -> Bool {
        pokemonRegion.checkGameEnded()
    }
}
