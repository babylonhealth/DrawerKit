import UIKit

// TODO:
// - support device interface orientation changes
// - support insufficiently tall content
// - support not-covering status bar and/or having a gap at the top

public final class DrawerController: UIPresentationController,
UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate {
    public let configuration: DrawerConfiguration
    public var inDebugMode: Bool

    var lastDrawerY: CGFloat = 0
    var containerViewDismissalTapGR: UITapGestureRecognizer?
    var presentedViewDragGR: UIPanGestureRecognizer?
    weak var presentedVC: UIViewController!

    public init(presentingVC: UIViewController?,
                presentedVC: UIViewController,
                configuration: DrawerConfiguration,
                inDebugMode: Bool = false) {
        self.presentedVC = presentedVC
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        super.init(presentedViewController: presentedVC, presenting: presentingVC)
        presentedVC.transitioningDelegate = self
    }
}
