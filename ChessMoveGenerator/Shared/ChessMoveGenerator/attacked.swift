//
//  Attacked.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/9/22.
//

import Foundation

extension ChessMoveGenerator {
    func attacked(color: PieceColor, square: Int) -> Bool{
        var i = algebraicToOffset(pgn: "a8")
        let h1 = algebraicToOffset(pgn: "h1")
        while i <= h1 {
            defer {i += 1 }
            if i & 0x88 != 0 {
                i += 7
                continue
            }
            
            /* if empty square or wrong color */
            if board[i] == nil || board[i]?.color != color { continue }
            
            let piece = board[i]!
            let difference = i - square
            let index = difference + 119

            if ATTACKS[index] & (1 << SHIFTS[piece.type]!) != 0 {
                if piece.type == .Pawn {
                    if difference > 0 {
                        if piece.color == .white { return true }
                    } else {
                        if piece.color == .black { return true }
                    }
                    continue
                }
                
                /* if the piece is a knight or a king */
                if piece.type == .King || piece.type == .Knight { return true }
                
                let offset = RAYS[index]
                var j = i + offset
                
                var blocked = false
                while j != square {
                    if board[j] != nil { blocked = true; break }
                    j += offset
                }
                
                if blocked != true { return true }
            }
        }
        return false
    }
    
    func kingAttacked(color: PieceColor) -> Bool {
        return attacked(color: toggleColor(color), square: kingsPosition[color]!)
    }
    
    func inCheck() -> Bool {
        return kingAttacked(color: activeColor)
    }
    
    func inCheckmate() -> Bool {
        return inCheck() && generateMoves().count == 0
    }
    
    func inStalemate() -> Bool {
        return inCheck() != true && generateMoves().count == 0
    }
    
    func insufficientMaterial() -> Bool {
        var pieces: [PieceType: Int] = [:]
        var bishops: [Int] = []
        var numPieces: Int = 0
        var sqColor: Int = 0
        
        var i = algebraicToOffset(pgn: "a8")
        let h1 = algebraicToOffset(pgn: "h1")
        while i <= h1 {
            defer {i += 1 }
            sqColor = (sqColor + 1) % 2
            if i & 0x88 != 0 { i += 7; continue }
            
            //var piece = board[i]
            if let piece = board[i] {
                pieces[piece.type] = pieces.keys.firstIndex(of: piece.type) != nil ? pieces[piece.type]! + 1 : 1
                
                if piece.type == .Bishop {
                    bishops.append(sqColor)
                }
                numPieces += 1
            }
        }
            
        if numPieces == 2 {
            return true
        } else if numPieces == 3 && (pieces[.Bishop]! == 1 || pieces[.Knight]! == 1) {
            return true
        } else if numPieces == pieces[.Bishop]! + 2 {
            var sum = 0
            let len = bishops.count
            for j in 0..<len {
                sum += bishops[j]
            }
            if sum == 0 || sum == len { return true }
        }
        
        return false
    }
    
    
    /** NOT YET IMPLEMENTED **/
    func inThreefoldRepetition() -> Bool {
        /* TODO: while this function is fine for casual use, a better
         * implementation would use a Zobrist key (instead of FEN). the
         * Zobrist key would be maintained in the make_move/undo_move functions,
         * avoiding the costly that we do below.
         */
        
        //var moves: [Move] = []
        //var positions = []
        //var repetition = false
        /*
        while true {
            if let move = undoMove() {
                moves.append(move)
            } else {
                break
            }
        }
        */
        //while true {
            /* remove the last two fields in the FEN string, they're not needed
              * when checking for draw by rep */
            
            
        //}
        return false
    }
}
