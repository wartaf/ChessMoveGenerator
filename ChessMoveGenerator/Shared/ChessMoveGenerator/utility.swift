//
//  helper.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/13/22.
//

import Foundation

extension ChessMoveGenerator{
    func algebraic(i: Int) -> String {
        let fileLetter = Array("abcdefgh")
        return "\(fileLetter[getFile(i)])\(8 - getRank(i).rawValue)"
    }
    
    func algebraicToOffset(pgn: String) -> Int {
        /* NEEDS Error Checking for Invalid Pos e.g. i9 */
        let pos = Array(pgn)
        let file = (pos[0].asciiValue! & 0x0f) - 1
        let rank = (8 - (pos[1].asciiValue! & 0x0f)) << 4
        return Int(rank | file)
    }
    func getFile(_ boardOffset: Int) -> Int {
        return boardOffset & 15
    }
    func getRank(_ boardOffset: Int) -> Rank {
        return Rank(rawValue: boardOffset >> 4)!
    }
    func toggleColor(_ color: PieceColor) -> PieceColor{
        return color == .white ? .black : .white
    }
    
    func gameOver() -> Bool {
        return halfMove >= 100 || inCheckmate() || inStalemate() || insufficientMaterial() || inThreefoldRepetition()
    }
}
