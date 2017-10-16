import UIKit

final class AnimationController: NSObject {
    private let isPresentation: Bool
    private let durationInSeconds: TimeInterval
    private let timingCurveProvider: UITimingCurveProvider

    init(isPresentation: Bool,
         durationInSeconds: TimeInterval,
         timingCurveProvider: UITimingCurveProvider) {
        self.isPresentation = isPresentation
        self.durationInSeconds = durationInSeconds
        self.timingCurveProvider = timingCurveProvider
        super.init()
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return durationInSeconds
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

        let animator = UIViewPropertyAnimator(duration: durationInSeconds,
                                              timingParameters: timingCurveProvider)

        controller.view.frame = initialFrame
        animator.addAnimations { controller.view.frame = finalFrame }

        animator.addCompletion { endingPosition in
            let finished = (endingPosition == UIViewAnimatingPosition.end)
            transitionContext.completeTransition(finished)
        }

        animator.startAnimation()
    }
}
