//
//  PromotionView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/21/22.
//

import SwiftUI
import Chess

struct PromotionView: View {
    @Binding var promotionColor: String
    public var pieceSelected: ((_ piece: Chess.PieceType) -> ())? = nil
    //let picker
    var body: some View {
        if promotionColor == "w" || promotionColor == "b" {
            ZStack {
                let c = String(promotionColor)
                Group {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.gray, lineWidth: 4)
                        }
                        
                    HStack {
                        Image(c + "q")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                onTap("Q")
                            }
                        Image(c + "r")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                onTap("R")
                            }
                        Image(c + "b")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                onTap("B")
                            }
                        Image(c + "n")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                onTap("N")
                            }
                    }
                    .padding(8)
                }
                .frame( height: 100)
                .padding(32)

            }
        }
    }
    
    func onTap(_ pieceType: String) {
        
        let piece: Chess.PieceType = .init(rawValue: pieceType) ?? .Queen
        print(pieceType, piece, Chess.PieceType.init(rawValue: pieceType))
        self.pieceSelected?(piece)
        promotionColor = ""
    }
}

