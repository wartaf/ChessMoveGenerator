//
//  ContentView.swift
//  Shared
//
//  Created by Harry Pantaleon on 8/4/22.
//

import SwiftUI
import Chess

struct GameBoardView: View {
    
   // @State private var isDrag = false
    @State private var highlightOffset: [Int] = []
    @State private var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    //@State private var fen = "k4n1n/6P1/8/8/8/8/1p6/N1N4K b - - 0 1"
    @State private var gameOver = false
    //@State private var promotion = ""
    @State private var showPromotion = false
    
    let defaultPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    var game = Chess()
    var ai = ChessAI()
        
    var body: some View {
            ZStack {
                BoardView()
                PiecesView (fen: $fen, highlightOffsets: $highlightOffset) { status in
                    switch status {
                    case .drag(let from, let piece):
                        isDrag(from: from, piece: piece)
                    case .drop(let from, let to, let piece, let promotion):
                        isDrop(from: from, to: to, piece: piece, promotion: promotion)
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
            
            /*
            Button("AI"){
                if let move = ai.getBestMove(game: game) {
                    game.makeMove(move: move)
                    fen = game.generateFen()
                } else {
                    gameOver = true
                }
            }
            .padding(10)
            .border(.gray)

            Button("reset"){
                game.clear()
                game.load(fen: defaultPosition)
                fen = game.generateFen()
                print(game.boardToASCII())
            }
            .padding(10)
            .border(.gray)
             */

    }
    
    func isDrag(from: Int, piece: Chess.ChessPiece?) {
        
        var offset: Set<Int> = [] // should be unique int
        let moves = game.generateMoves(SquareOffset: from)
        
        //print("avail moves count:",moves.count)
        // if pawn and promotion { showPromotionList }
        
        moves.forEach { m in
            
            if m.pieceType.type == .Pawn && m.promotion != nil {
                //promotion = m.color?.rawValue ?? ""
            }
             
            offset.insert(m.moveTo)
        }
        highlightOffset = Array(offset)
    }
    
    func isDrop(from: Int, to: Int, piece: Chess.ChessPiece?, promotion: Chess.PieceType?) {
        if game.gameOver() {
            print("gameover")
            gameOver = true
            return
        }
        
        let moves = game.generateMoves(SquareOffset: from)
        var move: Chess.Move? = nil
        
        moves.forEach { m in
            
            //if promotion != nil && m.promotion == promotion
            if m.moveTo == to {
                if promotion != nil {
                    if m.promotion == promotion {
                        //print("prom", m.promotion, promotion)
                        move = m
                    }
                } else {
                    print("not")
                    move = m
                }
            }
        }
        //promotion = ""
        
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

struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView()
    }
}
