//
//  ContentView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/14/22.
//  ...

import SwiftUI


struct ContentView: View {
    
    private var chessPiece: ChessPiece = .none
    private var chessGame: ChessGameEngine = ChessGameEngine()
    private var p1 = ChessPlayer(ID: 1), p2 = ChessPlayer(ID: 2)
    
    
    var body: some View {
        ZStack {
            GameBoardView()
        }
        .onAppear{
            var history = ChessHistory()
            chessGame.setPlayer(player: p1, color: .white)
            chessGame.setPlayer(player: p2, color: .black)
            chessGame.setGameHistory(history)
            chessGame.startGame()
            for n in 1...20 {
                p1.makeMove(move: ChessMove(from: n , to: n + 1))
                p2.makeMove(move: ChessMove(from: n * n, to: n * n + 2))
            }
            chessGame.endGame()
            history.printAll()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


