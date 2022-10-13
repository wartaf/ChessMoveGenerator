//
//  WelcomeScreen.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/10/22.
//

import SwiftUI

struct GameMenuView: View {
    
    @State private var white = true
    @State private var black = false
    var returnFunc: ((Bool, Bool) -> Void )? = nil
    
    init(_ returnFunc: ((Bool, Bool) -> Void )? = nil ){
        self.returnFunc = returnFunc
    }
    
    private var personImg: some View {
        Image(systemName: "person.fill")
        .resizable()
        .scaledToFit()
        .padding(20)
    }
    
    private var computerImg: some View {
        Image(systemName: "desktopcomputer")
        .resizable()
        .scaledToFit()
        .padding(20)
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack (alignment: .trailing){
                    Text("Chess")
                        .font(.custom("Helvetica", size: 80))
                    
                    HStack{
                        Image(systemName: "crown")
                        
                        Text("Play")
                    }
                }
                .shadow(color: .gray, radius: 1, x: 4, y: 4)
                .scaleEffect(1.2)
                .rotationEffect(.degrees(-10))
                
                Spacer()
                
                VStack (spacing: 0){
                    HStack (spacing: 0){
                        Button{
                            white.toggle()
                        } label: {
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    if white == true {
                                        personImg
                                            .foregroundColor(.black)
                                    } else {
                                        computerImg
                                            .foregroundColor(.black)
                                    }
                                }
                        }
                        
                        Button {
                            black.toggle()
                        } label: {
                            Rectangle()
                                .fill(.black)
                                .overlay {
                                    if black == true {
                                        personImg
                                            .foregroundColor(.white)
                                    } else {
                                        computerImg
                                            .foregroundColor(.white)
                                    }
                                }
                        }
                        
                    }
                }
                .frame(width: 200, height: 100, alignment: .center)
                .border(.black, width: 2)

                Spacer()
                    
                Button{
                    self.returnFunc?(white, black)
                } label: {
                    Text("START")
                        .padding(24)
                        .padding(.horizontal, 32.0)
                        .foregroundColor(.primary)
                        .background{
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.thinMaterial)
                                .shadow(radius: 8)
                        }
                }
                
                Spacer()
                
            }
        }
    }
}

struct WelcomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameMenuView()
    }
}
