//
//  Protocols.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/16/22.
//

import Foundation

protocol Player {
    func newGame()
    func makeMove()
    func endGame()
}

protocol ChessGame {
    func start()
    func makeMove()
    func generateMove() -> [Any] // List Available Move
    func reset()
    func isGameOver() -> Bool // is it GameOver
}
