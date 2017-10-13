import UIKit

extension DrawerDisplayController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentingVC: presentingVC,
                                                            presentedVC: presented,
                                                            configuration: configuration,
                                                            inDebugMode: inDebugMode)
        presentationController.delegate = self
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: true,
                                   durationInSeconds: durationInSeconds,
                                   timingCurveProvider: timingCurveProvider)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: false,
                                   durationInSeconds: durationInSeconds,
                                   timingCurveProvider: timingCurveProvider)
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isDrawerDraggable else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingVC!, presentedVC: presentedVC)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isDrawerDraggable else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingVC!, presentedVC: presentedVC)
    }
}

// TODO: Implement support for adaptive presentations.
extension DrawerDisplayController: UIAdaptivePresentationControllerDelegate {}
