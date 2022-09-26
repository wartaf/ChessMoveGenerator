//
//  PromotionView.swift
//  Chess
//
//  Created by Harry Pantaleon on 9/21/22.
//

import SwiftUI

struct PromotionView: View {
    @Binding var piece: String
    public var pieceSelected: ((_ piece: String) -> ())? = nil
    //let picker
    var body: some View {
        if piece != "" {
            ZStack {
                let c = String(piece)
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
                                self.pieceSelected?("q")
                                piece = ""
                            }
                        Image(c + "r")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                self.pieceSelected?("r")
                                piece = ""
                            }
                        Image(c + "b")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                self.pieceSelected?("b")
                                piece = ""
                            }
                        Image(c + "n")
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                self.pieceSelected?("n")
                                piece = ""
                            }
                    }
                    .padding(8)
                }
                .frame( height: 100)
                .padding(32)

            }
        }
    }
}

