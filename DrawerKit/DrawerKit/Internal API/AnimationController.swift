import UIKit

final class AnimationController: NSObject {
    private let isPresentation: Bool
    private let configuration: DrawerConfiguration

    init(isPresentation: Bool, configuration: DrawerConfiguration) {
        self.isPresentation = isPresentation
        self.configuration = configuration
        super.init()
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let context = transitionContext else { return 0 }
        let (_, presentedVC) = viewControllers(context, isPresentation)
        return actualTransitionDuration(presentedVC, context)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let (presentingVC, presentedVC) = viewControllers(transitionContext, isPresentation)
        if isPresentation { transitionContext.containerView.addSubview(presentedVC.view) }

        let duration = transitionDuration(using: transitionContext)
        let timingCurveProvider = configuration.timingCurveProvider
        let animator = UIViewPropertyAnimator(duration: duration, timingParameters: timingCurveProvider)

        let (initialFrame, finalFrame) = frames(presentedVC, transitionContext)

        let containerBounds = transitionContext.containerView.bounds
        let containerViewH = containerBounds.size.height

        let geometry = AnimationSupport.makeGeometry(containerBounds: containerBounds,
                                                     startingFrame: initialFrame,
                                                     endingFrame: finalFrame,
                                                     presentingVC: presentingVC,
                                                     presentedVC: presentedVC)

        let drawerPartialH = (presentedVC as? DrawerPresentable)?.heightOfPartiallyExpandedDrawer ?? 0
        let partialH = GeometryEvaluator.drawerPartialH(drawerPartialHeight: drawerPartialH,
                                                        containerViewHeight: containerViewH)

        let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
        let startDrawerState = GeometryEvaluator.drawerState(for: initialFrame.origin.y,
                                                             drawerPartialHeight: partialH,
                                                             containerViewHeight: containerViewH,
                                                             drawerFullY: drawerFullY,
                                                             configuration: configuration)

        let targetDrawerState = GeometryEvaluator.drawerState(for: finalFrame.origin.y,
                                                              drawerPartialHeight: partialH,
                                                              containerViewHeight: containerViewH,
                                                              drawerFullY: drawerFullY,
                                                              configuration: configuration)

        let info = AnimationSupport.makeInfo(startDrawerState: startDrawerState,
                                             targetDrawerState: targetDrawerState,
                                             configuration,
                                             geometry,
                                             duration,
                                             isPresentation)

        AnimationSupport.clientPrepareViews(presentingVC: presentingVC,
                                            presentedVC: presentedVC,
                                            info)
        presentedVC.view.frame = initialFrame

        animator.addAnimations {
            presentedVC.view.frame = finalFrame
            AnimationSupport.clientAnimateAlong(presentingVC: presentingVC,
                                                presentedVC: presentedVC,
                                                info)
        }

        animator.addCompletion { endingPosition in
            let finished = (endingPosition == UIViewAnimatingPosition.end)
            AnimationSupport.clientCleanupViews(presentingVC: presentingVC,
                                                presentedVC: presentedVC,
                                                endingPosition,
                                                info)
            transitionContext.completeTransition(finished)
        }

        animator.startAnimation()
    }
}

private extension AnimationController {
    func actualTransitionDuration(_ controller: UIViewController,
                                  _ transitionContext: UIViewControllerContextTransitioning)
        -> TimeInterval {
            let (initialFrame, finalFrame) = frames(controller, transitionContext)

            let initialY = initialFrame.origin.y
            let finalY = finalFrame.origin.y
            let containerViewH = transitionContext.containerView.bounds.size.height

            return AnimationSupport.actualTransitionDuration(from: initialY,
                                                             to: finalY,
                                                             containerViewHeight: containerViewH,
                                                             configuration: configuration)
    }

    func frames(_ controller: UIViewController,
                _ transitionContext: UIViewControllerContextTransitioning)
        -> (initial: CGRect, final: CGRect) {
            let containerViewH = transitionContext.containerView.bounds.size.height
            let presentedFrame = transitionContext.finalFrame(for: controller)
            var dismissedFrame = presentedFrame
            dismissedFrame.origin.y = containerViewH

            let initialFrame = (isPresentation ? dismissedFrame : presentedFrame)
            let finalFrame = (isPresentation ? presentedFrame : dismissedFrame)

            return (initialFrame, finalFrame)
    }

    func viewControllers(_ transitionContext: UIViewControllerContextTransitioning,
                         _ isPresentation: Bool)
        -> (presenting: UIViewController, presented: UIViewController) {
            let presentingKey = (isPresentation ?
                UITransitionContextViewControllerKey.from :
                UITransitionContextViewControllerKey.to)

            let presentedKey = (isPresentation ?
                UITransitionContextViewControllerKey.to :
                UITransitionContextViewControllerKey.from)

            let presentingVC = transitionContext.viewController(forKey: presentingKey)!
            let presentedVC = transitionContext.viewController(forKey: presentedKey)!

            return (presentingVC, presentedVC)
    }
}
