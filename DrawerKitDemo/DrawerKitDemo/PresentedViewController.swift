import UIKit
import DrawerKit

class PresentedViewController: UIViewController {
    var hasFixedHeight = false

    override func loadView() {
        super.loadView()
        view.heightAnchor.constraint(equalToConstant: 290).isActive = hasFixedHeight
    }

    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
