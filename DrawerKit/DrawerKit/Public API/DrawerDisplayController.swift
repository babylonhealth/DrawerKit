import UIKit

public final class DrawerDisplayController: NSObject {
    public let configuration: DrawerConfiguration // intentionally immutable

    weak var presentingVC: (UIViewController & DrawerPresenting)?
    /* strong */ var presentedVC: (UIViewController & DrawerPresentable)

    public init(presentingViewController: (UIViewController & DrawerPresenting),
                presentedViewController: (UIViewController & DrawerPresentable),
                configuration: DrawerConfiguration = DrawerConfiguration()) {
        self.presentingVC = presentingViewController
        self.presentedVC = presentedViewController
        self.configuration = configuration
        super.init()
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.modalTransitionStyle = .coverVertical
    }
}
