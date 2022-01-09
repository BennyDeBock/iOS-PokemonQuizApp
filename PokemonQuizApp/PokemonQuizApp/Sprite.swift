//
//  Sprite.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 04/01/2022.
//

import Foundation

enum Sprite: Equatable, Codable {
    case blank
    case url(URL)
    case spriteData(Data)
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? container.decode(URL.self, forKey: .url) {
            self = .url(url)
        } else if let spriteData = try? container.decode(Data.self, forKey: .spriteData) {
            self = .spriteData(spriteData)
        } else {
            self = .blank
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "spriteURL"
        case spriteData
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self{
        case .url(let url): try container.encode(url, forKey: .url)
        case .spriteData(let data): try container.encode(data, forKey: .spriteData)
        case .blank: break
        }
    }
    
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
