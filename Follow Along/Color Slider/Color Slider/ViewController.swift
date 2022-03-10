//
//  ViewController.swift
//  Color Slider
//
//  Created by Jingkun Liu on 3/7/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var blueValueLabel: UILabel!
    @IBOutlet weak var alphaValueLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    @IBOutlet weak var colorVliew: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redSlider.value = 0.5
        greenSlider.value = 0
        blueSlider.value = 0
        alphaSlider.value = 1
        
        updateView()
    }

    @IBAction func sliderChanged(_ sender: Any) {
        print("Slider Changed")
        updateView()
    }
    
    func updateView() {
        let redValue = redSlider.value
        let greenValue = greenSlider.value
        let blueValue = blueSlider.value
        let alphaValue = alphaSlider.value
        
        print("Values: \(redValue) \(greenValue) \(blueValue) \(alphaValue)")
        
        redValueLabel.text = String(format: "%.2f", redValue)
        greenValueLabel.text = String(format: "%.2f", greenValue)
        blueValueLabel.text = String(format: "%.2f", blueValue)
        alphaValueLabel.text = String(format: "%.2f", alphaValue)
        
        colorVliew.backgroundColor = UIColor(red: CGFloat(redValue), green: CGFloat(greenValue), blue: CGFloat(blueValue), alpha: CGFloat(alphaValue))
    }
}
