//
//  ContentView.swift
//  Shared
//
//  Created by Harry Pantaleon on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isDrag = false
    @State private var highlightOffset: [Int] = []
    @State private var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    @State private var gameOver = false
    
    var game = ChessMoveGenerator()
    var ai = ChessAI()
        
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    BoardView()
                    PiecesView (fen: $fen, highlightOffsets: $highlightOffset) { status in
                        switch status {
                        case .drag(let from):
                            isDrag(from: from)
                        case .drop(let from, let to):
                            isDrop(from: from, to: to)
                        }
                    }
                }
                Button("AI"){
                    if let move = ai.getBestMove(game: game) {
                        game.makeMove(move: move)
                        fen = game.generateFen()
                    } else {
                        print("GameOver")
                    }
                }
            }
            .onAppear{
                game.clear()
                game.load(fen: fen)
            }
            if gameOver {
                Rectangle()
                    .fill(.white.opacity(0.1))
                Text("Game Over")
            }
        }
    }
    
    func isDrag(from: Int) {
        let moves = game.generateMoves(SquareOffset: from)
        moves.forEach { m in
            highlightOffset.append(m.moveTo)
        }
    }
    
    func isDrop(from: Int, to: Int) {
        if game.gameOver() {
            print("gameover")
            gameOver = true
            return
        }
        let moves = game.generateMoves(SquareOffset: from)
        var move: ChessMoveGenerator.Move? = nil
        moves.forEach { m in
            if m.moveTo == to {
                move = m
            }
        }
        
        if let m = move {
            game.makeMove(move: m)
        } else {
            return
        }
        
        fen = game.generateFen()
        
        if let aimove = ai.getBestMove(game: game) {
            game.makeMove(move: aimove)
            fen = game.generateFen()
            
        }
        
        if game.gameOver() {
            gameOver = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
