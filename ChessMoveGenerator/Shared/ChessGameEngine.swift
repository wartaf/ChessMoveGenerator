//
//  ChessGameEngine.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/6/22.
//

import Foundation
import Chess

class ChessGameEngine: GameEngine {
    typealias GameMove = ChessMove
    typealias Player = ChessPlayer
    
    private var players: [ChessColor: Player] = [:]
    
    private var gameStatus: GameStatus = .initialState
    private weak var gameHistory: ChessHistory?
    
    private var chess: Chess = Chess()
    
    public private(set) var colorToMove: ChessColor = .none
    
    private var timer: Timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in })
    

    public var fen: String {
        chess.generateFen()
    }
    
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
        //Set Starting Player to White
        colorToMove = .white
        gameStatus = .started
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: self.gameLoop)
        return .success
    }
    
    func gameLoop(timer: Timer) {
        players[colorToMove]?.notifier()
    }
    
    func makeMove(player: Player, move: GameMove) -> GameStatus {
        if chess.gameOver() == true {
            print("GAME ENDED")
            return endGame()
        }
        
        if players[colorToMove] != player { return .failed }

        var chessPromomtion: Chess.PieceType?
        
        if move.promotion == .none {
            chessPromomtion = nil
        } else {
            // get RawValue
            let p1 = move.promotion.toString()
            chessPromomtion = Chess.PieceType.init(rawValue: p1)
        }
        
        chess.makeMove(from: move.from, to: move.to, promotion: chessPromomtion)
        
        print(chess.boardToASCII())
        
        if colorToMove == .white {
            colorToMove = .black
        } else if colorToMove == .black {
            colorToMove = .white
        }
        gameHistory?.pushMove(player: player, move: move)
        
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
