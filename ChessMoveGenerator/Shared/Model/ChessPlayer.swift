//
//  ChessPlayer.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/6/22.
//

import Foundation
import Chess

class ChessPlayer: GamePlayer {
    typealias GameMove = ChessMove
    typealias Engine = ChessGameEngine
    
    var ID: Int = 0
    private weak var game: Engine?
    
    init (ID: Int? = nil){
        if let id = ID {
            self.ID = id
        } else {
            self.ID = Int.random(in: 1..<100)
        }
    }
    
    static func == (lhs: ChessPlayer, rhs: ChessPlayer) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    func setGame(game: Engine) {
        self.game = game
    }
    
    func makeMove(move: GameMove) -> GameStatus {
        return game?.makeMove(player: self, move: move) ?? .failed
    }
    
    func surrender() -> GameStatus {
        return game?.endGame(by: self) ?? .failed
    }
    
    func notifier(fen: String) {
    }
}
