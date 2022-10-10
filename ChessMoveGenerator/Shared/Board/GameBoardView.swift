//
//  ContentView.swift
//  Shared
//
//  Created by Harry Pantaleon on 8/4/22.
//

import SwiftUI
import Chess


struct GameBoardView: View {
    @State private var fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        //@State private var fen = "k4n1n/6P1/8/8/8/8/1p6/N1N4K b - - 0 1"
    @State private var highlightOffset: [Int] = []
    @State private var gameOver = false
    
    //let defaultPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    @StateObject var engine: ChessGameEngine
    
    var p1: ChessPlayer, p2: ChessPlayer
    var history = ChessHistory()
    
    init(engine: ChessGameEngine, player1: ChessPlayer, player2: ChessPlayer) {
        self._engine = StateObject<ChessGameEngine>(wrappedValue: engine)
        self.p1 = player1
        self.p2 = player2
    }
    
    var body: some View {
        VStack {
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
                .onChange(of: engine.fen, perform: { self.fen = $0 })
                .onAppear{
                    //chess.clear()
                    //chess.load(fen: fen)
                    
                    engine.setPlayer(player: p1, color: .white)
                    engine.setPlayer(player: p2, color: .black)
                    engine.startGame()
                }
                
                if gameOver {
                    Rectangle()
                        .fill(.white.opacity(0.1))
                    Text("Game Over")
                }
            }
        }
    }
    
    func isDrag(from: String, piece: Chess.ChessPiece?) {
        highlightOffset = engine.getAvailableOffset(from: from)
    }
    
    func isDrop(from: String, to: String, piece: Chess.ChessPiece?, promotion: Chess.PieceType?) {
        /*
        if chess.gameOver() {
            print("gameover")
            gameOver = true
            return
        }
        */
        
        if let color = piece?.color {
            if color == .white {
                p1.makeMove(move: ChessPlayer.GameMove(from: from, to: to, promotion: .none))
            } else if color == .black {
                p2.makeMove(move: ChessPlayer.GameMove(from: from, to: to, promotion: .none))
            }
        }
    }
}


struct GameBoardView_Previews: PreviewProvider {
    static var previews: some View {
        GameBoardView(engine: .init(), player1: ChessPlayer(), player2: ChessPlayer())
    }
}

