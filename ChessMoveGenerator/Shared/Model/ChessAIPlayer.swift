//
//  ChessAIPlayer.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/7/22.
//

import Foundation

class ChessAIPlayer: ChessPlayer {
    
    private weak var game: ChessGameEngine?
    
    private lazy var chessAI = ChessAI()
    
    override func notifier(fen: String) {
        // check if valid FEN
        // check if its really AI Turn
        
        if let bestMove = chessAI.getBestMove(fen: fen) {
            let from = algebraic(i: bestMove.moveFrom)
            let to = algebraic(i: bestMove.moveTo)
            var promotion: ChessPiece = .none
            
            if let prom = bestMove.promotion {
                //print(prom.rawValue)
                let val = prom.rawValue
                promotion = ChessPiece.from(string: val)
            }
            
            //print(bestMove.promotion, promotion)
            
            let move = GameMove(from: from, to: to, promotion: promotion)
            //print(move)
            
            self.makeMove(move: move)
            
        }
    }
    
    override func makeMove(move: GameMove) -> GameStatus {
        return game?.makeMove(player: self, move: move) ?? .failed
    }
    
    override func setGame(game: ChessPlayer.Engine) {
        self.game = game
    }
    
    func algebraic(i: Int) -> String {
        let fileLetter = Array("abcdefgh")
        return "\(fileLetter[(i & 15)])\(8 - (i >> 4))"
    }
}
