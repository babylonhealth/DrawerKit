import UIKit

// extension DrawerPresentable where Self: UIViewController {
extension UIViewControllerTransitioningDelegate where Self: UIViewController & DrawerPresentable {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentingVC: presentingViewController,
                                                            presentedVC: presented,
                                                            configuration: drawerConfiguration,
                                                            inDebugMode: inDrawerDebugMode)
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
        guard let presentingVC = presentingViewController else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingVC,
                                     presentedVC: self)
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard isDrawerDraggable else { return nil }
        guard let presentingVC = presentingViewController else { return nil }
        return InteractionController(isPresentation: true,
                                     presentingVC: presentingVC,
                                     presentedVC: self)
    }
}

// TODO: Implement support for adaptive presentations (UIAdaptivePresentationControllerDelegate).
// extension DrawerPresentable where Self: UIViewController {}
extension UIAdaptivePresentationControllerDelegate where Self: UIViewController & DrawerPresentable {}
