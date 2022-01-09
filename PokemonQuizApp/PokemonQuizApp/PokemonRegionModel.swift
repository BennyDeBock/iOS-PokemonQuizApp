//
//  PokemonModel.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import Foundation
import SwiftUI

struct PokemonRegionModel: Identifiable, Codable {
    let id: Int
    let name: String
    var pokemon = [Pokemon]()
    let lowerBound: Int // Lowerbound of the pokedex for the region e.g. 1
    let upperBound: Int // Upperbound of the pokedex for the region e.g. 151
    var highscore: Int = 0
    var highestScore: Int = 0
    
    init() {
        self.id = 999
        self.name = "Missing"
        self.lowerBound = 0
        self.upperBound = 0
    }
    
    init(has id: Int, with name: String, pokedexLowerLimit lower: Int, pokedexUpperLimit upper: Int) {
        self.id = id
        self.name = name
        self.lowerBound = lower
        self.upperBound = upper
    }
    
    struct Pokemon: Identifiable, Codable {
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
    mutating func reset() {
        if highscore > highestScore {
            highestScore = highscore
            highscore = 0
        }
        
        consecutiveGuesses = 0
        
        pokemon.shuffle()
        
        for index in 0..<pokemon.count {
            pokemon[index].guessed = false
        }
    }
    
    private var consecutiveGuesses: Int = 0
    mutating func increaseHighscore(is consecutive: Bool) {
        if consecutive {
            highscore += consecutiveGuesses == 0 ? PokemonRegionConstants.increaseScore : PokemonRegionConstants.increaseScore + ((PokemonRegionConstants.increaseScore * consecutiveGuesses) / PokemonRegionConstants.increaseMultiplierDivider)
            consecutiveGuesses += 1
        } else {
            consecutiveGuesses = 0
        }
    }
    
    private struct PokemonRegionConstants {
        static let increaseScore: Int = 50
        static let increaseMultiplierDivider: Int = 5
    }
}
