//
//  ViewController.swift
//  Score Keeper
//
//  Created by Jingkun Liu on 3/8/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet weak var player1Name: UITextField!
    @IBOutlet weak var player2Name: UITextField!
    @IBOutlet weak var player3Name: UITextField!
    @IBOutlet weak var player4Name: UITextField!
    
    @IBOutlet weak var player1Score: UITextField!
    @IBOutlet weak var player2Score: UITextField!
    @IBOutlet weak var player3Score: UITextField!
    @IBOutlet weak var player4Score: UITextField!
    
    @IBOutlet weak var player1Total: UITextView!
    @IBOutlet weak var player2Total: UITextView!
    @IBOutlet weak var player3Total: UITextView!
    @IBOutlet weak var player4Total: UITextView!
    
    var player1Current = 0
    var player2Current = 0
    var player3Current = 0
    var player4Current = 0
    
    var currentRound = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.player1Total.text = ""
        self.player2Total.text = ""
        self.player3Total.text = ""
        self.player4Total.text = ""
        
        self.updateView()
    }

    func updateView() {
        self.roundLabel.text = "Round \(self.currentRound)"
    }
    
    @IBAction func newGameButtonPressed(_ sender: Any) {
        self.player1Name.text = "Player 1"
        self.player2Name.text = "Player 2"
        self.player3Name.text = "Player 3"
        self.player4Name.text = "Player 4"
        
        self.player1Current = 0
        self.player2Current = 0
        self.player3Current = 0
        self.player4Current = 0
        
        self.currentRound = 1
        
        self.player1Total.text = ""
        self.player2Total.text = ""
        self.player3Total.text = ""
        self.player4Total.text = ""
        
        self.player1Score.text = ""
        self.player2Score.text = ""
        self.player3Score.text = ""
        self.player4Score.text = ""
        
        self.updateView()
    }
    
    
    @IBAction func enterRoundButtonPressed(_ sender: Any) {
        self.currentRound += 1
        
        self.player1Current += Int(self.player1Score.text ?? "") ?? 0
        self.player2Current += Int(self.player2Score.text ?? "") ?? 0
        self.player3Current += Int(self.player3Score.text ?? "") ?? 0
        self.player4Current += Int(self.player4Score.text ?? "") ?? 0
        
        self.player1Total.text = "\(self.player1Current)\n\(self.player1Total.text ?? "")"
        self.player2Total.text = "\(self.player2Current)\n\(self.player2Total.text ?? "")"
        self.player3Total.text = "\(self.player3Current)\n\(self.player3Total.text ?? "")"
        self.player4Total.text = "\(self.player4Current)\n\(self.player4Total.text ?? "")"
        
        self.updateView()
    }
}

