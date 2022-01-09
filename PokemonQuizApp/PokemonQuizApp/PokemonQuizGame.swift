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
    
    @Published private var pokemonRegion: PokemonRegionModel = PokemonRegionModel()
    
    var pokemonRegions = [PokemonRegionModel]() {
        didSet{
            storeInUserDefaults()
        }
    }
    
    
    private var userDefaultsKey: String {
        "PokemonQuizGame"
    }
    
    private func storeInUserDefaults(){
        UserDefaults.standard.set(try? JSONEncoder().encode(pokemonRegions), forKey: userDefaultsKey)
    }
    
    private func restoreFromUserDefaults(){
        if let jsonData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decodedRegions = try? JSONDecoder().decode(Array<PokemonRegionModel>.self, from: jsonData){
            pokemonRegions = decodedRegions
        }
    }
    
    init() {
        restoreFromUserDefaults()
        print(pokemonRegions)
        if(pokemonRegions.isEmpty)
        {
            addRegion(with: "Kanto", pokedexLowerLimit: 149, pokedexUpperLimit: 151)
            addRegion(with: "Johto", pokedexLowerLimit: 248, pokedexUpperLimit: 251)
            addRegion(with: "Hoenn", pokedexLowerLimit: 252, pokedexUpperLimit: 386)
            addRegion(with: "Sinnoh", pokedexLowerLimit: 387, pokedexUpperLimit: 493)
            addRegion(with: "Unova", pokedexLowerLimit: 494, pokedexUpperLimit: 649)
            addRegion(with: "Kalos", pokedexLowerLimit: 650, pokedexUpperLimit: 721)
            addRegion(with: "Alola", pokedexLowerLimit: 722, pokedexUpperLimit: 809)
        }
    }
    
    // To return information of the given pokemon to the player if needed
    var pokemon: [PokemonRegionModel.Pokemon] { pokemonRegion.pokemon }
    var highscore: Int { pokemonRegion.highscore }
    private var chosenPokemonId: Int = 0
    
    
    // MARK: - Sprite
    enum SpriteFetchStatus: Equatable {
        case idle
        case fetching
        case failed(URL)
    }
    private var spriteFetchCancellable: AnyCancellable?
    @Published var spriteFetchStatus = SpriteFetchStatus.idle
    
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
    var pokemonFetchStatus = PokemonFetchStatus.idle
    
    enum PokemonFetchStatus {
        case idle
        case fetching
        case failed
    }
    
    private var pokemonFetchCancellable: AnyCancellable?
    
    //Choose a random pokemon from either the already stores list or get a pokemon not yet in the list
    func chooseRandomPokemon() {
        pokemonFetchStatus = .fetching
        let pokedexRange = pokemonRegion.upperBound - pokemonRegion.lowerBound + 1
        var chosenPokemon = pokemonRegion.chooseRandomPokemon()
        
        //Retrieve from the internet
        if pokemonRegion.pokemon.count != pokedexRange {
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
                            let pokemonName = pokemon.name!
                            self?.addPokemon(has: pokemon.id!, has: pokemonName, with: .url(spriteUrl!))
                            self?.pokemonFetchStatus = PokemonFetchStatus.idle
                            self?.fetchPokemonSpriteIfNecessary()
                            self?.chosenPokemonId += 1
                        })
                    newPokemon = true
                } else {
                    chosenPokemon = pokemonRegion.chooseRandomPokemon()
                }
            } while (!newPokemon)
        } else if !gameHasEnded {
            pokemonFetchStatus = .idle
            fetchPokemonSpriteIfNecessary()
            chosenPokemonId += 1
        } else {
            print("Congrats, you finished")
        }
    }
    
    
    // MARK: - Initialized
    func changeRegion(to name: String) {
        resetGame()
        let region = pokemonRegions.getRegion(with: name)
        pokemonRegion = region!
        chooseRandomPokemon()
    }
    
    // MARK: - Intent(s)
    private func addRegion(with name: String, pokedexLowerLimit lower: Int, pokedexUpperLimit upper: Int, at index: Int = 0) {
        let unique = (pokemonRegions.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let region = PokemonRegionModel(has: unique, with: name, pokedexLowerLimit: lower, pokedexUpperLimit: upper)
        let safeIndex = min(max(index, 0), pokemonRegions.count)
        pokemonRegions.insert(region, at: safeIndex)
    }
    
    func addPokemon(has id: Int, has name: String, with sprite: Sprite) {
        pokemonRegion.addPokemon(id, name, sprite)
    }
    
    func guessPokemon(guess name: String) -> Bool {
        if pokemon[chosenPokemonId - 1].name == name.lowercased() {
            pokemonRegion.pokemon[chosenPokemonId - 1].guessed = true
            pokemonRegion.increaseHighscore(is: true)
            save()
            checkGameEnded()
            return true
        } else {
            pokemonRegion.increaseHighscore(is: false)
            return false
        }
    }
    
    var gameHasEnded: Bool = false
    
    func checkGameEnded() {
        save()
        if pokemon.count == (pokemonRegion.upperBound - pokemonRegion.lowerBound + 1) {
            let hasEnded = pokemonRegion.checkGameEnded()
            print("hasEnded: \(hasEnded)")
            if(hasEnded){
                gameHasEnded = true
            }
        }
    }
    
    private func save() {
        let index = pokemonRegions.index(matching: pokemonRegion)
        if index != nil {
            pokemonRegions[index!] = pokemonRegion
            if let encoded = try? JSONEncoder().encode(pokemonRegions) {
                UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            }
        }
    }
    
    // MARK: - Reset
    
    func resetGame() {
        pokemonRegion.reset()
        chosenPokemonId = 0
        gameHasEnded = false
        save()
    }
}
