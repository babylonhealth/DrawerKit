import UIKit

// TODO:
// - support device interface orientation changes
// - support insufficiently tall content
// - support iPhone X

/// Instances of this class are returned by objects conforming to
/// the `DrawerCoordinating` protocol.

public final class DrawerDisplayController: NSObject {
    /// The collection of configurable parameters dictating how the drawer works.
    public let configuration: DrawerConfiguration

    weak var presentingVC: UIViewController?
    /* strong */ var presentedVC: (UIViewController & DrawerPresentable)

    let presentingDrawerAnimationActions: DrawerAnimationActions
    let presentedDrawerAnimationActions: DrawerAnimationActions

    let inDebugMode: Bool

    /// Initialiser for `DrawerDisplayController`.
    ///
    /// - Parameters:
    ///   - `presentingViewController`:
    ///        the view controller presenting the drawer.
    ///   - `presentedViewController`:
    ///        the view controller wanting to be presented as a drawer.
    ///   - `configuration`:
    ///        the collection of configurable parameters dictating the drawer's behaviour.
    ///   - `inDebugMode`:
    ///        a boolean value which, when true, draws guiding lines on top of the
    ///        presenting view controller but below the presented view controller.
    ///        Its default value is false.
    public init(presentingViewController: UIViewController,
                presentedViewController: (UIViewController & DrawerPresentable),
                configuration: DrawerConfiguration = DrawerConfiguration(),
                inDebugMode: Bool = false) {
        self.presentingVC = presentingViewController
        self.presentedVC = presentedViewController
        self.configuration = configuration
        self.inDebugMode = inDebugMode

        if let presentingAsDrawerParticipant = presentingViewController as? DrawerAnimationParticipant {
            self.presentingDrawerAnimationActions = presentingAsDrawerParticipant.drawerAnimationActions
        } else {
            self.presentingDrawerAnimationActions = DrawerAnimationActions()
        }

        if let presentedAsDrawerParticipant = presentedViewController as? DrawerAnimationParticipant {
            self.presentedDrawerAnimationActions = presentedAsDrawerParticipant.drawerAnimationActions
        } else {
            self.presentedDrawerAnimationActions = DrawerAnimationActions()
        }

        super.init()
        presentedViewController.transitioningDelegate = self
        presentedViewController.modalPresentationStyle = .custom
        presentedViewController.modalTransitionStyle = .coverVertical
    }
}
