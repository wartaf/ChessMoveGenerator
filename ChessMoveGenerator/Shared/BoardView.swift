//
//  DrawBoardView.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 9/7/22.
//

import SwiftUI

struct BoardView: View {
    var body: some View {
        GeometryReader { g in
            let w = min(g.size.width, g.size.height)
            ZStack (alignment: .topLeading){
                VStack(spacing:0){
                    ForEach(0..<8) { i in
                        HStack(spacing:0){
                            ForEach(0..<8) {j in
                                ZStack{
                                Rectangle()
                                    .fill(i % 2 == j % 2 ? .white : .gray)
                                }
                            }
                        }
                    }
                }
            }.frame(width: w, height: w)
        }
    }
}

struct DrawBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
