//
//  PokemonGameView.swift
//  PokemonQuizApp
//
//  Created by Benny De Bock on 03/01/2022.
//

import SwiftUI

struct PokemonGameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var game: PokemonQuizGame
    var regionName: String = ""
    @State var name: String = ""
    @State var guessed: Bool = false
    @State var gameFinished: Bool = false
    
    var body: some View {
        ZStack{
            GeometryReader { geometry in
                pokemonBody
                    .padding(20)
                    .position(toCenter(in: geometry))
            }
        }
        .background(
            Image("background")
                .asBackgroundModifier()
        )
    }
    
    var pokemonBody: some View {
        LazyVStack {
            if !gameFinished {
                Text("Who's that pokemon?")
                    .font(.title)
                    .foregroundColor(GameConstants.textColor)
                if game.spriteFetchStatus == .fetching {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(width: GameConstants.imageFrameSize, height: GameConstants.imageFrameSize)
                } else if game.spriteFetchStatus == .idle {
                    HStack {
                        OptionalImage(uiImage: game.spriteImage, guessed: guessed)
                    }
                    .frame(width: GameConstants.imageFrameSize, height: GameConstants.imageFrameSize)
                } else {
                    Text("Something went wrong loading the sprite. Try again later")
                        .font(.title)
                        .foregroundColor(GameConstants.textColor)
                }
                    
                    
                
                HStack {
                    TextField("Name", text: $name)
                        .foregroundColor(GameConstants.textColor)
                        .disabled(guessed)
                        .disableAutocorrection(true)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: GameConstants.cornerRadius).fill(GameConstants.lightGreyColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: GameConstants.cornerRadius)
                                .stroke(lineWidth: 2)
                        )
                        .frame(width: GameConstants.textFieldWidth)
                    Button {
                        if guessed {
                            gameFinished = game.gameHasEnded
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
                        .modifier(PokemonButton())
                }
                Text("Score: \(game.highscore)")
                    .foregroundColor(GameConstants.textColor)
            } else {
                Text("Region Completed")
                    .font(.title)
                    .foregroundColor(GameConstants.textColor)
                Text("Score: \(game.highscore)")
                Button("Go back to menu"){
                    reset()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }.onAppear {
            reset()
        }
    }
    
    private func choosePokemon() {
        game.chooseRandomPokemon()
    }
    
    private func guessPokemon() {
        if game.guessPokemon(guess: name) {
            guessed = true
        }
        name = ""
    }
    
    private func reset() {
        gameFinished = false
        guessed = false
        game.resetGame()
    }
    
    private struct GameConstants {
        static let buttonScale: CGFloat = 1.5
        static let cornerRadius: CGFloat = 20.0
        static let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
        static let imageFrameSize: CGFloat = 250.0
        static let textFieldWidth: CGFloat = 300.0
        static let textColor = Color.black
    }
    
    
}



struct PokemonGameView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonGameView()
            .previewDevice("iPhone 11 Pro Max")
    }
}
