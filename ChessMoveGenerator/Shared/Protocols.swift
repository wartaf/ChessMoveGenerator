//
//  Protocols.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/16/22.
//

import Foundation

enum GameStatus {
    case initialState, started, ended, success, failed, surrender
}

enum ChessColor {
    case white, black, none
}
enum ChessPiece {
    case King, Queen, Rook, Bishop, Knight, Pawn, none
    
    static func from(string: String) -> ChessPiece {
        switch string {
        case "k", "K":
            return .King
        case "q", "Q":
            return .Queen
        case "r", "R":
            return .Rook
        case "b", "B":
            return .Bishop
        case "n", "N":
            return .Knight
        case "p", "P":
            return .Pawn
        default:
            return .none
        }
    }
}

struct ChessMove: GameMoveStructure{
    let from: Int
    let to: Int
    let promotion: ChessPiece = .none
}

protocol GameMoveStructure { }


protocol GameEngine {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    func startGame() -> GameStatus
    func makeMove(player: Player, move: GameMove) -> GameStatus
    func endGame(by surrenderPlayer: Player?) -> GameStatus
}

protocol GamePlayer {
    associatedtype Engine: GameEngine
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    var ID: Int { get }
    func setGame(game: Engine)
    func makeMove(move: GameMove) -> GameStatus
    func surrender() -> GameStatus
}

protocol GameHistory {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    func pushMove(player: Player, move: GameMove)
    func clearAll()
}

class ChessHistory: GameHistory {
    typealias Player = ChessPlayer
    typealias GameMove = ChessMove
    
    private var moves: [(ChessPlayer, ChessMove)] = []
    
    func pushMove(player: ChessPlayer, move: ChessMove) {
        moves.append((player, move))
    }
    func clearAll() {
        moves = []
    }
    func printAll(){
        moves.forEach {
            print("player\($0.ID) -> \($1.from) - \($1.to)")
        }
        
    }
}

class ChessGameEngine: GameEngine {
    typealias GameMove = ChessMove
    typealias Player = ChessPlayer
    
    private var whitePlayer: Player?
    private var blackPlayer: Player?
    private var playerToMove: Player?
    private var gameStatus: GameStatus = .initialState
    private var gameHistory: ChessHistory?
    
    func setPlayer(player: Player, color: ChessColor) {
        if color == .white {
            whitePlayer = player
            whitePlayer?.setGame(game: self)
        } else if color == .black {
            blackPlayer = player
            blackPlayer?.setGame(game: self)
        }
    }
    
    func setGameHistory(_ history: ChessHistory) {
        self.gameHistory = history
    }
    
    func startGame() -> GameStatus {
        if whitePlayer == nil || blackPlayer == nil {
            print("ERROR: Not enough Player(s), Set a Player first!")
            return .failed
        }
        //Set Starting Player to White
        playerToMove = whitePlayer
        gameStatus = .started
        return .success
    }
    
    func makeMove(player: Player, move: GameMove) -> GameStatus {
        if let pm = playerToMove {
            if pm != player {
                print("ERROR: Opponents turn!")
                return .failed
            }
            gameHistory?.pushMove(player: player, move: move)
            
            if pm == whitePlayer {
                playerToMove = blackPlayer
            } else {
                playerToMove = whitePlayer
            }
            
            return .success
        } else {
            return .failed
        }
    }
    
    func endGame(by surrenderPlayer: Player? = nil) -> GameStatus {
        if surrenderPlayer != nil {
            return .surrender
        }
        return .ended
    }
}

class ChessPlayer: GamePlayer, Equatable {
    typealias Player = ChessPlayer
    typealias GameMove = ChessMove
    typealias Engine = ChessGameEngine
    
    var ID: Int = 0
    private unowned var game: Engine?

    init (ID: Int){
        self.ID = ID
    }
    
    static func == (lhs: ChessPlayer, rhs: ChessPlayer) -> Bool {
        return lhs.ID == rhs.ID
    }
    
    func setGame(game: Engine) {
        self.game = game
    }
    
    func makeMove(move: GameMove) -> GameStatus {
        return game?.makeMove(player: self, move: move) ?? .failed
    }
    
    func surrender() -> GameStatus {
        return game?.endGame(by: self) ?? .failed
    }
}
