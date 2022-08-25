//
//  generateMove.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/13/22.
//

import Foundation

extension ChessMoveGenerator {
    func buildMove(from: Int, to: Int, flags: Int, promotion: PieceType? = nil) -> Move{
        var captured: PieceType? = nil
        var newFlag = flags
        
        if promotion != nil {
            newFlag = flags | BITS.PROMOTION.rawValue
        }
        
        if board[to] != nil {
            captured = board[to]?.type
        } else if flags & BITS.EP_CAPTURE.rawValue != 0  {
            captured = .Pawn
        }
        return Move(moveFrom: from, moveTo: to, pieceType: board[from]!, flag: newFlag, promotion: promotion, captured: captured)
    }
    
    func generateMoves(SquareOffset: Int? = nil) -> [Move] {
        var moves: [Move] = []
        
        func add_move(from: Int, to: Int, flags: Int){
            
            if board[from]?.type == .Pawn && (getRank(to) == .rank8 || getRank(to) == .rank1)  {
                let pieces: [PieceType] = [.Queen, .Rook, .Bishop, .Knight]
                pieces.forEach { pt in
                    moves.append(buildMove(from: from, to: to, flags: flags, promotion: pt))
                }
            } else {
                moves.append(buildMove(from: from, to: to, flags: flags))
            }
        }
        
        var singleSquare = false
        var firstSquare = algebraicToOffset(pgn: "a8")
        var lastSquare = algebraicToOffset(pgn: "h1")

        
        let legal = true
        
        if let SquareOffset = SquareOffset {
            singleSquare = true
            firstSquare = SquareOffset
            lastSquare = SquareOffset
        }
        

        let us = activeColor
        let opponentColor: PieceColor = toggleColor(us)
        
        var i = firstSquare
        
        while( i <= lastSquare ){
            defer { i += 1 }
            
            /* if Outside of board 8x8*/
            if i & 0x88 != 0 {
                i += 7
                continue
            }
            
            let piece = board[i]
            
            if piece == nil || piece?.color != us {
                continue
            }
            
            if piece?.type == .Pawn {
                /* 1 square move non-capture */
                let square = i + pawnOffset[us]![0]
                if board[square] == nil {
                    add_move(from: i, to: square, flags: BITS.NORMAL.rawValue)
                    
                    /* if 1st square is open, check 2nd square*/
                    let square = i + pawnOffset[us]![1]
                    
                    if board[square] == nil {
                        if board[i]?.color == .white && getRank(i) == .rank2 {
                            add_move(from: i, to: square, flags: BITS.BIG_PAWN.rawValue)
                        } else if board[i]?.color == .black && getRank(i) == .rank7 {
                            add_move(from: i, to: square, flags: BITS.BIG_PAWN.rawValue)
                        }
                    }
                }
                
                /* Pawn Capture */
                for j in 2...3 {
                    let square = i + pawnOffset[us]![j]
                    if square & 0x88 != 0 { continue }
                    
                    if board[square] != nil && board[square]?.color == opponentColor {
                        add_move(from: i, to: square, flags: BITS.CAPTURE.rawValue)
                    } else if enPassant == square {
                        add_move(from: i, to: square, flags: BITS.EP_CAPTURE.rawValue)
                    }
                }
            } else { // endif type==Pawn
                
                pieceOffset[piece!.type]?.forEach({ offset in
                    var square = i
                    
                    while (true){
                        square = square + offset
                        if square & 0x88 != 0 { break }
                        
                        if board[square] == nil {
                            add_move(from: i, to: square, flags: BITS.NORMAL.rawValue)
                        } else {
                            if board[square]?.color == us { break }
                            add_move(from: i, to: square, flags: BITS.CAPTURE.rawValue)
                            break
                        }
                        
                        if piece?.type == .Knight || piece?.type == .King { break }
                    }
                })
            }
        }
        
        /* check for castling if: a) we're generating all moves, or b) we're doing
         * single square move generation on the king's square
         */
        if singleSquare != true || lastSquare == kingsPosition[us]! {
            
            /* king-side castling */
            if castlingRights[us]! & BITS.KSIDE_CASTLE.rawValue != 0 {
                let castlingFrom: Int = kingsPosition[us]!
                let castlingTo: Int = castlingFrom + 2
                
                if board[castlingFrom + 1] == nil && board[castlingTo] == nil && attacked(color: opponentColor, square: kingsPosition[us]!) != true &&
                    attacked(color: opponentColor, square: castlingFrom + 1) != true && attacked(color: opponentColor, square: castlingTo) != true {
                    add_move(from: kingsPosition[us]!, to: castlingTo, flags: BITS.KSIDE_CASTLE.rawValue)
                }
            }
            if castlingRights[us]! & BITS.QSIDE_CASTLE.rawValue != 0 {
                let castlingFrom: Int = kingsPosition[us]!
                let castlingTo: Int = castlingFrom - 2
                
                if board[castlingFrom - 1] == nil &&
                    board[castlingFrom - 2] == nil &&
                    board[castlingFrom - 3] == nil &&
                    attacked(color: opponentColor, square: kingsPosition[us]!) != true &&
                    attacked(color: opponentColor, square: castlingFrom - 1) != true &&
                    attacked(color: opponentColor, square: castlingTo) != true {
                    
                    add_move(from: kingsPosition[us]!, to: castlingTo, flags: BITS.QSIDE_CASTLE.rawValue)
                }
                    
            }
            
        }
        
        /* return all pseudo-legal moves (this includes moves that allow the king
         * to be captured)
         */
        if (legal != true) {
          return moves
        }
        
        //moves.forEach { m in
          //  print(m.moveTo)
        //}
        
        /* filter out illegal moves */
        var legalMoves: [Move] = []
        
        moves.forEach { move in
            makeMove(move: move)
            
            if kingAttacked(color: us) != true {
                legalMoves.append(move)
            } //else {
                //print("------>",move.pieceType.type, algebraic(i: move.moveTo))
            //}
            let _ = undoMove()
        }
        
        return legalMoves
    }
}
