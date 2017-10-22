import UIKit

final class AnimationController: NSObject {
    private let isPresentation: Bool
    private let totalDurationInSeconds: TimeInterval
    private let durationIsProportionalToDistanceTraveled: Bool
    private let timingCurveProvider: UITimingCurveProvider

    init(isPresentation: Bool,
         totalDurationInSeconds: TimeInterval,
         durationIsProportionalToDistanceTraveled: Bool,
         timingCurveProvider: UITimingCurveProvider) {
        self.isPresentation = isPresentation
        self.totalDurationInSeconds = totalDurationInSeconds
        self.durationIsProportionalToDistanceTraveled = durationIsProportionalToDistanceTraveled
        self.timingCurveProvider = timingCurveProvider
        super.init()
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        guard let context = transitionContext else { return 0 }
        let controller = viewController(from: context, isPresentation)
        return actualTransitionDuration(controller, context)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let controller = viewController(from: transitionContext, isPresentation)
        if isPresentation { transitionContext.containerView.addSubview(controller.view) }

        let duration = transitionDuration(using: transitionContext)
        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: timingCurveProvider)

        let (initialFrame, finalFrame) = frames(controller, transitionContext)

        controller.view.frame = initialFrame
        animator.addAnimations { controller.view.frame = finalFrame }

        animator.addCompletion { endingPosition in
            let finished = (endingPosition == UIViewAnimatingPosition.end)
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

            var duration = totalDurationInSeconds
            if durationIsProportionalToDistanceTraveled {
                let fractionToGo = abs(finalY - initialY) / containerViewH
                duration *= TimeInterval(fractionToGo)
            }

            return duration
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

    func viewController(from transitionContext: UIViewControllerContextTransitioning,
                        _ isPresentation: Bool) -> UIViewController {
        let key = (isPresentation ?
            UITransitionContextViewControllerKey.to :
            UITransitionContextViewControllerKey.from)
        return transitionContext.viewController(forKey: key)!
    }
}
