//
//  ChessMove.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/4/22.
//

import Foundation

class ChessMoveGenerator{
    
    var board: [ChessPiece?]
    var activeColor: PieceColor
    var castlingRights: [PieceColor: Int] = [.white: 0, .black: 0]
    var enPassant: Int = -1 // Board Position
    var halfMove: Int = 0
    var moveNumber: Int = 0
    
    var kingsPosition: [PieceColor: Int] = [.white: -1, .black: -1]
    
    let pawnOffset: [PieceColor: [Int]] = [ .white: [-16, -32, -17, -15], .black: [16, 32, 17, 15] ]
    
    let pieceOffset: [PieceType: [Int]] = [
        .Knight: [-18, -33, -31, -14,  18, 33, 31,  14],
        .Bishop: [-17, -15,  17,  15],
        .Rook: [-16,   1,  16,  -1],
        .Queen: [-17, -16, -15,   1,  17, 16, 15,  -1],
        .King: [-17, -16, -15,   1,  17, 16, 15,  -1]
    ]
    let SYMBOLS = "pnbrqkPNBRQK"
    
    var rooksPosition: [PieceColor: [[String: Int]]] = [ //a1=112, h1=119, a8=0, h8=7
        PieceColor.white: [
            ["square": 112, "flag": BITS.QSIDE_CASTLE.rawValue],
            ["square": 119, "flag": BITS.KSIDE_CASTLE.rawValue]
        ],
        PieceColor.black: [
            ["square": 0, "flag": BITS.QSIDE_CASTLE.rawValue],
            ["square": 7, "flag": BITS.KSIDE_CASTLE.rawValue]
        ]
    ]

    var history: [History] = []
    
    let defaultPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    init (fen: String){
        board = Array<ChessPiece?>(repeating: nil, count: 128)
        activeColor = .white
        self.load(fen: fen == "" ? self.defaultPosition : fen)
    }
    
    convenience init() {
        self.init(fen: "")
    }
    
    func putPiece(piece: ChessPiece, square: Int){
        
        guard let _ = SYMBOLS.firstIndex(of: Character(piece.type.rawValue)) else { print("not valid piece"); return }
        
        if (0x88 & square) != 0 { return } // Check if within chessboard square
        
        if ( piece.type == .King ) {
            if kingsPosition[piece.color] == -1 {
                //print(kingsP,"----")
                kingsPosition[piece.color] = square
            } else {
                return
            }
        }
        board[square] = ChessPiece(type: piece.type, color: piece.color)
    }
    
    
    var ATTACKS: [Int] = [
      20, 0, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0, 0,20, 0,
       0,20, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0,20, 0, 0,
       0, 0,20, 0, 0, 0, 0, 24,  0, 0, 0, 0,20, 0, 0, 0,
       0, 0, 0,20, 0, 0, 0, 24,  0, 0, 0,20, 0, 0, 0, 0,
       0, 0, 0, 0,20, 0, 0, 24,  0, 0,20, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0,20, 2, 24,  2,20, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0, 2,53, 56, 53, 2, 0, 0, 0, 0, 0, 0,
      24,24,24,24,24,24,56,  0, 56,24,24,24,24,24,24, 0,
       0, 0, 0, 0, 0, 2,53, 56, 53, 2, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0, 0,20, 2, 24,  2,20, 0, 0, 0, 0, 0, 0,
       0, 0, 0, 0,20, 0, 0, 24,  0, 0,20, 0, 0, 0, 0, 0,
       0, 0, 0,20, 0, 0, 0, 24,  0, 0, 0,20, 0, 0, 0, 0,
       0, 0,20, 0, 0, 0, 0, 24,  0, 0, 0, 0,20, 0, 0, 0,
       0,20, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0,20, 0, 0,
      20, 0, 0, 0, 0, 0, 0, 24,  0, 0, 0, 0, 0, 0,20
    ]
    
    var RAYS: [Int] = [
       17,  0,  0,  0,  0,  0,  0, 16,  0,  0,  0,  0,  0,  0, 15, 0,
        0, 17,  0,  0,  0,  0,  0, 16,  0,  0,  0,  0,  0, 15,  0, 0,
        0,  0, 17,  0,  0,  0,  0, 16,  0,  0,  0,  0, 15,  0,  0, 0,
        0,  0,  0, 17,  0,  0,  0, 16,  0,  0,  0, 15,  0,  0,  0, 0,
        0,  0,  0,  0, 17,  0,  0, 16,  0,  0, 15,  0,  0,  0,  0, 0,
        0,  0,  0,  0,  0, 17,  0, 16,  0, 15,  0,  0,  0,  0,  0, 0,
        0,  0,  0,  0,  0,  0, 17, 16, 15,  0,  0,  0,  0,  0,  0, 0,
        1,  1,  1,  1,  1,  1,  1,  0, -1, -1,  -1,-1, -1, -1, -1, 0,
        0,  0,  0,  0,  0,  0,-15,-16,-17,  0,  0,  0,  0,  0,  0, 0,
        0,  0,  0,  0,  0,-15,  0,-16,  0,-17,  0,  0,  0,  0,  0, 0,
        0,  0,  0,  0,-15,  0,  0,-16,  0,  0,-17,  0,  0,  0,  0, 0,
        0,  0,  0,-15,  0,  0,  0,-16,  0,  0,  0,-17,  0,  0,  0, 0,
        0,  0,-15,  0,  0,  0,  0,-16,  0,  0,  0,  0,-17,  0,  0, 0,
        0,-15,  0,  0,  0,  0,  0,-16,  0,  0,  0,  0,  0,-17,  0, 0,
      -15,  0,  0,  0,  0,  0,  0,-16,  0,  0,  0,  0,  0,  0,-17
    ]

    var SHIFTS: [PieceType: Int] = [ .Pawn: 0, .Knight: 1, .Bishop: 2, .Rook: 3, .Queen: 4, .King: 5 ]
}
