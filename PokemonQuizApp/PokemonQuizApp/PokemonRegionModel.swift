//
//  PokemonModel.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import Foundation

struct PokemonRegionModel: Identifiable {
    let id: Int
    let name: String
    var pokemon = [Pokemon]()
    let lowerBound: Int // Lowerbound of the pokedex for the region e.g. 1
    let upperBound: Int // Upperbound of the pokedex for the region e.g. 151
    
    struct Pokemon: Identifiable {
        let id: Int
        let name: String
        var sprite = Sprite.blank
        
        fileprivate init(id: Int, name: String, sprite: Sprite) {
            self.id = id
            self.name = name
            self.sprite = sprite
        }
        
        
    }
    
    // MARK: - Intent(s)
    
    mutating func addPokemon(_ id: Int, _ name: String, _ sprite: Sprite) {
        pokemon.append(Pokemon(id: id, name: name, sprite: sprite))
    }
    
    func chooseRandomPokemon() -> Int {
        Int.random(in: lowerBound...upperBound)
    }
}
