//
//  StartupView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 08/01/2022.
//

import SwiftUI

struct StartupView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    LazyVStack(alignment: .center) {
                        Text("Who's that pokémon?")
                            .font(.title)
                            .foregroundColor(ViewConstants.textColor)
                        NavigationLink(destination: RegionIndexView()) {
                            Text("Choose region")
                                .modifier(PokemonButton())
                        }
                        
                        NavigationLink(destination: HighscoreView()) {
                            Text("Highscores")
                                .modifier(PokemonButton())
                        }
                    }.position(toCenter(in: geometry))
                }
            }
            .background(
                Image("background")
                    .asBackgroundModifier()
            )
            
        }.navigationViewStyle(.stack)
    }
    
    struct ViewConstants {
        static let textColor = Color.black
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
