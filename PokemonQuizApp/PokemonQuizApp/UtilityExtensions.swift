//
//  UtilityExtensions.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 04/01/2022.
//

import SwiftUI


// Stretches an image to encompass the full background
// of a view. Ignores the safe areas as well.
extension Image {
    func asBackgroundModifier() -> some View {
        self.resizable()
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fill)
    }
}


extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}

extension Collection where Element == PokemonRegionModel.Pokemon {
    func contains(matching id: Int) -> Bool {
        let filtered = self.filter { $0.id == id }
        return filtered.count == 1
    }
}

extension Collection where Element == PokemonRegionModel.Pokemon {
    func getPokemon(matching id: Int) -> Self? {
        first(where: { $0.id == id }) as? Self
    }
}
