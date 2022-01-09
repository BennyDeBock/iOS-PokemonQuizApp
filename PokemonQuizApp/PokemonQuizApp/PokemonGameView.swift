//
//  PokemonGameView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import SwiftUI

struct PokemonGameView: View {
    @ObservedObject var game: PokemonQuizGame
    @State var name: String = ""
    @State var guessed: Bool = false
    @State var gameFinished: Bool = false
    
    var body: some View {
        pokemonBody
            .padding(20)
            .background(
                ZStack{
                    Color.red.ignoresSafeArea()
                    Image("background")
                        .asBackgroundModifier()
                }
            )
    }
    
    var pokemonBody: some View {
        LazyVStack {
            if !gameFinished {
                Text("Who's that pokemon?")
                    .font(.title)
                
                HStack {
                    OptionalImage(uiImage: game.spriteImage, guessed: guessed)
                }.frame(width: 250, height: 250)
                
                HStack {
                    TextField("Name", text: $name)
                        .disabled(guessed)
                        .disableAutocorrection(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: GameConstants.cornerRadius).fill(GameConstants.lightGreyColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: GameConstants.cornerRadius)
                                .stroke(lineWidth: 2)
                        )
                        .frame(width: 300)
                    Button {
                        if guessed {
                            choosePokemon()
                            guessed = false
                        } else {
                            guessPokemon()
                        }
                        
                    } label: {
                        if guessed {
                            Image(systemName: "arrowtriangle.right")
                                .scaleEffect(GameConstants.buttonScale)
                        } else {
                            Image(systemName: "checkmark")
                                .scaleEffect(GameConstants.buttonScale)
                        }
                    }
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.yellow)
                        .cornerRadius(GameConstants.cornerRadius)
                        .shadow(color: .black, radius: 1)
                }
            }
        }.onAppear {
            game.chooseRandomPokemon()
        }
    }
    
    func choosePokemon() {
        game.chooseRandomPokemon()
    }
    
    func guessPokemon() {
        if game.guessPokemon(guess: name) {
            guessed = true
        }
        name = ""
    }
    
    
    private struct GameConstants {
        static let buttonScale: CGFloat = 1.5
        static let cornerRadius: CGFloat = 20.0
        static let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
    }
    
    
}



struct PokemonGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = PokemonQuizGame()
        PokemonGameView(game: game)
            .previewDevice("iPhone 11 Pro Max")
    }
}
