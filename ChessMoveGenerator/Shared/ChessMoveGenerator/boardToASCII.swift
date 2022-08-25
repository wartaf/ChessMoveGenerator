//
//  boardToASCII.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/13/22.
//

import Foundation

extension ChessMoveGenerator {
    func boardToASCII() -> String {
        var s = "   +------------------------+\n"
        var i = algebraicToOffset(pgn: "a8")
        let h1 = algebraicToOffset(pgn: "h1")
        while i <= h1 {
            defer { i = i + 1 }
            
            /* display the rank */
            if getFile(i) == 0 {
                s += " " + String(8 - getRank(i).rawValue) + " |"
            }
            
            /* empty piece */
            if board[i] == nil {
                s += " . "
            } else {
                let piece = board[i]!.type
                let color = board[i]!.color
                let symbol = (color == .white) ? piece.rawValue.uppercased() : piece.rawValue.lowercased()
                s += " " + symbol + " "
            }
            
            if (i + 1) & 0x88 != 0 {
                s += "|\n"
                i += 8
            }
        }
        s += "   +------------------------+\n"
        s += "     a  b  c  d  e  f  g  h\n"
        return s
    }
}
