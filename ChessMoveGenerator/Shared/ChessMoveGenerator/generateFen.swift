//
//  generateFen.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/11/22.
//

import Foundation

extension ChessMoveGenerator {
    func generateFen() -> String {
        var empty: Int = 0
        var fen: String = ""
        
        var i = algebraicToOffset(pgn: "a8")
        let h1 = algebraicToOffset(pgn: "h1")
        while i <= h1 {
            defer {i = i + 1 }
            
            if board[i] == nil {
                empty = empty + 1
            } else {
                if empty > 0 {
                    fen += String(empty)
                    empty = 0
                }
                let color = board[i]!.color
                let piece = board[i]!.type
                
                fen += String( color == .white ? piece.rawValue.uppercased() : piece.rawValue.lowercased() )
            }
            
            if (i + 1) & 0x88 != 0 {
                if empty > 0 {
                    fen += String(empty)
                }
                
                if i != h1 {
                    fen += "/"
                }
                
                empty = 0
                i += 8
            }
        }
        
        var cflags = ""
        if castlingRights[.white]! & BITS.KSIDE_CASTLE.rawValue != 0 { cflags += "K"}
        if castlingRights[.white]! & BITS.QSIDE_CASTLE.rawValue != 0 { cflags += "Q"}
        if castlingRights[.black]! & BITS.KSIDE_CASTLE.rawValue != 0 { cflags += "k"}
        if castlingRights[.black]! & BITS.QSIDE_CASTLE.rawValue != 0 { cflags += "q"}
        
        /* do we have an empty castling flag? */
        if cflags == "" { cflags = "-" }
        let epflags: String = (enPassant == -1) ? "-" : algebraic(i: enPassant)
        
        return [fen, activeColor.rawValue, cflags, epflags, String(halfMove), String(moveNumber)].joined(separator: " ")
    }
}
