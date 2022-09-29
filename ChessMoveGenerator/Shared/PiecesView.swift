//
//  BoardView.swift
//  Chess
//
//  Created by Harry Pantaleon on 8/23/22.
//

import SwiftUI
import Chess

enum PiecesViewStatus {
    case drag(_ offsetFrom: Int, _ pieceType: Chess.ChessPiece? = nil)
    case drop(_ offsetFrom: Int, _ offsetTo: Int, _ pieceType: Chess.ChessPiece? = nil, _ promotion: Chess.PieceType? = nil)
}

struct PiecesView: View {
    @Binding var fen: String
    @Binding var highlightOffsets: [Int]
    public var event: ((_ status: PiecesViewStatus) -> ())? = nil
    
    init(fen: Binding<String>, highlightOffsets: Binding<[Int]>, event: ((_ status: PiecesViewStatus) -> ())? = nil) {
        self._fen = fen
        self._highlightOffsets = highlightOffsets
        self.event = event
        self.loadFen(fen: self.fen)
    }
    
    //private let defaultFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
    @State private var currentPiece: MyPiece? = nil
    @State private var currentPieceOffset: Int? = nil
    @State private var piecesOffset: [MyPiece?] = []
    @State private var isDragging = false
    @State private var promotionColor = ""
    
    @State private var saveFromToPiece: (Int,Int,Chess.ChessPiece?)? = nil // just for temporary storage

    
    var body: some View {
        GeometryReader { g in
            let w = min(g.size.width, g.size.height)
            let w8 = w / 8
            ZStack {
                ForEach(0..<piecesOffset.count, id: \.self){ i in
                    if let myPiece = piecesOffset[i]{
                        DrawPieceView(myPiece.piece) {o in
                            onDropEvent(from: myPiece.offset, to: myPiece.offset + o, pieceType: myPiece.piece, promotion: nil)
                        }
                        .offset(offsetToXY(o: myPiece.offset, multiple:  w8))
                        .onTapGesture {
                            if currentPiece == nil || currentPiece?.offset != piecesOffset[i]!.offset {
                                onDragEvent(from:piecesOffset[i]!.offset, pieceType: piecesOffset[i]?.piece)
                            } else {
                                currentPiece = nil
                                highlightOffsets = []
                            }
                        }
                        .simultaneousGesture(
                            DragGesture()
                            .onChanged{_ in
                                if isDragging == false {
                                    onDragEvent(from: piecesOffset[i]!.offset, pieceType: piecesOffset[i]?.piece)
                                }
                                isDragging = true
                            }
                            .onEnded({ v in
                                isDragging = false
                                currentPiece = nil
                            })
                        )
                    }
                }
            }
            
            ForEach(highlightOffsets, id: \.self) { i in
                Rectangle()
                    .fill(.yellow)
                    .opacity(0.2)
                    .onTapGesture {
                        onDropEvent(from: currentPiece?.offset ?? -1, to: i, pieceType: currentPiece?.piece, promotion:  nil) // NEED PIECE TYPE
                    }
                    .offset(offsetToXY(o: i, multiple:  w8))
                    .frame(width: w8, height: w8)
            }
            
            if promotionColor == "w" || promotionColor == "b" {
                PromotionView (promotionColor: $promotionColor) { p in
                    if let (from, to, piece) = saveFromToPiece {
                        onDropEvent(from: from, to: to, pieceType: piece, promotion: p)
                    }
                }
            }
        }
        .onChange(of: fen, perform: { newValue in
            loadFen(fen: newValue)
        })
        .onAppear{
            //let d1 = Date().timeIntervalSince1970
            loadFen(fen: fen)
            //let d2 = Date().timeIntervalSince1970
            //print("load speed: ", d2 - d1)
        }
    }
    
    func onDragEvent(from: Int, pieceType: Chess.ChessPiece?) {
        if !highlightOffsets.isEmpty {
            highlightOffsets = []
        }
        self.event?(.drag(from, pieceType))
        currentPiece = MyPiece(piece: pieceType!, offset: from)
    }
    
    func onDropEvent(from: Int, to: Int, pieceType: Chess.ChessPiece?, promotion: Chess.PieceType?) {
        let to = Range(0...120).contains(to) ? to : from
        
        // promotion of pawn
        if pieceType?.type == .Pawn && promotion == nil {
            if highlightOffsets.contains(to) {
                
                //SAVE FROM, TO, PIECETYPE ARGS THEN CALL ONDROPEVENT AFTER SELECTION
                saveFromToPiece = (from, to, pieceType)
                
                if pieceType?.color == .white && Range(0...7).contains(to) {
                    //print("promotion.... white")
                    promotionColor = "w"
                    currentPiece = nil
                    highlightOffsets = []
                    return
                } else if pieceType?.color == .black && Range(112...119).contains(to) {
                    //print("promotion.... black")
                    promotionColor = "b"
                    currentPiece = nil
                    highlightOffsets = []
                    return
                }
            }
        }
        
        self.event?(.drop(from, to, pieceType, promotion))
        currentPiece = nil
        highlightOffsets = []
        
    }
    


    func offsetToXY(o: Int, multiple: Double = 1.0) -> CGSize {
        let x = o % 16
        let y = o / 16
        return CGSize(width: Double(x) * multiple, height: Double(y) * multiple)
    }
    
    public func generateFEN() -> String {
        var board: [Chess.ChessPiece?] = Array(repeating: nil, count: 128)
        piecesOffset.forEach { p in
            if let p = p {
                board[p.offset] = p.piece
            }
        }
        
        var empty: Int = 0
        var fen: String = ""
        
        var i = 0 // a8
        let h1 = 119 // h1
        while i <= h1 {
            defer {i = i + 1 }
            
            if board[i] == nil {
                empty = empty + 1
            } else {
                if empty > 0 {
                    fen += String(empty)
                    empty = 0
                }
                let color = board[i]!.color
                let piece = board[i]!.type
                
                fen += String( color == .white ? piece.rawValue.uppercased() : piece.rawValue.lowercased() )
            }
            
            if (i + 1) & 0x88 != 0 {
                if empty > 0 {
                    fen += String(empty)
                }
                
                if i != h1 {
                    fen += "/"
                }
                
                empty = 0
                i += 8
            }
        }
        return fen
    }
    
    func fenToMyPiece(fen: String = "") -> [MyPiece] {
        let tokens = fen.isEmpty ? "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".split(separator: " ") : fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        var myPiece: [MyPiece] = []
        
        position.forEach { piece in
            if piece == "/" {
                square += 8
            } else if let emptyPiece = Int(String(piece)) {
                square += emptyPiece
            } else {
                let color: Chess.PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = Chess.PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                let piece = Chess.ChessPiece(type: pieceType, color: color)
                
                myPiece.append(MyPiece(piece: piece, offset: square))
                square += 1
            }
        }
        return myPiece
    }
 
    public func loadFen(fen: String = ""){
        let tokens = fen.isEmpty ? "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1".split(separator: " ") : fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        var a1: [MyPiece?] = [] //NewPiece
        var a2 = piecesOffset //OldPiece
        
        position.forEach { piece in
            if piece == "/" {
                square += 8
            } else if let emptyPiece = Int(String(piece)) {
                square += emptyPiece
            } else {
                let color: Chess.PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = Chess.PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                let piece = Chess.ChessPiece(type: pieceType, color: color)
                
                a1.append(MyPiece(piece: piece, offset: square))
                square += 1
            }
        }

        // [new] XOR-ViceVersa [old]
        for i1 in 0..<a1.count {
            for i2 in 0..<a2.count {
                if a1[i1] == a2[i2] {
                    a1[i1] = nil
                    a2[i2] = nil
                    continue
                }
            }
        }
        
        // Remove if SamePiece then Generate 'FromTo' on SamePiece
        var fromTo: [(Int, Int)] = []
        for i1 in 0..<a1.count {
            for i2 in 0..<a2.count {
                if a1[i1] == nil || a2[i2] == nil { continue }
                if a1[i1]!.piece == a2[i2]!.piece {
                    fromTo.append((a1[i1]!.offset, i2))
                    a1[i1] = nil
                    a2[i2] = nil
                }
            }
        }

        //animate/move similar piece w/ diff offset
        fromTo.forEach { (a,i) in
            withAnimation{
                piecesOffset[i]?.offset = a
            }
        }

        // place new added pieces (if there's new)
        piecesOffset.append(contentsOf: a1.compactMap{ $0 })
        
        // remove not exist pieces
        for i in 0..<a2.count {
            if a2[i] != nil {
                piecesOffset[i] = nil
            }
        }
    }

    struct MyPiece: Equatable, Hashable{
        static func == (lhs: MyPiece, rhs: MyPiece) -> Bool {
            return lhs.piece == rhs.piece && lhs.offset == rhs.offset
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(piece.type)
            hasher.combine(piece.color)
            hasher.combine(offset)
        }
        
        let piece: Chess.ChessPiece
        var offset: Int
    }
}


struct DrawPieceView: View {
    let piece: Chess.ChessPiece?
    let drop: ((_ offset: Int) -> ())?
    
    init(_ piece: Chess.ChessPiece? = nil, onDrop: ((_ dropOffset: Int) -> ())? = nil){
        self.piece = piece
        self.drop = onDrop
    }
    
    @State private var isDrag = false
    @State private var ofs = CGSize.zero
    @State private var hoverOffset = CGSize.zero

    var body: some View {
        GeometryReader{ g in
            let w = min(g.size.width, g.size.height) / 8
            let imgName = (piece?.color.rawValue ?? "") + (piece?.type.rawValue.lowercased() ?? "empty")
            if hoverOffset != .zero {
                Group{
                    Rectangle()
                        .strokeBorder(.yellow,lineWidth: 6)
                        .opacity(0.4)
                }
                .frame(width: w, height: w)
                .offset(hoverOffset)
            }
            Image(imgName)
                .resizable()
                .frame(width: w, height: w)
                .offset(ofs)
                .gesture(
                    DragGesture()
                    .onChanged({ v in
                        ofs = v.translation
                        let toX = floor(v.location.x / w), toY = floor(v.location.y / w)
                        hoverOffset = CGSize(width: toX * w, height: toY * w)
                        isDrag = true
                    })
                    .onEnded({ v in
                        let toX = floor(v.location.x / w), toY = floor(v.location.y / w)
                        self.drop?(Int((toY * 16) + toX))
                        ofs = CGSize.zero
                        hoverOffset = .zero
                        isDrag = false
                    })
                )
        }
    }
}

struct PiecesView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesView(fen: .constant("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"), highlightOffsets: .constant([]))
    }
}
