import UIKit

// TODO:
// - support device interface orientation changes
// - support insufficiently tall content
// - support not-covering status bar and/or having a gap at the top

public final class DrawerDisplayController: NSObject {
    public let configuration: DrawerConfiguration // intentionally immutable

    weak var presentingVC: (UIViewController & DrawerPresenting)?
    /* strong */ var presentedVC: (UIViewController & DrawerPresentable)

    let inDebugMode: Bool

    public init(presentingViewController: (UIViewController & DrawerPresenting),
                presentedViewController: (UIViewController & DrawerPresentable),
                configuration: DrawerConfiguration = DrawerConfiguration(),
                inDebugMode: Bool = false) {
        self.presentingVC = presentingViewController
        self.presentedVC = presentedViewController
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        super.init()
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.modalTransitionStyle = .coverVertical
    }
}
