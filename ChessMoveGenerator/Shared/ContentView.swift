//
//  ContentView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/14/22.
//  ...

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            //WelcomeScreen()
            GameBoardView(engine: .init() ,player1: ChessAIPlayer(), player2: ChessAIPlayer())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


