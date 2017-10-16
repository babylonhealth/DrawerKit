import UIKit
import DrawerKit

class PresenterViewController: UIViewController {
    @IBAction func presentButtonTapped() {
        doModalPresentation()
    }
}

private extension PresenterViewController {
    func doModalPresentation() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "presented")
            as? PresentedViewController else { return }

        vc.transitioningDelegate = vc
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .coverVertical

        present(vc, animated: true)
    }
}
