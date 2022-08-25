//
//  ChessBoardView.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/17/22.
//

import SwiftUI

struct ChessBoardView: View {
    @State private var fen: String = "rnb1k2r/pppp1ppp/7n/1q2p3/1b2P3/5N1Q/PPPP1PPP/RNB1K2R w KQkq - 0 8"
    @State private var board: [ChessPieceView] = Array(repeating: ChessPieceView(piece: nil, offset: -1), count: 128)
    @State private var screenWidth: Double = 0
    @State private var offset: CGSize = .zero
    @State private var hover: Bool = false
    
    var body: some View {
        VStack {
        GeometryReader{ geo in
                ZStack {
                    VStack(spacing:0){ // DRAW W/B BOARD
                        ForEach(0..<8) { j in
                            HStack(spacing: 0){
                                ForEach(0..<8) { i in
                                    Rectangle()
                                        .fill(i % 2 == j % 2 ? .brown : .gray)
                                        .padding(0)
                                        .frame(width: geo.size.width / 8, height: geo.size.width / 8)
                                }
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.width)
                    
                    VStack(spacing:0){ // PUT PIECE's
                        ForEach(0..<8) { j in
                            HStack(spacing: 0){
                                ForEach(0..<8) { i in
                                    board[(j * 16) + i]
                                }
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.width)
                }
                .onAppear{
                    loadFen()
            }
            }
        }
        .frame(width: 200)
    }
    
    func pieceHasMove(from: Int, to: Int) {
        print(from, to)
        if to & 0x88 != 0 { return }
        //board.swapAt(from, to)
        let bt = board[to]
        let fr = board[from]
        board[from] = ChessPieceView(piece: bt.piece, offset: to, move: pieceHasMove)
        board[to] = ChessPieceView(piece: fr.piece, offset: from, move: pieceHasMove)
    }
    
    func loadFen(){
        let tokens = fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        
        position.forEach { piece in
            if piece == "/" {
                square += 8
            } else if let emptyPiece = Int(String(piece)) {
                square += emptyPiece
            } else {
                let color: ChessMoveGenerator.PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = ChessMoveGenerator.PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                let piece = ChessMoveGenerator.ChessPiece(type: pieceType, color: color)
                board[square] = ChessPieceView(piece: piece, offset: square, move: pieceHasMove)
                square += 1
            }
        }
    }
}

struct ChessBoardView_Previews: PreviewProvider {
    static var previews: some View {
        ChessBoardView()
    }
}
