//
//  reset.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 9/10/22.
//

import Foundation

extension ChessMoveGenerator {
    func reset() {
        load(fen: defaultPosition)
    }
}
