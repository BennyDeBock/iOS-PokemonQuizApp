//
//  Sprite.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 04/01/2022.
//

import Foundation

enum Sprite {
    case blank
    case url(URL)
    case spriteData(Data)
    
    var url: URL?{
        switch self{
        case .url(let url): return url
        default: return nil
        }
    }
    
    var data: Data?{
        switch self{
        case .spriteData(let data): return data
        default: return nil
        }
    }
}
