
import UIKit



class ColorScreenViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGradient",
           let destinationVC = segue.destination as? TheGradientViewController {
            destinationVC.delegate = self
        }
    }
}

extension ColorScreenViewController: ColorDelegate {
    func updateBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
