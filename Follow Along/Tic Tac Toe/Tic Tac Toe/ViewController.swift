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
    
    var game = TicTacToeGame()
    var xImage: UIImage!
    var oImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameBoardImage.image = #imageLiteral(resourceName: "iPhone_board.png")
            self.xImage = #imageLiteral(resourceName: "iPhone_X.png")
            self.oImage = #imageLiteral(resourceName: "iPhone_O.png")
        } else {
            self.gameBoardImage.image = #imageLiteral(resourceName: "iPad_board.png")
            self.xImage = #imageLiteral(resourceName: "iPad_X.png")
            self.oImage = #imageLiteral(resourceName: "iPad_O.png")
        }
        
        self.updateView()
    }

    @IBAction func newGameButtonPressed(_ sender: Any) {
        print("New Game")
        self.game = TicTacToeGame()
        
        self.updateView()
    }
    
    @IBAction func gameBoardButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        print(button.tag)
        self.game.pressedSquare(at: button.tag)
        
        self.updateView()
    }
    
    func updateView() {
        print("Game State: \(self.game)")
        
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameStateLabel.text = self.game.state.rawValue
        } else { // iPad
            self.gameStateNavBar.topItem?.title = self.game.state.rawValue
        }
        
        for button in self.gameBoardButtons {
            let buttonIndex = button.tag
            
            switch game.board[buttonIndex] {
            case .none:
                button.imageView?.image = nil
            case .x:
                button.setImage(self.xImage, for: .normal)
            case .o:
                button.setImage(self.oImage, for: .normal)
            }
        }
    }
}

