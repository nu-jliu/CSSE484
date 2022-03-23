//
//  ViewController.swift
//  Emoji Matching
//
//  Created by Jingkun Liu on 3/22/22.
//

import UIKit

class ViewController: UIViewController {

    var game: EmojiMatchingGame!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.game = EmojiMatchingGame(numPairs: 10)
//        self.stateLabel.font = UIFont.systemFont(ofSize: 50)
        
        self.updateFontSize()
        self.updateView()
    }

    func delay(_ delay: Double, closure: @escaping () -> ()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    @IBAction func cardPressed(_ sender: Any) {
        let button = sender as! UIButton
        print("Pressed button \(button.tag)")
        
        self.game.pressedCard(at: button.tag)
        self.updateView()
        
        if self.game.gameState.numFlipped == 2 {
            self.delay(1.2) { () in
                self.game.checkTwoFlippedCard()
                self.updateView()
            }
        }
    }
    
    @IBAction func newGamePressed(_ sender: Any) {
        print("New Game")
        
        self.game.startNewTurn()
        self.updateView()
    }
    
    func updateView() {
        print(self.game!)
        
        for button in self.cardButtons {
            let buttonIndex = button.tag
            
            switch self.game.cardStates[buttonIndex] {
                
            case .normal:
                button.setTitle("\(self.game.cardBack)", for: .normal)
                button.isHidden = false
            case .flipped:
                button.setTitle("\(self.game.cards[buttonIndex])", for: .normal)
                button.isHidden = false
            case .removed:
                button.setTitle("", for: .normal)
            }
        }
    }
    
    func updateFontSize() {
        var fontSize: CGFloat!
        
        if self.traitCollection.horizontalSizeClass == .compact {
            fontSize = 60
        } else {
            fontSize = 100
        }
        
        for button in self.cardButtons {
            button.titleLabel?.font = .systemFont(ofSize: fontSize)
            button.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

