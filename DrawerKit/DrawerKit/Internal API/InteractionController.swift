import UIKit

final class InteractionController: NSObject {
    private let configuration: DrawerConfiguration // intentionally immutable
    private let isPresentation: Bool

    init(isPresentation: Bool, configuration: DrawerConfiguration) {
        self.configuration = configuration
        self.isPresentation = isPresentation
        super.init()
    }
}

extension InteractionController: UIViewControllerInteractiveTransitioning {
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        // XXX
    }
}
