import UIKit

// TODO:
// - support device interface orientation changes
// - support insufficiently tall content
// - support not-covering status bar and/or having a gap at the top

public final class DrawerController: NSObject {
    public let configuration: DrawerConfiguration
    public var inDebugMode: Bool
    private weak var presentationController: PresentationController?

    public init(configuration: DrawerConfiguration, inDebugMode: Bool = false) {
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        super.init()
    }
}

extension DrawerController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                             presenting: UIViewController?,
                                             source: UIViewController) -> UIPresentationController? {
        if presentationController == nil {
            let presentationController = PresentationController(configuration: configuration,
                                                                inDebugMode: inDebugMode,
                                                                presented: presented,
                                                                presenting: presenting)
            presentationController.delegate = self
            self.presentationController = presentationController

            return presentationController
        }
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: true,
                                   durationInSeconds: configuration.durationInSeconds,
                                   timingCurveProvider: configuration.timingCurveProvider)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: false,
                                   durationInSeconds: configuration.durationInSeconds,
                                   timingCurveProvider: configuration.timingCurveProvider)
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard configuration.isDrawerDraggable,
              let presentationController = self.presentationController
            else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentationController.presentingViewController,
                                     presentedVC: presentationController.presentedViewController)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard configuration.isDrawerDraggable,
              let presentationController = self.presentationController
            else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentationController.presentingViewController,
                                     presentedVC: presentationController.presentedViewController)
    }
}

// TODO: Implement support for adaptive presentations (UIAdaptivePresentationControllerDelegate).
extension DrawerController: UIAdaptivePresentationControllerDelegate {}
