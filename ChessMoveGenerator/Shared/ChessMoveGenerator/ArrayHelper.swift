//
//  ArrayHelper.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 9/11/22.
//

import Foundation

extension Array {
    public subscript(Index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        guard Index >= 0 || Index < endIndex else {
            return defaultValue()
        }
        return self[Index]
    }
}
