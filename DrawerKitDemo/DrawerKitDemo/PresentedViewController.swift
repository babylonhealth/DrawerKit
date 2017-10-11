import UIKit
import DrawerKit

// Search for the string 'THIS IS THE IMPORTANT PART' in both view controllers
// to see how to show the drawer. There may be more than one important part in
// each view controller.

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

// ======== THIS IS THE IMPORTANT PART ======== //
extension PresentedViewController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }
        return view.dividerView.frame.origin.y
    }
}
// ============================================ //
