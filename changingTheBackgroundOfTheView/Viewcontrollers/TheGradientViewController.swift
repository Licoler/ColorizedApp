
import UIKit
// MARK: - Protocols
protocol ColorUpdatable {
    var redSlider: UISlider! { get }
    var greenSlider: UISlider! { get }
    var blueSlider: UISlider! { get }
    var colorView: UIView! { get }

    func updateColorView()
}
protocol ColorDelegate: AnyObject {
    func updateBackgroundColor(_ color: UIColor)
}
final class TheGradientViewController: UIViewController, ColorUpdatable, UITextFieldDelegate {
    // MARK: - IB Outlets
    @IBOutlet var textFieldRed: UITextField!
    @IBOutlet var textFieldGreen: UITextField!
    @IBOutlet var textFieldBlue: UITextField!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet var sliderValueRed: UILabel!
    @IBOutlet var sliderValueGreen: UILabel!
    @IBOutlet var sliderValueBlue: UILabel!
    
    @IBOutlet weak var colorView: UIView!
    
    // MARK: - Public Properties
    weak var delegate: ColorDelegate?
    var initialColor: UIColor?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldRed.delegate = self
        textFieldGreen.delegate = self
        textFieldBlue.delegate = self


        updateLabel(for: redSlider, label: sliderValueRed)
        updateLabel(for: greenSlider, label: sliderValueGreen)
        updateLabel(for: blueSlider, label: sliderValueBlue)
            
        updateTextField(for: redSlider, textField: textFieldRed)
        updateTextField(for: greenSlider, textField: textFieldGreen)
        updateTextField(for: blueSlider, textField: textFieldBlue)
            
        redSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        greenSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        blueSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            
        updateColorView()

        toolBar()
        
        colorView.layer.cornerRadius = 20
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func buttonDone(_ sender: Any) {
        if let color = colorView.backgroundColor {
            delegate?.updateBackgroundColor(color)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Private func
    @objc private func sliderValueChanged(_ sender: UISlider) {
        if sender == redSlider {
            updateLabel(for: sender, label: sliderValueRed)
            updateTextField(for: sender, textField: textFieldRed)
        } else if sender == greenSlider {
            updateLabel(for: sender, label: sliderValueGreen)
            updateTextField(for: sender, textField: textFieldGreen)
        } else if sender == blueSlider {
            updateLabel(for: sender, label: sliderValueBlue)
            updateTextField(for: sender, textField: textFieldBlue)
        }
        updateColorView()
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func updateLabel(for slider: UISlider, label: UILabel) {
        label.text = String(format: "%.2f", slider.value)
    }
    
    private func updateTextField(for slider: UISlider, textField: UITextField) {
        textField.text = String(format: "%.2f", slider.value)
    }
    private func toolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
        toolbar.items = [doneButton]
        textFieldRed.inputAccessoryView = toolbar
        textFieldBlue.inputAccessoryView = toolbar
        textFieldGreen.inputAccessoryView = toolbar
    }
    
    private func isValidInput(_ input: String) -> Bool {
        let pattern = #"^0(\.\d{1,2})?$|^1(\.0{1,2})?$"#
        return input.range(of: pattern, options: .regularExpression) != nil
    }
    
    @objc func doneTapped() {
        view.endEditing(true)
        guard
            let redText = textFieldRed.text, let red = Float(redText), (0...1).contains(red),
            let greenText = textFieldGreen.text, let green = Float(greenText), (0...1).contains(green),
            let blueText = textFieldBlue.text, let blue = Float(blueText), (0...1).contains(blue)
        else {
            return
        }
    }
    // MARK: - Public func
    func updateColorView() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        
        colorView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            showAlert(withTitle: "Wrong format!", message: "Please enter correct value")
            return
        }

        if let dotIndex = text.firstIndex(of: ".") {
            let fractionalPart = text[text.index(after: dotIndex)...]
            if fractionalPart.count > 2 {
                showAlert(withTitle: "Wrong format!", message: "Please enter correct value")
                return
            }
        }

        guard let value = Float(text), (0...1).contains(value) else {
            showAlert(withTitle: "Wrong format!", message: "Please enter correct value")
            return
        }

        switch textField {
        case textFieldRed:
            redSlider.setValueAnimated(to: value)
            sliderValueRed.text = String(format: "%.2f", value)
        case textFieldGreen:
            greenSlider.setValueAnimated(to: value)
            sliderValueGreen.text = String(format: "%.2f", value)
        default:
            blueSlider.setValueAnimated(to: value)
            sliderValueBlue.text = String(format: "%.2f", value)
        }

        updateColorView()
    }
}
// MARK: - UISlider Extension
extension UISlider {
    func setValueAnimated(to newValue: Float, duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration) {
            self.setValue(newValue, animated: true)
            self.sendActions(for: .valueChanged)
        }
    }
}

