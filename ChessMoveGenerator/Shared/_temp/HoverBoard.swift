//
//  HoverBoard.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/22/22.
//

import SwiftUI

struct HoverBoard: View {
    private var game: ChessMoveGenerator = ChessMoveGenerator()
    private var ai: ChessAI = ChessAI()
    @State private var availableMoves: [ChessMoveGenerator.Move] = []
    @State private var activeOffset: Int?
    @State private var pieces: Int = 0
    
    var body: some View {
        VStack {
            GeometryReader { g in
                let width = g.size.width / 8
                //VStack(spacing:0){
                ForEach(0..<8){ i in
                    //HStack(spacing:0){
                    ForEach(0..<8){ j in
                        let ofs = XYtoOffset(x: j, y: i)
                        //let xy = offsetToXY(o: ofs)
                        ZStack(alignment: .center){
                            Rectangle()
                                .fill(i % 2 == j % 2 ? .white : .gray)
                                
                            let imgName = (game.board[ofs]?.color.rawValue ?? "") + (game.board[ofs]?.type.rawValue.lowercased() ?? "empty")
                            Image(imgName)
                                .resizable()
                                .onTapGesture {
                                    tapSquare(ofs)
                                }
                            if inAvailableMoves(ofs) {
                                Rectangle()
                                    .fill(.yellow.opacity(0.1))
                                    .overlay{
                                        Rectangle()
                                        .strokeBorder(.yellow, lineWidth: 4)
                                    }
                                    .onTapGesture {
                                        makeMove(ofs)
                                    }
                            }
                        }
                        .frame(width: width, height: width)
                        .offset(x: Double(j) * width, y: Double(i) * width)
                    }
                    //}
                }
                //}.frame(width: g.size.width, height: g.size.width)
            }
        }
        .onAppear{
            print(1920 / 4, 1477 / 3)
        }
    }
    
    func tapSquare(_ offset: Int) {
        if activeOffset == offset {
            activeOffset = nil
            availableMoves = []
        } else {
            let moves = game.generateMoves(SquareOffset: offset)
            self.availableMoves = moves
            self.activeOffset = offset
        }
    }
    
    func makeMove(_ offset: Int) {
        availableMoves.forEach { m in
            if m.moveFrom == activeOffset && m.moveTo == offset {
                game.makeMove(move: m)
            }
        }
        
        let bestMove = ai.getBestMove(game: game)
        //game.makeMove(move: bestMove)
        activeOffset = nil
        availableMoves = []
    }
    
    func inAvailableMoves(_ o: Int) -> Bool {
        var isAvailable = false
        self.availableMoves.forEach { m in
            if m.moveTo == o { isAvailable = true }
        }
        return isAvailable
    }
    
    func XYtoOffset(x: Int, y: Int) -> Int {
        return (y * 16) + x
    }
    func offsetToXY(o: Int) -> CGPoint {
        let x = o % 16
        let y = o / 16
        return CGPoint(x: x, y: y)
    }
}

struct HoverBoard_Previews: PreviewProvider {
    static var previews: some View {
        HoverBoard()
    }
}
