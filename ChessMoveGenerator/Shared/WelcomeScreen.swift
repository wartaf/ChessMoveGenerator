//
//  WelcomeScreen.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 10/10/22.
//

import SwiftUI

struct WelcomeScreen: View {
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
                .ignoresSafeArea()
            VStack {
                Spacer()
                VStack (alignment: .trailing){
                    Text("Chess")
                        .font(.custom("Helvetica", size: 64))

                    HStack{
                        Image(systemName: "crown")
                        
                        Text("Play")
                    }
                }
                .shadow(color: .gray, radius: 1, x: 4, y: 4)
                .scaleEffect(1.2)
                .rotationEffect(.degrees(-10))
                
                Spacer()
                
                Button {
                    print("press")
                } label: {
                    HStack (spacing: 0) {
                        Text("You")
                            .fontWeight(.heavy)
                            //.padding(48)
                            .frame(width: 64, height: 64, alignment: .center)
                            .background(.white)
                            .foregroundColor(.black)
                        Text("AI")
                            .fontWeight(.heavy)
                            //.padding(48)
                            .frame(width: 64, height: 64, alignment: .center)
                            .background(.black)
                            .foregroundColor(.white)
                    }
                    .border(.black, width: 2)
                }
                
                Spacer()
                
                Button{
                    print("start")
                } label: {
                    Text("START")
                        .padding()
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
        WelcomeScreen()
    }
}
