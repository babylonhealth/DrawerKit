import UIKit

final class TransitionAnimator: NSObject {
    private let configuration: DrawerConfiguration // intentionally immutable
    private let isPresentation: Bool
    private var isFirstRun = true
    private var timingConfiguration: TimingConfiguration

    init(isPresentation: Bool, configuration: DrawerConfiguration) {
        self.configuration = configuration
        self.isPresentation = isPresentation
        self.timingConfiguration = configuration.partialTransitionTimingConfiguration
        super.init()
    }
}

extension TransitionAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return timingConfiguration.durationInSeconds
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

        let duration = timingConfiguration.durationInSeconds
        let timingParams = timingConfiguration.timingCurveProvider
        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: timingParams)

        timingConfiguration = configuration.fullTransitionTimingConfiguration

        controller.view.frame = initialFrame
        animator.addAnimations { controller.view.frame = finalFrame }

        animator.addCompletion { endingPosition in
            let finished = (endingPosition == UIViewAnimatingPosition.end)
            transitionContext.completeTransition(finished)
        }

        animator.startAnimation()
    }
}
