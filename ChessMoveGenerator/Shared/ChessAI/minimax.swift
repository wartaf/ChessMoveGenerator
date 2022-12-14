//
//  minimax.swift
//  Chess
//
//  Created by Harry Pantaleon on 8/14/22.
//

import Foundation
import Chess

extension ChessAI {
    
    func minimaxRootW(depth: Int, game: Chess, isMaximisingPlayer: Bool) -> Chess.Move? {
        let newGameMoves = game.generateMoves()
        var bestMove = -9999.0
        var bestMoveFound: Chess.Move? = nil

        for move in newGameMoves {
            game.makeMove(move: move)
            let value = minimax(depth: depth - 1, game: game, alpha: -10000.0, beta: 10000.0, isMaximisingPlayer: !isMaximisingPlayer)
            let _ = game.undoMove()

            //print(bestMoveFound?.SAN ?? "nil", bestMove)
            if value >= bestMove {
                bestMove = value
                bestMoveFound = move
            }
        }

        return bestMoveFound
    }
    
    func minimaxRootB (depth: Int, game: Chess, isMaximisingPlayer: Bool) -> Chess.Move? {
        let newGameMoves = game.generateMoves()
        var bestMove = 9999.0
        var bestMoveFound: Chess.Move? = nil

        for move in newGameMoves {
            game.makeMove(move: move)
            let value = minimax(depth: depth - 1, game: game, alpha: -10000.0, beta: 10000.0, isMaximisingPlayer: isMaximisingPlayer)
            let _ = game.undoMove()

            //print(bestMoveFound?.SAN ?? "nil", bestMove)
            if value <= bestMove {
                bestMove = value
                bestMoveFound = move
            }
        }

        return bestMoveFound
    }
    
    func minimax(depth: Int, game: Chess, alpha: Double, beta: Double, isMaximisingPlayer: Bool) -> Double {
        positionCount += 1
        if depth == 0 {
            let eval = evaluateBoard(board: game.board)
            return -eval
        }
        
        let newGameMoves = game.generateMoves()
        
        var alpha = alpha, beta = beta
        
        if isMaximisingPlayer {
            var bestMove = -9999.0
            for move in newGameMoves {
                game.makeMove(move: move)
                bestMove = max(bestMove, minimax(depth: depth - 1, game: game, alpha: alpha, beta: beta, isMaximisingPlayer: !isMaximisingPlayer))
                let _ = game.undoMove()
                
                alpha = max(alpha, bestMove)
                if beta <= alpha { return bestMove }
            }
            return bestMove
        } else {
            var bestMove = 9999.0
            for move in newGameMoves {
                game.makeMove(move: move)
                bestMove = min(bestMove, minimax(depth: depth - 1, game: game, alpha: alpha, beta: beta, isMaximisingPlayer: !isMaximisingPlayer))
                let _ = game.undoMove()
                
                beta = min(beta, bestMove)
                if beta <= alpha { return bestMove }
            }
            return bestMove
        }
    }
}
