//
//  Protocols.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/16/22.
//

import Foundation
import Chess

enum GameStatus {
    case initialState, started, ended, success, failed, surrender, invalid
}

enum ChessColor {
    case white, black, none
    
    mutating func toggle(){
        if self == .white {
            self = .black
        } else if self == .black {
            self = .white
        } else {
            self = .none
        }
    }
}
enum ChessPiece {
    case King, Queen, Rook, Bishop, Knight, Pawn, none
    
    func toString() -> String{
        switch self {
        case .King:
            return "K"
        case .Queen:
            return "Q"
        case .Rook:
            return "R"
        case .Bishop:
            return "B"
        case .Knight:
            return "N"
        case .Pawn:
            return "P"
        case .none:
            return ""
        }
    }
    
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
    
    public var from: String
    public var to: String //A1 - H8
    public var promotion: ChessPiece
    
    init(from: String, to: String, promotion: ChessPiece = .none) {
        self.from = from
        self.to = to
        self.promotion = promotion
    }
}

protocol GameMoveStructure { }


protocol GameEngine {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    
    var fen: String { get }
    
    func startGame() -> GameStatus
    func makeMove(player: Player, move: GameMove) -> GameStatus
    func endGame(by surrenderPlayer: Player?) -> GameStatus
}

protocol GamePlayer: Equatable {
    associatedtype Engine: GameEngine
    //associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    
    func makeMove(move: GameMove) -> GameStatus
    func surrender() -> GameStatus
    
    func setGame(game: Engine) // set game instance, by engine
    
    func notifier(fen: String) // Notify Player if its their turn
}

protocol GameHistory {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    func pushMove(player: Player, move: GameMove)
    func clearAll()
}





