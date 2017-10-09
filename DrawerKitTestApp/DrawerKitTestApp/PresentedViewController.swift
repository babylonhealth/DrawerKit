import UIKit
import DrawerKit

// Search for the string 'THIS IS THE IMPORTANT PART' in both view controllers
// to see how to show the drawer. There may be more than one important part in
// each view controller.

// ======== THIS IS THE IMPORTANT PART ======== //
class PresentedViewController: UIViewController, DrawerPresentable {
    weak var drawerTransitionController: DrawerKit.TransitionController?
    // ============================================ //
    var fixedHeightConstraint: NSLayoutConstraint!
    var hasFixedHeight = false

//    I expected this to be called by it isn't!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.heightAnchor.constraint(equalToConstant: 300).isActive = hasFixedHeight
//    }

    override func loadView() {
        super.loadView()
        view.heightAnchor.constraint(equalToConstant: 290).isActive = hasFixedHeight
    }

    @IBAction func dismissButtonTapped() {
        // ======== THIS IS THE IMPORTANT PART ======== //
        // Instead of
        //        dismiss(animated: true, completion: nil)
        // you should use
        //        drawerTransitionController.dismiss()
        // Note that there is no completion closure. Completion closures are
        // supplied as members of TransitionActions because there may be a need
        // for different completion closures for different drawer states.
        drawerTransitionController?.dismiss()
        // ============================================ //
    }
}

// ======== THIS IS THE IMPORTANT PART ======== //
extension PresentedViewController {
    override var presentingViewController: UIViewController? {
        guard let controller = drawerTransitionController else {
            return super.presentingViewController
        }
        return controller.presenterVC
    }

    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }
        return view.dividerView.frame.origin.y
    }
}
// ============================================ //
