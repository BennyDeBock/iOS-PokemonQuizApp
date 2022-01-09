//
//  ViewModifierExtensions.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 09/01/2022.
//

import SwiftUI

struct PokemonButton: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .padding()
            .foregroundColor(ButtonConstants.textColor)
            .font(.title)
            .background(ButtonConstants.backgroundColor)
            .cornerRadius(ButtonConstants.cornerRadius)
            .shadow(color: .black, radius: 1)
    }
    
    struct ButtonConstants {
        static let textColor = Color.black
        static let cornerRadius: CGFloat = 20.0
        static let backgroundColor = Color.yellow
    }
}
