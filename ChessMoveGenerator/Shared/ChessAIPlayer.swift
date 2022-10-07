//
//  ChessAIPlayer.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/7/22.
//

import Foundation

class ChessAIPlayer: ChessPlayer {
    
    private weak var game: ChessGameEngine?
    
    override func notifier() {
        if let fen = self.game?.fen {
            if let ai = ChessAI().getBestMove(fen: fen) {
                
                let from = algebraic(i: ai.moveFrom)
                let to = algebraic(i: ai.moveTo)
                var promotion: ChessPiece = .none
                if let prom = ai.promotion {
                    promotion = ChessPiece.from(string: prom.rawValue)
                }
                let move = ChessPlayer.GameMove(from: from, to: to, promotion: promotion)
                self.makeMove(move: move)
            }
        } else {
            print("ERROR FEN String")
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
