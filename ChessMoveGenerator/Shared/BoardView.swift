//
//  BoardView.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/23/22.
//

import SwiftUI

struct BoardView: View {
    private var game: ChessMoveGenerator = ChessMoveGenerator()
    private var ai: ChessAI = ChessAI()
    
    @State private var tapPosition: CGSize = .zero
    @State private var availMoves: [ChessMoveGenerator.Move] = []
    @State private var pieces: [MyPiece] = []
    
    var body: some View {
        VStack {
            GeometryReader { g in
                let w = g.size.width
                let w8 = w / 8
                ZStack (alignment:.topLeading){
                    DrawBoardView(tapPosition: $tapPosition)
                        .frame(width: w, height: w)
                    ForEach(availMoves, id:\.moveTo) { m in
                        DrawHightlightView()
                            .offset(offsetToXY(o: m.moveTo,multiple:  w8))
                            .onTapGesture {
                                makeMove(m)
                            }
                    }
                    let cnt = pieces.count
                    ForEach(0..<cnt, id: \.self) { i in
                        if pieces[i].offset != -1 {
                        DrawPieceView(piece: pieces[i].piece)
                            .offset(offsetToXY(o: pieces[i].offset, multiple:  w8))
                            .onTapGesture {
                               tapPiece(pieces[i])
                            }
                        }
                    }
                }
            }
            Button("Move"){
                withAnimation{
                pieces[0].offset = 32
                }
                
            }
            
            Text("\(tapPosition.width), \(tapPosition.height)")
        }
        .onAppear{
            updatePieces()
            //print(pieces)
        }
    }
    
    func makeMove(_ move: ChessMoveGenerator.Move) {
        if game.gameOver() { return }
        movePiece(move)
        let bestMove = ai.getBestMove(game: game)
        movePiece(bestMove)
    }
    
    func movePiece(_ move: ChessMoveGenerator.Move){
        print(move)
        game.makeMove(move: move)
        for i in 0..<pieces.count {
            if pieces[i].offset == move.moveTo {
                withAnimation {
                    pieces[i].offset = -1
                }
            }
            if pieces[i].offset == move.moveFrom {
                availMoves = []
                withAnimation(.easeInOut){
                    pieces[i].offset = move.moveTo
                }
            }

        }
    }
    
    func tapPiece(_ p: MyPiece) {
        //print("tap")
        let moves = game.generateMoves(SquareOffset: p.offset)
        availMoves = []
        moves.forEach { m in
            availMoves.append(m)
        }
        
    }
    
    func offsetToXY(o: Int, multiple: Double = 1.0) -> CGSize {
        let x = o % 16
        let y = o / 16
        return CGSize(width: Double(x) * multiple, height: Double(y) * multiple)
    }
    
    func updatePieces(){
        let cnt = game.board.count
        for i in 0..<cnt {
            if let piece = game.board[i] {
                pieces.append(MyPiece(piece: piece, offset: i))
            }
        }
    }
    
    struct MyPiece{
        let piece: ChessMoveGenerator.ChessPiece
        var offset: Int
    }
}


struct DrawPieceView: View {
    let piece: ChessMoveGenerator.ChessPiece?
    var body: some View {
        GeometryReader{ g in
            let w = g.size.width / 8
            let imgName = (piece?.color.rawValue ?? "") + (piece?.type.rawValue.lowercased() ?? "empty")
            Image(imgName)
                .resizable()
                .frame(width: w, height: w)
        }
    }
}

struct DrawHightlightView: View {
    var body: some View {
        GeometryReader{ g in
            let w = g.size.width / 8
            Rectangle()
                .fill(.yellow)
                .frame(width: w , height: w)
                .opacity(0.2)
                .overlay{
                    Rectangle()
                        .strokeBorder(.yellow,lineWidth: 6)
                        .opacity(0.2)
                }
        }
    }
}

struct DrawBoardView: View {
    @Binding var tapPosition: CGSize
    var body: some View {
        VStack(spacing:0){
            ForEach(0..<8) { i in
                HStack(spacing:0){
                    ForEach(0..<8) {j in
                        ZStack{
                        Rectangle()
                            .fill(i % 2 == j % 2 ? .white : .gray)
                        //Text("\((i * 16) + j)")
                        }
                    }
                }
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
