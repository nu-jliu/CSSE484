

// TODO: Create the TicTacToeGame class

class TicTacToeGame: CustomStringConvertible {
    
    enum MarkType: String {
        case none = "-"
        case x = "x"
        case o = "o"
    }
    
    enum State: String {
        case xTurn = "X's Turn"
        case oTurn = "O's Turn"
        case xWin = "X Wins!"
        case oWin = "O Wins!"
        case tie = "Tie Game"
    }
    
    var board: [MarkType]
    var state: State
    
    init() {
//        self.board = [MarkType]()
//
//        for _ in 0..<9 {
//            board.append(TicTacToeGame.MarkType.none)
//        }
        
        self.board = [MarkType](repeating: .none, count: 9)
        self.state = TicTacToeGame.State.xTurn
    }
    
    func getBoardString() -> String {
        var gameStr = ""
        
        for i in 0..<self.board.count {
            gameStr.append(self.board[i].rawValue)
        }
        
        return gameStr
    }
    
    var description: String {
        return "State: \(self.state) Board: \(self.getBoardString())"
    }
}

/* ----------------- Official Playground testing ----------------- */
var game = TicTacToeGame()
game.board[2] = .x
game
//game.pressedSquareAt(0)
//game.pressedSquareAt(1)
//game.pressedSquareAt(3)
//game.pressedSquareAt(2)
//game.pressedSquareAt(6)


//var game2 = TicTacToeGame()
//game2.board = [.x, .x, .o,
//                .none, .none, .none,
//                .o, .none, .none]
//game2.pressedSquareAt(8)
//game2.pressedSquareAt(4)


//var game3 = TicTacToeGame()
//game3.board = [.x, .x, .o,
//    .o, .o, .x,
//    .x, .o, .none]
//game3.pressedSquareAt(8)

