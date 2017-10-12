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
}

extension DrawerDisplayController: UIAdaptivePresentationControllerDelegate {} // XXX
