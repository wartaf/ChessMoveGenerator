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
    
    
    var chess = ChessGameEngine()
    var p1 = ChessAIPlayer(), p2 = ChessAIPlayer()
    var history = ChessHistory()
    
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
        
        
        let len = moves.count
        for i in 0..<len {
        //moves.forEach { m in
            let m = moves[i]
            //if promotion != nil && m.promotion == promotion
            if m.moveTo == to {
                if promotion != nil {
                    if m.promotion == promotion {
                        //print("prom", m.promotion, promotion)
                        move = m
                        break
                    }
                } else {
                    move = m
                    break
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
