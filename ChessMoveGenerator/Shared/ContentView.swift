//
//  ContentView.swift
//  Shared
//
//  Created by Harry Pantaleon on 8/4/22.
//

import SwiftUI

struct ContentView: View {
    @State private var ret: [Int] = [Int]()
    @State private var txt: String = ""
    @State private var list: [ChessMoveGenerator.Move] = []
    

    var game: ChessMoveGenerator = ChessMoveGenerator()//(fen: "rnb1k2r/pppp1ppp/7n/1q2p3/1b2P3/5N1Q/PPPP1PPP/RNB1K2R w KQkq - 0 8")
    var ai: ChessAI = ChessAI()
    var body: some View {
        VStack {
            ChessBoardView()
            
            
            ForEach(list, id: \.SAN) { m in
                Text("\(m.pieceType.type.rawValue) \(game.algebraic(i: m.moveTo)) \(m.pieceType.color.rawValue) \(m.SAN)")
                    .onTapGesture {
                        game.makeMove(move: ChessMoveGenerator.Move(moveFrom: m.moveFrom, moveTo: m.moveTo, pieceType: m.pieceType, flag: m.flag, promotion: m.promotion, captured: m.captured))
                        battleAI()
                        print(game.boardToASCII())
                        list = game.generateMoves()
                    }
            }
            TextField("Move", text: $txt)

            Button("ListMove"){
                let moves = game.generateMoves()
                moves.forEach { move in
                    print(move.moveFrom, move.moveTo, move.pieceType.type.rawValue, move.pieceType.color.rawValue, move.flag, move.promotion?.rawValue, move.captured?.rawValue, game.algebraic(i: move.moveTo))
                }
                print(moves.count)
            }
            Button("ASCII"){
                print(game.boardToASCII())
            }

            Button("FEN"){
                print(game.generateFen())
            }
            Button("BattleAI"){
                battleAI()
            }
            
        }
        .onAppear{
            //ai.gameInstance = game
            list = game.generateMoves()
            print(game.generateFen())
            print(game.boardToASCII())
        }
    }
    
    func battleAI(){
        let bestMove = ai.getBestMove(game: game)
        game.makeMove(move: bestMove)
        print(game.boardToASCII())
        print("move: ", bestMove.SAN)
        list = game.generateMoves()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
