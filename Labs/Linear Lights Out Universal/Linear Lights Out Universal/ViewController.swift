//
//  ViewController.swift
//  Linear Lights Out Universal
//
//  Created by Jingkun Liu on 3/17/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gameStateNavBar: UINavigationBar!
    @IBOutlet weak var gameStateLabel: UILabel!
    
    
    @IBOutlet var gameLightButtons: [UIButton]!
    
    let startTitle = "Turn all lights off!"
    var game = LinearLightsOutGame(numLights: 13)
    
    var lightOnImage: UIImage = #imageLiteral(resourceName: "light_on.png")
    var lightOffImage: UIImage = #imageLiteral(resourceName: "light_off.png")
    
    var gameWin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameStateLabel.text = self.startTitle
            
            self.lightOnImage = #imageLiteral(resourceName: "light_on_small.png")
            self.lightOffImage = #imageLiteral(resourceName: "light_off_small.png")
        } else { // iPad
            self.gameStateNavBar.topItem?.title = self.startTitle
            
            self.lightOnImage = #imageLiteral(resourceName: "light_on.png")
            self.lightOffImage = #imageLiteral(resourceName: "light_off.png")
        }
        
        for button in self.gameLightButtons {
            button.configuration?.imagePadding = 5
        }
        
        self.game = LinearLightsOutGame(numLights: 13)
        self.gameWin = false
        
        self.updateView()
    }

    @IBAction func newGameButtonPressed(_ sender: Any) {
        print("New Game")
        self.game = LinearLightsOutGame(numLights: 13)
        
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameStateLabel.text = self.startTitle
        } else { // iPad
            self.gameStateNavBar.topItem?.title = self.startTitle
        }
        
        self.gameWin = false
        self.updateView()
    }
    
    @IBAction func lightButtonPressed(_ sender: UIButton) {
        print("Light \(sender.tag) pressed")
        
        self.gameWin = self.game.pressedLightAtIndex(at: sender.tag)
        self.updateView()
    }
    
    func updateView() {
        print(self.game.description)
        
        for button in self.gameLightButtons {
            let buttonIndex = button.tag
            
            if self.game.lightStates[buttonIndex] {
                button.setImage(self.lightOnImage, for: .normal)
            } else {
                button.setImage(self.lightOffImage, for: .normal)
            }
//            print(button.currentImage?.size.debugDescription)
        }
        
        var message = ""
        if self.gameWin {
            message = "You won the game with \(self.game.numMoves) steps!"
        } else if self.game.numMoves == 0 {
            message = startTitle
        } else {
            message = "You moved \(self.game.numMoves) times"
        }
        
        if self.traitCollection.horizontalSizeClass == .compact { // iPhone
            self.gameStateLabel.text = message
        } else { // iPad
            self.gameStateNavBar.topItem?.title = message
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {

        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawAsPattern(in: (CGRect(x: 0, y: 0, width: newWidth, height: newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}

