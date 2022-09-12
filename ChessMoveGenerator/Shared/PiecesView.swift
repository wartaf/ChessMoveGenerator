//
//  BoardView.swift
//  ChessMoveGenerator
//
//  Created by Harry Pantaleon on 8/23/22.
//

import SwiftUI

enum PiecesViewStatus {
    case drag(_ offsetFrom: Int)
    case drop(_ offsetFrom: Int, _ offsetTo: Int)
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
    @State private var currentPieceOffset: Int? = nil
    @State private var piecesOffset: [MyPiece?] = []
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { g in
            let w = min(g.size.width, g.size.height)
            let w8 = w / 8
            ZStack {
                ForEach(0..<piecesOffset.count, id: \.self){ i in
                    if let myPiece = piecesOffset[i]{
                        DrawPieceView(myPiece.piece) {o in
                            onDropEvent(from: myPiece.offset, to: myPiece.offset + o)
                        }
                        .offset(offsetToXY(o: myPiece.offset, multiple:  w8))
                        .onTapGesture {
                            if currentPieceOffset == nil || currentPieceOffset != piecesOffset[i]!.offset {
                                onDragEvent(from:piecesOffset[i]!.offset)
                            } else {
                                currentPieceOffset = nil
                                highlightOffsets = []
                            }
                            
                        }
                        .simultaneousGesture(
                            DragGesture()
                            .onChanged{_ in
                                if isDragging == false {
                                    onDragEvent(from: piecesOffset[i]!.offset)
                                }
                                isDragging = true
                            }
                            .onEnded({ v in
                                isDragging = false
                                currentPieceOffset = nil
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
                        onDropEvent(from: currentPieceOffset ?? -1, to: i)
                    }
                    .offset(offsetToXY(o: i, multiple:  w8))
                    .frame(width: w8, height: w8)
            }
        }
        .onChange(of: fen, perform: { newValue in
            loadFen(fen: newValue)
        })
        .onAppear{
            let d1 = Date().timeIntervalSince1970
            loadFen(fen: fen)
            let d2 = Date().timeIntervalSince1970
            print("load speed: ", d2 - d1)
        }
    }
    
    func onDragEvent(from: Int) {
        if !highlightOffsets.isEmpty {
            highlightOffsets = []
        }
        self.event?(.drag(from))
        currentPieceOffset = from
    }
    
    func onDropEvent(from: Int, to: Int) {
        self.event?(.drop(from, to))
        currentPieceOffset = nil
        highlightOffsets = []
    }

    func offsetToXY(o: Int, multiple: Double = 1.0) -> CGSize {
        let x = o % 16
        let y = o / 16
        return CGSize(width: Double(x) * multiple, height: Double(y) * multiple)
    }
    
    /*
    func makeMove(from: Int, to: Int){
        //print(from, to)
        if from & 0x88 != 0 { return } // Out of Board Range
        if to & 0x88 != 0 { return } // Out of Board Range
        
        var fromPiece: Int? = nil
        var toPiece: Int? = nil
        
        for i in 0..<piecesOffset.count {
            if piecesOffset[i]?.offset == from {
                fromPiece = i
            }
            if piecesOffset[i]?.offset == to {
                toPiece = i
            }
        }
        
        if let iFrom = fromPiece {
            withAnimation{
                piecesOffset[iFrom]?.offset = to
            }
            if toPiece != nil && toPiece != fromPiece {
                piecesOffset[toPiece!] = nil
            }
        }
    }
    */
    
    /*
    func generateBoard(){
        //board = game.board
        let cnt = board.count
        for i in 0..<cnt {
            //board.append(MyPiece(piece: game.board[i], offset: i))
            if let piece = board[i] {
                piecesOffset.append(MyPiece(piece: piece, offset: i))
            }
        }
    }
    */
    
    
    public func generateFEN() -> String {
        var board: [ChessMoveGenerator.ChessPiece?] = Array(repeating: nil, count: 128)
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
                let color: ChessMoveGenerator.PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = ChessMoveGenerator.PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                let piece = ChessMoveGenerator.ChessPiece(type: pieceType, color: color)
                
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

        // place new added pieces
        piecesOffset.append(contentsOf: a1)

        // clean nil & deleted pieces
        piecesOffset.removeAll { p in
            return p == nil || a2.contains(p)
        }
    }
    
     
    /*
     // this looks slower by 10%?
    public func loadFen(fen: String = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"){
        let tokens = fen.split(separator: " ")
        let position = Array(tokens[0])
        var square = 0
        var newBoard: [ChessMoveGenerator.ChessPiece?] = Array(repeating: nil, count: 128)
        var oldOffset = piecesOffset
        position.forEach { piece in
            if piece == "/" {
                square += 8
            } else if let emptyPiece = Int(String(piece)) {
                square += emptyPiece
            } else {
                let color: ChessMoveGenerator.PieceColor = piece.asciiValue! < 97 ? .white : .black //ASCII OF Lowercase "a"
                let pieceType = ChessMoveGenerator.PieceType(rawValue: String(piece).uppercased())! // Check if valid piece
                let piece = ChessMoveGenerator.ChessPiece(type: pieceType, color: color)
                
                newBoard[square] = piece
                square += 1
            }
        }
        
        // find difference of new & old board, remove if exist in both
        for i in 0..<oldOffset.count {
            if let old = oldOffset[i] {
                if newBoard[old.offset] == old.piece {
                    newBoard[old.offset] = nil
                    oldOffset[i] = nil
                }
            }
        }
        
        var a1: [MyPiece] = []
        var fromTo: [(Int, Int)] = []
        for i in 0..<newBoard.count {
            for j in 0..<oldOffset.count {
                if newBoard[i] == nil || oldOffset[j] == nil { continue }
                if oldOffset[j]!.piece == newBoard[i] {
                    fromTo.append((j, i)) //( index of piecesOffset, Square number )
                    newBoard[i] = nil
                    oldOffset[j] = nil
                }
            }
            // add to MyPiece if not nil after the oldOffset-loop
            if let nPiece = newBoard[i] {
                a1.append(MyPiece(piece: nPiece, offset: i))
            }
        }
        
        //animate/move similar piece w/ diff offset
        fromTo.forEach { (i,a) in
            withAnimation{
                piecesOffset[i]?.offset = a
            }
        }
        
        // place new added pieces
        piecesOffset.append(contentsOf: a1)
        
        // clean nil & deleted pieces
        piecesOffset.removeAll { p in
            return p == nil || oldOffset.contains(p)
        }
    }
     */
    

    struct MyPiece: Equatable, Hashable{
        static func == (lhs: MyPiece, rhs: MyPiece) -> Bool {
            return lhs.piece == rhs.piece && lhs.offset == rhs.offset
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(piece.type)
            hasher.combine(piece.color)
            hasher.combine(offset)
        }
        
        let piece: ChessMoveGenerator.ChessPiece
        var offset: Int
    }
}


struct DrawPieceView: View {
    let piece: ChessMoveGenerator.ChessPiece?
    let drop: ((_ offset: Int) -> ())?
    
    init(_ piece: ChessMoveGenerator.ChessPiece? = nil, onDrop: ((_ dropOffset: Int) -> ())? = nil){
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

struct DrawHightlightView: View {
    var body: some View {
        GeometryReader{ g in
            let w = min(g.size.width, g.size.height) / 8
            Rectangle()
                .fill(.yellow)
                .frame(width: w , height: w)
                .opacity(0.2)
                .overlay{
                    Rectangle()
                        .strokeBorder(.yellow,lineWidth: 6)
                        .opacity(0.2)
                }
        }
    }
}


struct PiecesView_Previews: PreviewProvider {
    static var previews: some View {
        PiecesView(fen: .constant("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"), highlightOffsets: .constant([]))
    }
}
