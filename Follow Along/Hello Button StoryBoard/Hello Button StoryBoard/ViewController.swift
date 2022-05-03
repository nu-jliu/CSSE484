//
//  ViewController.swift
//  Hello Button StoryBoard
//
//  Created by Jingkun Liu on 3/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var counterLabel: UILabel!
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.updateView()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        let button : UIButton = sender as! UIButton
        print(button.tag)
        
        if button.tag == 0 {
            self.counter = 0
        } else {
            self.counter += button.tag
        }
        
        self.updateView()
    }
    
    func updateView() {
        self.counterLabel.text = "Counter = \(counter)"
    }
    
}

