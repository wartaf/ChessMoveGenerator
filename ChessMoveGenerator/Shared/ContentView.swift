//
//  ContentView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/14/22.
//  ...

import SwiftUI

struct ContentView: View {
    @State private var showGameMenu = true
    
    private var engine: ChessGameEngine = ChessGameEngine()
    @State private var p1: ChessPlayer = ChessPlayer()
    @State private var p2: ChessPlayer = ChessPlayer()
    
    var body: some View {
        VStack {
            if showGameMenu {
                GameMenuView{(w,b) in
                    if w == true {
                        p1 = ChessPlayer()
                    } else {
                        p1 = ChessAIPlayer()
                    }
                    
                    if b == true {
                        p2 = ChessPlayer()
                    } else {
                        p2 = ChessAIPlayer()
                    }
                    showGameMenu.toggle()
                }
            } else {
                GameBoardView(engine: engine ,player1: p1, player2: p2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


