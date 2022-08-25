//
//  TESTING.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/20/22.
//

import SwiftUI

struct TESTING: View {
    @State private var board: [Piece] = Array(repeating: .default, count: 64)
    
    var body: some View {
        VStack {
            VStack {
                Text("Hello, World!")
                    .gesture(TapGesture()
                        .onEnded({
                            print("Text")
                        })
                    )
            }
            
            /*.highPriorityGesture(
                TapGesture()
                    .onEnded { _ in
                        print("VStack tapped")
                    }
            )*/
            GeometryReader { g in
                ZStack{
                    BoardBGView()

                    ForEach(0..<64){ i in
                        PieceView(piece: $board[i])
                            .onAppear{
                                withAnimation {
                                    board[i].pos = offsetToCGPoint(i: i)
                                    board[i].pos.x = ( g.size.width / 8 ) * board[i].pos.x
                                    board[i].pos.y = ( g.size.width / 8 ) * board[i].pos.y
                                }
                            }
                    }
                }
            }
            VStack(spacing: 0){
                ForEach(0..<8) { i in
                    HStack(spacing: 0){
                        ForEach(0..<8) { j in
                            PieceBoxView(piece: board[(i * 8) + j], onDrag: { p in
                                print((p.y * 8) + p.x)
                            })
                        }
                    }
                }
            }
            Button("Ch Val"){
                withAnimation {
                    fenToBoard(fen: "rnb1k2r/pppp1ppp/7n/1q2p3/1b2P3/5N1Q/PPPP1PPP/RNB1K2R w KQkq - 0 8")
                }
            }
            Button("Ch Val2"){
                withAnimation {
                    fenToBoard(fen: "rnb1k2r/p2p1ppp/7n/1q2p3/1b2P3/Q5N1/PPPP1PPP/RNB1K2R w KQkq - 0 8")
                }
            }
        }
        .onAppear{
            fenToBoard(fen: "rnb1k2r/pppp1ppp/7n/1q2p3/1b2P3/5N1Q/PPPP1PPP/RNB1K2R w KQkq - 0 8")
        }
    }
    
    func fenToBoard(fen: String){
        let tokens = fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        
        position.forEach { piece in
            if piece == "/" {
                //square += 8
            } else if let emptyPiece = Int(String(piece)) {
                board[square] = .default
                square += emptyPiece
            } else {
                board[square].color = piece.asciiValue! < 97 ? true : false
                board[square].type = String(piece)
                square += 1
            }
        }
    }
    
    func offsetToCGPoint(i: Int) -> CGPoint {
        let x = Int(i % 8)
        let y = Int(i / 8)
        return CGPoint(x: x, y: y)
    }
}

struct PieceBoxView: View {
    var piece: Piece
    var onDrag: (_ point: CGPoint) -> ()
    @State private var  ofs: CGSize = .zero
    var body: some View {
        GeometryReader{g in
            Rectangle()
                .opacity(0.01)
                .frame(width: g.size.width, height: g.size.height)
                .border(.green)
                .offset(ofs)
                .gesture(
                    DragGesture()
                    .onChanged({ val in
                        ofs = val.translation
                        let toX = floor(val.location.x / g.size.width),toY = floor(val.location.y / g.size.height)
                        //self.onDrag(toX, toY)
                        self.onDrag(CGPoint(x: toX, y: toY))
                        
                    })
                    .onEnded({ val in
                        //let toX = floor(val.location.x / g.size.width),toY = floor(val.location.y / g.size.height)
                        //print(toX, toY)
                        //self.move(offset, offset + Int((toY * 16) + toX))
                        //print("\(String(Array("abcdefgh")[Int(fromX + toX)]))\(8 - Int(fromY + toY))")
                        ofs = CGSize.zero
                    })
                )
            //piece()
        }
    }
    
    
}

struct PieceView: View {
    @Binding var piece: Piece
    @State private var offset: CGSize = .zero
    var body: some View {
        if piece.type != "" {
        GeometryReader { g in
            /*
            Rectangle()
                .fill(.blue)
                .frame(width: 50, height: 50)
                
            */
                Text("\(piece.type)")
                .background(piece.color ? .white : .black)
                .foregroundColor(!piece.color ? .white : .black)
                .position(piece.pos)
                .frame(width: g.size.width, height: g.size.width)
                .offset(offset)
                
                .gesture(DragGesture()
                    .onChanged({ v in
                        //offset.width = v.translation.width + drag.width
                        //offset.height = v.translation.height + drag.height
                        offset = v.translation
                    })
                    .onEnded({ v in
                        //drag = offset
                        offset = .zero
                    })
                )
            }
            
        }
    }
}

struct Piece {
    static let `default` = Piece(type: "", color: false, pos: .zero)
    var type: String, color: Bool, pos: CGPoint
}

struct TESTING_Previews: PreviewProvider {
    static var previews: some View {
        TESTING()
    }
}

struct BoardBGView: View {
    var body: some View {
        GeometryReader { g in
            VStack(spacing: 0){
            ForEach(0..<8) { i in
                    HStack(spacing: 0){
                    ForEach(0..<8) { j in
                            Rectangle()
                                .fill(i % 2 == j % 2 ? .brown : .gray)
                                .padding(0)
                                .frame(width: g.size.width / 8, height:  g.size.width / 8)
                        }
                    }
                }
            }
        }
    }
}
