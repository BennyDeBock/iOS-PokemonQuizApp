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
    func getPokemon(matching id: Int) -> PokemonRegionModel.Pokemon? {
        first(where: { $0.id == id }) ?? nil
    }
    
    func index(matching id: Int) -> Self.Index? {
        firstIndex(where: { $0.id == id }) ?? nil
    }
}



extension Collection where Element == PokemonRegionModel {
    func getRegion(with name: String) -> PokemonRegionModel? {
        first(where: { $0.name == name }) ?? nil
    }
}

extension CGSize {
    // the center point of an area that is our size
    var center: CGPoint {
        CGPoint(x: width/2, y: height/2)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension View {
    func toCenter(in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(
            x: center.x,
            y: center.y
        )
    }
}
