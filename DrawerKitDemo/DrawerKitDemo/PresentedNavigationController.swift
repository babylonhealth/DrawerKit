import UIKit
import DrawerKit

class PresentedNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
    }
}

extension PresentedNavigationController: DrawerAnimationParticipant {
    var drawerAnimationActions: DrawerAnimationActions {
        return (topViewController as? DrawerAnimationParticipant)?.drawerAnimationActions
            ?? DrawerAnimationActions()
    }
}

extension PresentedNavigationController: DrawerPresentable {
    var heightOfCollapsedDrawer: CGFloat {
        return (topViewController as? DrawerPresentable)?.heightOfCollapsedDrawer ?? 0.0
    }

    var heightOfPartiallyExpandedDrawer: CGFloat {
        return (topViewController as? DrawerPresentable)?.heightOfPartiallyExpandedDrawer ?? 0.0
    }

    var fullExpansionBehaviour: DrawerConfiguration.FullExpansionBehaviour? {
        return (topViewController as? DrawerPresentable)?.fullExpansionBehaviour
    }
}

extension PresentedNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let viewController = viewController as? PresentedViewController {
            drawerPresentationController?.scrollViewForPullToDismiss = viewController.presentedView
        }
    }
}
