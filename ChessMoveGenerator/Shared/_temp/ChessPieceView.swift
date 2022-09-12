//
//  ChessPieceView.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/18/22.
//

import SwiftUI

struct ChessPieceView: View {
    let piece: ChessMoveGenerator.ChessPiece?
    let offset: Int
    var move: ((_ offsetFrom: Int, _ offsetTo: Int) -> ())
    
    init(piece: ChessMoveGenerator.ChessPiece?, offset: Int, move: ((_ x: Int, _ y: Int) -> ())? = nil) {
        self.piece = piece
        self.offset = offset
        self.move = move ?? { _, _ in return }
    }
    //@Binding var move: ChessMoveGenerator.Move
    @State private var ofs = CGSize.zero

    @State private var global: CGPoint = .zero
    @State private var screen: CGSize  = .zero
    var body: some View {
        GeometryReader { g in
            Text("\(piece?.type.rawValue ?? " ")")
                .foregroundColor(piece?.color == . white ? .white : .black)
                .offset(ofs)
                .frame(width: g.size.width, height: g.size.width)
                .contentShape(Rectangle())
                //.position(x: 0, y: 0)
                .gesture(
                    DragGesture()
                    .onChanged({ val in
                        ofs = val.translation
                        //global = g.frame(in: CoordinateSpace.global).origin
                        //screen = g.size

                    })
                    .onEnded({ val in
                        //print(global, local, screen)
                        //let fromX = floor(global.x / screen.width), fromY = floor(global.y / screen.width)
                        let toX = floor(val.location.x / g.size.width),toY = floor(val.location.y / g.size.height)
                        
                        //self.move(Int(toX), Int(toY))
                        print(toX, toY)
                        self.move(offset, offset + Int((toY * 16) + toX))
                        //print("\(String(Array("abcdefgh")[Int(fromX + toX)]))\(8 - Int(fromY + toY))")
                        ofs = CGSize.zero
                    })
                )
        }
    }
}

struct ChessPieceView_Previews: PreviewProvider {
    static var previews: some View {
        ChessPieceView(piece: nil, offset: -1)
    }
}
