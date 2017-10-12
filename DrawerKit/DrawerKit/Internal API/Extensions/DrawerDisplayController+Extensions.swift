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
        return TransitionAnimator(isPresentation: true, configuration: configuration)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TransitionAnimator(isPresentation: false, configuration: configuration)
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return InteractionController(isPresentation: true, configuration: configuration)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return InteractionController(isPresentation: false, configuration: configuration)
    }
}

// TODO: Implement support for adaptive presentations.
extension DrawerDisplayController: UIAdaptivePresentationControllerDelegate {}
