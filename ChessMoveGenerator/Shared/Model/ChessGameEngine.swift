//
//  ChessGameEngine.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/6/22.
//

import Foundation
import Chess

class ChessGameEngine: ObservableObject, GameEngine {
    typealias GameMove = ChessMove
    typealias Player = ChessPlayer
    
    private var players: [ChessColor: Player] = [:]
    
    private var gameStatus: GameStatus = .initialState
    private weak var gameHistory: ChessHistory?
    
    private var chess: Chess = Chess()
    
    public private(set) var colorToMove: ChessColor = .none
    
    private var timer: Timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in })
    
    @Published public var fen: String = ""
    
    func setPlayer(player: Player, color: ChessColor) {
        players[color] = player
        players[color]?.setGame(game: self)
    }
    
    func setGameHistory(_ history: ChessHistory) {
        self.gameHistory = history
    }
    
    func startGame() -> GameStatus {
        if players[.white] == nil || players[.black] == nil {
            print("ERROR: Not enough Player(s), Set a Player first!")
            return .failed
        }
        fen = chess.defaultPosition
        //Set Starting Player to White
        colorToMove = .white
        gameStatus = .started
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: self.gameLoop)
        return .started
    }
    
    func gameLoop(timer: Timer) {
        players[colorToMove]?.notifier(fen: fen)
    }
    
    func makeMove(player: Player, move: GameMove) -> GameStatus {
        if chess.gameOver() == true {
            print("GAME ENDED")
            return endGame()
        }
        
        if players[colorToMove] != player { return .failed }

        //convert promotion format from chess.PieceType => ChessPiece
        var chessPromomtion: Chess.PieceType?
        if move.promotion == .none {
            chessPromomtion = nil
        } else {
            let p1 = move.promotion.toString()
            chessPromomtion = Chess.PieceType.init(rawValue: p1)
        }
        
        //Check if posible moves
        let sq = chess.algebraicToOffset(pgn: move.from)
        let posibleMoves = chess.generateMoves(SquareOffset: sq)
        let len = posibleMoves.count
        
        if len == 0 { return .invalid }
        
        let inMoves = posibleMoves.contains {
            let pFrom = chess.algebraic(i: $0.moveFrom)
            let pTo = chess.algebraic(i: $0.moveTo)
            return pFrom == move.from && pTo == move.to && $0.promotion == chessPromomtion
        }
        
        if inMoves == false { return .invalid }

        // Make Move after Checking
        chess.makeMove(from: move.from, to: move.to, promotion: chessPromomtion)
        
        //print(chess.boardToASCII())
        colorToMove.toggle()
        
        gameHistory?.pushMove(player: player, move: move)
        
        fen = chess.generateFen()
        //print(fen)
        
        return .success
    }
    
    func endGame<P: GamePlayer>(by surrenderPlayer: P? = nil) -> GameStatus {
        timer.invalidate()
        if surrenderPlayer != nil {
            return .surrender
        }
        return .ended
    }
    
    func endGame() -> GameStatus {
        timer.invalidate()
        return .ended
    }
    
}

extension ChessGameEngine {
    func getAvailableOffset(from: String) -> [Int] {
        let fr = chess.algebraicToOffset(pgn: from)
        let moves = chess.generateMoves(SquareOffset: fr)
        
        var offset: Set<Int> = [] // should be unique int
        moves.forEach { m in
            offset.insert(m.moveTo)
        }
        return Array(offset)
    }
}
