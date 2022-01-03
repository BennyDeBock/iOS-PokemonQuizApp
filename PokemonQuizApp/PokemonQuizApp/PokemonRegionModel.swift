//
//  PokemonModel.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import Foundation

struct PokemonRegionModel {
    let name: String
    var pokemon = [Pokemon]()
    
    struct Pokemon: Identifiable {
        let id: Int
        let name: String
        
        fileprivate init(id: Int,g name: String) {
            self.id = id
            self.name = name
        }
    }
}
