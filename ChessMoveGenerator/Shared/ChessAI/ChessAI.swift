//
//  ChessAI.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/13/22.
//

import Foundation

class ChessAI {
    //var board: [ChessMoveGenerator.ChessPiece?]
    //var gameInstance: ChessMoveGenerator
    
    let pawnEvalWhite =
        [
            [0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
            [5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0],
            [1.0,  1.0,  2.0,  3.0,  3.0,  2.0,  1.0,  1.0],
            [0.5,  0.5,  1.0,  2.5,  2.5,  1.0,  0.5,  0.5],
            [0.0,  0.0,  0.0,  2.0,  2.0,  0.0,  0.0,  0.0],
            [0.5, -0.5, -1.0,  0.0,  0.0, -1.0, -0.5,  0.5],
            [0.5,  1.0, 1.0,  -2.0, -2.0,  1.0,  1.0,  0.5],
            [0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0]
        ]

    

    let knightEval =
        [
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0],
            [-4.0, -2.0,  0.0,  0.0,  0.0,  0.0, -2.0, -4.0],
            [-3.0,  0.0,  1.0,  1.5,  1.5,  1.0,  0.0, -3.0],
            [-3.0,  0.5,  1.5,  2.0,  2.0,  1.5,  0.5, -3.0],
            [-3.0,  0.0,  1.5,  2.0,  2.0,  1.5,  0.0, -3.0],
            [-3.0,  0.5,  1.0,  1.5,  1.5,  1.0,  0.5, -3.0],
            [-4.0, -2.0,  0.0,  0.5,  0.5,  0.0, -2.0, -4.0],
            [-5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0]
        ]

    let bishopEvalWhite = [
        [ -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0],
        [ -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0],
        [ -1.0,  0.0,  0.5,  1.0,  1.0,  0.5,  0.0, -1.0],
        [ -1.0,  0.5,  0.5,  1.0,  1.0,  0.5,  0.5, -1.0],
        [ -1.0,  0.0,  1.0,  1.0,  1.0,  1.0,  0.0, -1.0],
        [ -1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0, -1.0],
        [ -1.0,  0.5,  0.0,  0.0,  0.0,  0.0,  0.5, -1.0],
        [ -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0]
    ]


    let rookEvalWhite = [
        [  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0],
        [  0.5,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  0.5],
        [ -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
        [ -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
        [ -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
        [ -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
        [ -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5],
        [  0.0,   0.0, 0.0,  0.5,  0.5,  0.0,  0.0,  0.0]
    ]


    let evalQueen =
        [
        [ -2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0],
        [ -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0],
        [ -1.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0],
        [ -0.5,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5],
        [  0.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5],
        [ -1.0,  0.5,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0],
        [ -1.0,  0.0,  0.5,  0.0,  0.0,  0.0,  0.0, -1.0],
        [ -2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0]
    ]

    let kingEvalWhite = [

        [ -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
        [ -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
        [ -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
        [ -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0],
        [ -2.0, -3.0, -3.0, -4.0, -4.0, -3.0, -3.0, -2.0],
        [ -1.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -1.0],
        [  2.0,  2.0,  0.0,  0.0,  0.0,  0.0,  2.0,  2.0 ],
        [  2.0,  3.0,  1.0,  0.0,  0.0,  1.0,  3.0,  2.0 ]
    ]
    var pawnEvalBlack: [[Double]]
    var bishopEvalBlack: [[Double]]
    var rookEvalBlack: [[Double]]
    var kingEvalBlack: [[Double]]
    
    var positionCount: Int = 0
    
    init(){
        print("ChessAI INIT")
        
        pawnEvalBlack = pawnEvalWhite.reversed()
        bishopEvalBlack = bishopEvalWhite.reversed()
        rookEvalBlack = rookEvalWhite.reversed()
        kingEvalBlack = kingEvalWhite.reversed()
        
    }
    
    func algebraicToOffset(pgn: String) -> Int {
        /* NEEDS Error Checking for Invalid Pos e.g. i9 */
        let pos = Array(pgn)
        let file = (pos[0].asciiValue! & 0x0f) - 1
        let rank = (8 - (pos[1].asciiValue! & 0x0f)) << 4
        return Int(rank | file)
    }
    
    func evaluateBoard(board: [ChessMoveGenerator.ChessPiece?]) -> Double {
        var totalEvaluation = 0.0
        
        var i = algebraicToOffset(pgn: "a8")
        let lastSquare = algebraicToOffset(pgn: "h1")
        while( i <= lastSquare ){
            defer { i += 1 }
            if i & 0x88 != 0 {
                i += 8
            }
            totalEvaluation = totalEvaluation + getPieceValue(board[i], offset: i)
        }
        return totalEvaluation
    }
    
    func getPieceValue(_ piece: ChessMoveGenerator.ChessPiece?, offset: Int) -> Double {
        guard let piece = piece else {
            return 0
        }
        func getAbsoluteValue (_ piece: ChessMoveGenerator.ChessPiece, x: Int, y: Int) -> Double {
        
            switch piece.type {
            case .Pawn:
                return 10.0 + (piece.color == .white ? pawnEvalWhite[y][x] : pawnEvalBlack[y][x])
            case .Rook:
                return 50.0 + (piece.color == .white ? rookEvalWhite[y][x] : rookEvalBlack[y][x])
            case .Knight:
                return 30.0 + knightEval[y][x]
            case .Bishop:
                return 30.0 + (piece.color == .white ? bishopEvalWhite[y][x] : bishopEvalBlack[y][x])
            case .Queen:
                return 90.0 + evalQueen[y][x]
            case .King:
                return 900.0 + (piece.color == .white ? kingEvalWhite[y][x] : kingEvalBlack[y][x])
            }
        }
        

        let x = (0xf0 & offset) >> 4, y = 0x0f & offset
        let absoluteValue = getAbsoluteValue(piece, x: x, y: y)
        return piece.color == .white ? absoluteValue : -absoluteValue
    }
    
    func getBestMove(game: ChessMoveGenerator) -> ChessMoveGenerator.Move {
        if game.gameOver() {
            print("GAMEOVER")
        }

        positionCount = 0
        let depth = 3 // GET DEPTH
        let d1 = Date.now.timeIntervalSince1970
        let bestMove = minimaxRoot(depth: depth, game: game, isMaximisingPlayer: true)
        
        print("Start:", d1, "Finished:", Date.now.timeIntervalSince1970, "active: ", game.activeColor)
        //let d2 = Date()
        //let moveTime = d2.timeIntervalSinceReferenceDate - d.timeIntervalSinceReferenceDate
        //var positionPerS = positionCount * 1000 / moveTime
        
        print("POSITION COUNT: ", positionCount)
        //print("TIME:", moveTime / 1000)
        //print("POSITION PER S: ", positionPerS)
        return bestMove
    }
}
