//
//  ContentView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/14/22.
//. Edited

import SwiftUI


struct ContentView: View {
    var body: some View {
        ZStack {
            GameBoardView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


