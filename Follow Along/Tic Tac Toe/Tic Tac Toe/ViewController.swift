//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Jingkun Liu on 3/16/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameStateLabel: UILabel!
    @IBOutlet weak var gameStateNavBar: UINavigationBar!
    
    @IBOutlet var gameBoardButtons: [UIButton]!
    @IBOutlet weak var gameBoardImage: UIImageView!
    
    var game: TicTacToeGame!
    let xImage = UIImage(named: "X.png")
    let oImage = UIImage(named: "O.png")
    let noneImage = UIImage(named: "empty.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.game = TicTacToeGame()
//        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
//            self.gameBoardImage.image = #imageLiteral(resourceName: "board.png")
//            self.xImage = #imageLiteral(resourceName: "X.png")
//            self.oImage = #imageLiteral(resourceName: "O.png")
//        } else {
//            self.gameBoardImage.image =
//            self.xImage = #imageLiteral(resourceName: "iPad_X.png")
//            self.oImage = #imageLiteral(resourceName: "iPad_O.png")
//        }
        
//        self.gameBoardImage.image = #imageLiteral(resourceName: "board.png")
        self.updateView()
    }

    @IBAction func newGameButtonPressed(_ sender: Any) {
        print("New Game")
        self.game = TicTacToeGame()
        
        self.updateView()
    }
    
    @IBAction func gameBoardButtonPressed(_ button: UIButton) {
        let buttonTag = button.tag
        
        print("You pressed button \(buttonTag)")
        self.game.pressedSquare(at: buttonTag)
        
        self.updateView()
    }
    
    func updateView() {
        print("Game State: \(self.game!)")
        
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameStateLabel.text = self.game.state.rawValue
        } else { // iPad
            self.gameStateNavBar.topItem?.title = self.game.state.rawValue
        }
        
        for k in 0..<self.gameBoardButtons.count {
            let button = self.gameBoardButtons[k]
            let mark = self.game.board[k]
            
            switch mark {
            case .none:
                button.setImage(self.noneImage, for: .normal)
            case .x:
                button.setImage(self.xImage, for: .normal)
            case .o:
                button.setImage(self.oImage, for: .normal)
            }
        }
    }
}

