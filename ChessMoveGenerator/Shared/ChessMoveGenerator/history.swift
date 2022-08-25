//
//  ChessHistory.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/6/22.
//

import Foundation

extension ChessMoveGenerator{
    struct History{
        let move: Move
        let kingsPosition: [PieceColor: Int]
        let turn: PieceColor
        let castlingRights: [PieceColor: Int]
        let enPassant: Int
        let halfMove: Int
        let moveNumber: Int
    }
    
    func push(move: Move){
        history.append(
            History(
                move: move,
                kingsPosition: kingsPosition,
                turn: activeColor,
                castlingRights: castlingRights,
                enPassant: enPassant,
                halfMove: halfMove,
                moveNumber: moveNumber
            )
        )
    }
    
    
}
