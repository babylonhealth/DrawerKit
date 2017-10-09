import UIKit

public final class TransitionController: NSObject {
    public private(set) weak var presenterVC: (UIViewController & DrawerPresenting)?
    public private(set) weak var contentVC: (UIViewController & DrawerPresentable)?

    public let configuration: TransitionConfiguration
    private let drawerVC: DrawerViewController

    public init(presenter: (UIViewController & DrawerPresenting),
                presented: (UIViewController & DrawerPresentable),
                configuration: TransitionConfiguration = TransitionConfiguration()) {
        self.presenterVC = presenter
        self.contentVC = presented
        self.configuration = configuration
        self.drawerVC = DrawerViewController(presenterVC: presenter,
                                             contentVC: presented,
                                             configuration: configuration)
        self.presenterVC = presenter
        self.contentVC = presented
        super.init()
        presented.drawerTransitionController = self
    }

    public func present() {
        presenterVC?.present(drawerVC, animated: false) { [weak self] in
            self?.drawerVC.presentDrawer()
        }
    }

    public func dismiss() {
        drawerVC.dismissDrawer()
    }
}
