//
//  UtilityViews.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 04/01/2022.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage: UIImage?
    var guessed: Bool
    
    var body: some View {
        if uiImage != nil {
            if guessed {
                Image(uiImage: uiImage!)
                    .scaleEffect(PokemonImageConstraints.spriteScale)
                    .frame(width: PokemonImageConstraints.frameDimensions, height: PokemonImageConstraints.frameDimensions)
                    .transition(.asymmetric(insertion: .identity, removal: .scale).animation(.linear(duration: 1.0)))
            } else {
                Color.black
                    .mask(
                        Image(uiImage: uiImage!)
                            .scaleEffect(PokemonImageConstraints.spriteScale)
                    )
                    .frame(width: PokemonImageConstraints.frameDimensions, height: PokemonImageConstraints.frameDimensions)
                    .transition(.asymmetric(insertion: .scale, removal: .identity).animation(.linear(duration: 2.0)))
            }
            
        }
    }
    
    private struct PokemonImageConstraints {
        static let spriteScale: CGFloat = 3.0
        static let frameDimensions: CGFloat = 250
    }
}




