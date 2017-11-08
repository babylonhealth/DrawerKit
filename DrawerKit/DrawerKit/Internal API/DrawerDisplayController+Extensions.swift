import UIKit

extension DrawerDisplayController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        let presentationController = PresentationController(presentingVC: presentingVC,
                                                            presentingDrawerAnimationActions: presentingDrawerAnimationActions,
                                                            presentedVC: presented,
                                                            presentedDrawerAnimationActions: presentedDrawerAnimationActions,
                                                            configuration: configuration,
                                                            inDebugMode: inDebugMode)
        presentationController.delegate = self
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: true,
                                   configuration: configuration,
                                   presentingDrawerAnimationActions: presentingDrawerAnimationActions,
                                   presentedDrawerAnimationActions: presentedDrawerAnimationActions)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimationController(isPresentation: false,
                                   configuration: configuration,
                                   presentingDrawerAnimationActions: presentingDrawerAnimationActions,
                                   presentedDrawerAnimationActions: presentedDrawerAnimationActions)
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if #available(iOS 11.0, *) {
            guard isDrawerDraggable, let presentingVC = presentingVC else { return nil }
            return InteractionController(isPresentation: true,
                                         presentingVC: presentingVC,
                                         presentedVC: presentedVC)
        } else {
            // On iOS 10, there seems to be a bug in UIKit that causes the interactive animation
            // not to complete under the conditions we have here, in which case viewDidAppear
            // doesn't get called and the drawer isn't visible. An easy work-around is to return
            // nil here, but that means the initial presentation and dismissal aren't going to
            // be interactive.
            return nil
        }
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if #available(iOS 11.0, *) {
            guard isDrawerDraggable, let presentingVC = presentingVC else { return nil }
            return InteractionController(isPresentation: false,
                                         presentingVC: presentingVC,
                                         presentedVC: presentedVC)
        } else {
            // On iOS 10, there seems to be a bug in UIKit that causes the interactive animation
            // not to complete under the conditions we have here, in which case viewDidAppear
            // doesn't get called and the drawer isn't visible. An easy work-around is to return
            // nil here, but that means the initial presentation and dismissal aren't going to
            // be interactive.
            return nil
        }
    }
}

// TODO: Implement support for adaptive presentations.
extension DrawerDisplayController: UIAdaptivePresentationControllerDelegate {}
