//
//  HighscoreView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 08/01/2022.
//

import SwiftUI

struct HighscoreView: View {
    @EnvironmentObject var game: PokemonQuizGame
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                Text("cool")
            }
        }
        .background(
            Image("background")
                .asBackgroundModifier()
        )
    }
}

struct HighscoreView_Previews: PreviewProvider {
    static var previews: some View {
        HighscoreView()
    }
}
