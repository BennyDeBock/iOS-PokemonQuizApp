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
                        NavigationLink(destination: PokemonGameView()) {
                            Text("Choose region")
                                .padding()
                                .foregroundColor(.black)
                                .font(.title)
                                .background(Color.yellow)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 1)
                        }
                        
                        NavigationLink(destination: HighscoreView()) {
                            Text("Highscores")
                                .padding()
                                .foregroundColor(.black)
                                .font(.title)
                                .background(Color.yellow)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 1)
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
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
