import UIKit

final class AnimatorController: NSObject {
    private let configuration: DrawerConfiguration // intentionally immutable
    private let isPresentation: Bool

    init(isPresentation: Bool, configuration: DrawerConfiguration) {
        self.configuration = configuration
        self.isPresentation = isPresentation
        super.init()
    }
}

extension AnimatorController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return configuration.durationInSeconds
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key = (isPresentation ?
            UITransitionContextViewControllerKey.to :
            UITransitionContextViewControllerKey.from)

        let controller = transitionContext.viewController(forKey: key)!
        if isPresentation { transitionContext.containerView.addSubview(controller.view) }

        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = transitionContext.containerView.frame.size.height

        let initialFrame = (isPresentation ? dismissedFrame : presentedFrame)
        let finalFrame = (isPresentation ? presentedFrame : dismissedFrame)

        let duration = configuration.durationInSeconds
        let timingParams = configuration.timingCurveProvider
        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: timingParams)

        controller.view.frame = initialFrame
        animator.addAnimations { controller.view.frame = finalFrame }

        animator.addCompletion { endingPosition in
            let finished = (endingPosition == UIViewAnimatingPosition.end)
            transitionContext.completeTransition(finished)
        }

        animator.startAnimation()
    }
}
