//
//  load.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/13/22.
//

import Foundation

extension ChessMoveGenerator {
    
    func load(fen: String){
        let tokens = fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        
        position.forEach { piece in
            if piece == "/" {
                square += 8
            } else if let emptyPiece = Int(String(piece)) {
                square += emptyPiece
            } else {
                let color: PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                
                putPiece(piece: ChessPiece(type: pieceType, color: color), square: square)
                square += 1
            }
        }

        /* Active Color who's to turn */
        activeColor = PieceColor(rawValue: String(tokens[1]))!
        
        /* Castling Available */
        if tokens[2].firstIndex(of: "K") != nil {
            castlingRights[.white] = castlingRights[.white]! | BITS.KSIDE_CASTLE.rawValue
        }
        if tokens[2].firstIndex(of: "Q") != nil {
            castlingRights[.white] = castlingRights[.white]! | BITS.QSIDE_CASTLE.rawValue
        }
        if tokens[2].firstIndex(of: "k") != nil {
            castlingRights[.black] = castlingRights[.black]! | BITS.KSIDE_CASTLE.rawValue
        }
        if tokens[2].firstIndex(of: "q") != nil {
            castlingRights[.black] = castlingRights[.black]! | BITS.QSIDE_CASTLE.rawValue
        }
        
        if tokens[3] == "-" {
            self.enPassant = -1
        } else {
            self.enPassant = algebraicToOffset(pgn: String(tokens[3]))
        }
        
        self.halfMove = Int(tokens[4])!
        self.moveNumber = Int(tokens[5])!
    }
    
    func clear() {
        board = Array<ChessPiece?>(repeating: nil, count: 128)
        kingsPosition = [.white: -1, .black: -1]
        activeColor = .white;
        castlingRights = [.white: 0, .black: 0]
        enPassant = -1
        halfMove = 0
        moveNumber = 0
        history = []
        //header = {};
        //update_setup(generate_fen());
    }
}
