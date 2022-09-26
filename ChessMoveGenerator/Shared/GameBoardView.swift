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
    @State private var fen = "k4n1n/6P1/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 1"
    @State private var gameOver = false
    @State private var promotion = ""
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
                    case .drop(let from, let to, let piece):
                        isDrop(from: from, to: to, piece: piece)
                    }
                }
                .onAppear{
                    game.clear()
                    game.load(fen: fen)
                }
                
                PromotionView(piece: $promotion){ p in
                    //isDrop(from: <#T##Int#>, to: <#T##Int#>, piece: <#T##Chess.ChessPiece?#>)
                    print(p)
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
                promotion = m.color?.rawValue ?? ""
            }
             
            offset.insert(m.moveTo)
        }
        highlightOffset = Array(offset)
    }
    
    func isDrop(from: Int, to: Int, piece: Chess.ChessPiece?) {
        if game.gameOver() {
            print("gameover")
            gameOver = true
            return
        }
        
        let moves = game.generateMoves(SquareOffset: from)
        var move: Chess.Move? = nil
        
        //ADD THIS PROMOTION PIECE SELECTION
        /*
        if piece?.type == .Pawn && promotion == "" {
            if piece?.color == .white && game.getRank(to) == .rank8 {
                promotion = "w"
                print("white Promotion")
                return
            }
            else if piece?.color == .black && game.getRank(to) == .rank1 {
                promotion = "b"
                print("black promotion")
                return 
            }
        }
        */
        
        moves.forEach { m in
            if m.moveTo == to {
                if promotion != "" && m.promotion == .init(rawValue: promotion) {
                    move = m
                } else {
                    move = m
                }
            }
        }
        promotion = ""
        
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
