//
//  PokemonModel.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import Foundation
import SwiftUI

struct PokemonRegionModel: Identifiable {
    let id: Int
    let name: String
    var pokemon = [Pokemon]()
    let lowerBound: Int // Lowerbound of the pokedex for the region e.g. 1
    let upperBound: Int // Upperbound of the pokedex for the region e.g. 151
    var highscore: Int = 0
    var highestScore: Int = 0
    
    struct Pokemon: Identifiable {
        let id: Int
        let name: String
        var guessed: Bool = false
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
    
    func checkGameEnded() -> Bool {
        var hasEnded: Bool = true
        pokemon.forEach { poke in
            if !poke.guessed {
                hasEnded = false
            }
        }
        return hasEnded
    }
    
    // MARK: - Reset
    mutating func resetPokemon() {
        if highscore > highestScore {
            highestScore = highscore
            highscore = 0
        }
        for index in 0..<pokemon.count {
            pokemon[index].guessed = false
        }
    }
}
