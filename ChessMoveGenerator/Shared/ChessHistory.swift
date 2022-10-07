//
//  ChessHistory.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/6/22.
//

import Foundation

class ChessHistory: GameHistory {
    typealias Player = ChessPlayer
    typealias GameMove = ChessMove
    
    private var moves: [(ChessPlayer, ChessMove)] = []
    
    func pushMove(player: ChessPlayer, move: ChessMove) {
        moves.append((player, move))
    }
    
    func clearAll() {
        moves = []
    }
    
    func printAll(){
        moves.forEach {
            print("player\($0.ID) -> \($1.from) - \($1.to)")
        }
    }
}
