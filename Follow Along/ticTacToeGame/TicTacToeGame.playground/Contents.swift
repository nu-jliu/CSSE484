import Darwin


// TODO: Create the TicTacToeGame class

class TicTacToeGame: CustomStringConvertible {
    
    enum MarkType: String {
        case none = "-"
        case x = "X"
        case o = "O"
    }
    
    enum GameState: String {
        case xTurn = "X's Turn"
        case oTurn = "O's Turn"
        case xWin = "X Wins!"
        case oWin = "O Wins!"
        case tie = "Tie Game"
    }
    
    var board: [MarkType]
    var state: GameState
    
    init() {
        self.board = [MarkType](repeating: .none, count: 9)
        self.state = .xTurn
    }
    
    func pressedSquare(at index: Int) {
        if (index < 0 || index > 8) {
            print("ERROR: Invalid index")
            return
        }
        
        if (self.board[index] != .none) {
            print("ERROR: The square is not empty")
            return
        }
        
        switch self.state {
        case .xWin, .oWin, .tie:
            print("ERROR: The game is over already, no move is allowed")
            return
            
        case .xTurn:
            self.board[index] = .x
            self.state = .oTurn
            
        case .oTurn:
            self.board[index] = .o
            self.state = .xTurn
        }
        
        self.checkForWin()
    }
    
    func checkForWin() {
        // Check for tie BEFORE check for win
        
        if !self.board.contains(.none) {
            self.state = .tie
            return
        }
        
        // Check for win
        
        var linesOfThree = [String]()
        
        for i in 0..<3 {
            let startIndex = 3 * i
            linesOfThree.append(self.getBoardString([startIndex, startIndex + 1, startIndex + 2]))
        }
        
        for i in 0..<3 {
            linesOfThree.append(self.getBoardString([i, i + 3, i + 6]))
        }
        
        linesOfThree.append(self.getBoardString([0, 4, 8]))
        linesOfThree.append(self.getBoardString([2, 4, 6]))
        
        for lineOf3 in linesOfThree {
            if lineOf3 == "XXX" {
                self.state = .xWin
                return
            } else if lineOf3 == "OOO" {
                self.state = .oWin
                return
            }
        }
    }
    
    func getBoardString(_ indices: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8]) -> String {
        var gameStr = ""
        
        for i in indices {
            gameStr.append(self.board[i].rawValue)
        }
        
        return gameStr
    }
    
    var description: String {
        return "\(self.state.rawValue): \(self.getBoardString())"
    }
}

/* ----------------- Official Playground testing ----------------- */
var game = TicTacToeGame()
//game.board[0] = .x
//game
game.pressedSquare(at: 0) // X is moving in the upper left
game.pressedSquare(at: 1) // O is moving in the top center
game.pressedSquare(at: 3) // X is below the other X
game.pressedSquare(at: 2) // O is moving to the top right
game.pressedSquare(at: 6) // X wins the game!!!


var game2 = TicTacToeGame()
game2.board = [.x, .x, .o,
                .none, .none, .none,
                .o, .none, .none]
game2.pressedSquare(at: 8)
game2.pressedSquare(at: 4)


var game3 = TicTacToeGame()
game3.board = [.x, .x, .o,
    .o, .o, .x,
    .x, .o, .none]
game3.pressedSquare(at: 8)

