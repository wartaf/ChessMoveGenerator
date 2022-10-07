//
//  Protocols.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/16/22.
//

import Foundation
import Chess

enum GameStatus {
    case initialState, started, ended, success, failed, surrender
}

enum ChessColor {
    case white, black, none
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
    
    private var _from: String, _to: String //A1 - H8
    public var from: String {
        get { return _from }
        set { _from = newValue }
    }
    public var to: String {
        get { return _to }
        set { _to = newValue }
    }
    
    public let promotion: ChessPiece = .none
    
    init(from: String, to: String, promotion: ChessPiece = .none) {
        self._from = from
        self._to = to
    }
}

protocol GameMoveStructure { }


protocol GameEngine {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    func startGame() -> GameStatus
    func makeMove(player: Player, move: GameMove) -> GameStatus
    func endGame(by surrenderPlayer: Player?) -> GameStatus
}

protocol GamePlayer: Equatable {
    associatedtype Engine: GameEngine
    //associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    //var ID: Int { get }
    
    func makeMove(move: GameMove) -> GameStatus
    func surrender() -> GameStatus
    
    // set by engine
    func setGame(game: Engine)
    
    func notifier()
}

protocol GameHistory {
    associatedtype Player: GamePlayer
    associatedtype GameMove: GameMoveStructure
    func pushMove(player: Player, move: GameMove)
    func clearAll()
}





