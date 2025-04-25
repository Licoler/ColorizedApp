//
//  ViewController.swift
//  changingTheBackgroundOfTheView
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    
    @IBOutlet var sliderValueRed: UILabel!
    @IBOutlet var sliderValueGreen: UILabel!
    @IBOutlet var sliderValueBlue: UILabel!
    
    @IBOutlet var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderValueRed.text = String(format: "%.2f", redSlider.value)
        sliderValueGreen.text = String(format: "%.2f", greenSlider.value)
        sliderValueBlue.text = String(format: "%.2f", blueSlider.value)
                
        redSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        greenSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        blueSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        updateColorView()
        colorView.layer.cornerRadius = 20
        }
            
        @objc private func sliderValueChanged(_ sender: UISlider) {
            if sender == redSlider {
                updateLabel(for: sender, label: sliderValueRed)
            } else if sender == greenSlider {
                updateLabel(for: sender, label: sliderValueGreen)
            } else if sender == blueSlider {
                updateLabel(for: sender, label: sliderValueBlue)
            }
            updateColorView()
        }

        private func updateLabel(for slider: UISlider, label: UILabel) {
            label.text = String(format: "%.2f", slider.value)
        }
        private func updateColorView() {
            let red = CGFloat(redSlider.value)
            let green = CGFloat(greenSlider.value)
            let blue = CGFloat(blueSlider.value)

            colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
       }
    }


