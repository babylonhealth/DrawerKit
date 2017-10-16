import UIKit

extension UIViewControllerTransitioningDelegate where Self: DrawerController {
    @objc
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = DrawerController(presentingVC: presentingViewController,
                                                            presentedVC: presented,
                                                            configuration: configuration,
                                                            inDebugMode: inDebugMode)
        presentationController.delegate = self
        return presentationController
    }

    @objc
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: true,
                                   durationInSeconds: durationInSeconds,
                                   timingCurveProvider: timingCurveProvider)
    }

    @objc
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: false,
                                   durationInSeconds: durationInSeconds,
                                   timingCurveProvider: timingCurveProvider)
    }

    @objc
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isDrawerDraggable else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingViewController,
                                     presentedVC: presentedVC)
    }

    @objc
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isDrawerDraggable else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingViewController,
                                     presentedVC: presentedVC)
    }
}

// TODO: Implement support for adaptive presentations (UIAdaptivePresentationControllerDelegate).
extension UIAdaptivePresentationControllerDelegate where Self: DrawerController {}
