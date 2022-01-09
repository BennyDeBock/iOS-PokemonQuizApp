//
//  StartupView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 08/01/2022.
//

import SwiftUI

struct StartupView: View {
    private let game = PokemonQuizGame()
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Text("Who's that pokémon?")
                            .font(.title)
                        NavigationLink(destination: PokemonGameView(game: game)) {
                            Text("Choose region")
                                .padding()
                                .foregroundColor(.black)
                                .font(.title)
                                .background(Color.yellow)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 1)
                        }
                        
                        NavigationLink(destination: HighscoreView(game: game)) {
                            Text("Highscores")
                                .padding()
                                .foregroundColor(.black)
                                .font(.title)
                                .background(Color.yellow)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 1)
                        }
                    }
                }
            }
            .background(
                Image("background")
                    .asBackgroundModifier()
            )
            
        }.navigationViewStyle(.stack)
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
