//
//  RegionIndexView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 09/01/2022.
//

import SwiftUI

struct RegionIndexView: View {
    @EnvironmentObject var game: PokemonQuizGame
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                regions
            }
        }
        .background(
            Image("background")
                .asBackgroundModifier()
        )
    }
    
    var regions: some View {
        ScrollView {
            LazyVStack (alignment: .center){
                ForEach(game.pokemonRegions) { region in
                    NavigationLink(destination: PokemonGameView().onAppear {
                        game.changeRegion(to: region.name)
                    }) {
                        Text("\(region.name)")
                            .frame(width: RegionIndexConstants.navButtonWidth)
                            .modifier(PokemonButton())
                    }
                }
            }
        }
    }
    
    private struct RegionIndexConstants {
        static let navButtonWidth: CGFloat = 200.0
    }
}

struct RegionIndexView_Previews: PreviewProvider {
    static var previews: some View {
        RegionIndexView()
    }
}
