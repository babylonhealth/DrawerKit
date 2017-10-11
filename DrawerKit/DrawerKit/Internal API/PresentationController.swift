import UIKit

final class PresentationController: UIPresentationController {
    private let configuration: DrawerConfiguration // intentionally immutable
    private var lastDrawerY: CGFloat = 0
    private var containerViewDismissalTapGR: UITapGestureRecognizer?
    private var presentedViewDragGR: UIPanGestureRecognizer?

    init(presentingVC: UIViewController?, presentedVC: UIViewController,
         configuration: DrawerConfiguration) {
        self.configuration = configuration
        super.init(presentedViewController: presentedVC, presenting: presentingVC)
    }
}

extension PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        frame.origin.y = drawerPartialY
        return frame
    }

    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        setupContainerViewDismissalTapRecogniser()
        setupPresentedViewDragRecogniser()
        addCornerRadiusAnimationEnding(at: drawerPartialY)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: containerViewH)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeContainerViewDismissalTapRecogniser()
        removePresentedViewDragRecogniser()
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

private extension PresentationController {
    var containerViewSize: CGSize {
        return containerView?.bounds.size ?? .zero
    }

    var containerViewH: CGFloat {
        return containerViewSize.height
    }

    var drawerPartialH: CGFloat {
        guard let presentedVC = presentedViewController as? DrawerPresentable else { return 0 }
        return presentedVC.heightOfPartiallyExpandedDrawer
    }

    var drawerPartialY: CGFloat {
        return containerViewH - drawerPartialH
    }

    var upperMarkY: CGFloat {
        return configuration.upperMarkFraction * (containerViewH - drawerPartialH)
    }

    var lowerMarkY: CGFloat {
        return drawerPartialY + configuration.lowerMarkFraction * drawerPartialH
    }

    var currentDrawerY: CGFloat {
        get { return presentedView?.frame.origin.y ?? 0 }
        set { presentedView?.frame.origin.y = newValue }
    }

    var currentDrawerCornerRadius: CGFloat {
        get { return presentedView?.layer.cornerRadius ?? 0 }
        set { presentedView?.layer.cornerRadius = newValue }
    }
}

private extension PresentationController {
    func setupContainerViewDismissalTapRecogniser() {
        let gr = UITapGestureRecognizer(target: self,
                                        action: #selector(handleContainerViewDismissalTap))
        containerView?.addGestureRecognizer(gr)
        containerViewDismissalTapGR = gr
    }

    func removeContainerViewDismissalTapRecogniser() {
        guard let gr = containerViewDismissalTapGR else { return }
        containerView?.removeGestureRecognizer(gr)
        containerViewDismissalTapGR = nil
    }

    @objc func handleContainerViewDismissalTap() {
        guard let gr = containerViewDismissalTapGR else { return }
        let tapY = gr.location(in: containerView).y
        guard tapY < currentDrawerY else { return }
        presentedViewController.dismiss(animated: true)
    }
}

private extension PresentationController {
    func setupPresentedViewDragRecogniser() {
        let gr = UIPanGestureRecognizer(target: self,
                                        action: #selector(handlePresentedViewDrag))
        presentedView?.addGestureRecognizer(gr)
        presentedViewDragGR = gr
    }

    func removePresentedViewDragRecogniser() {
        guard let gr = presentedViewDragGR else { return }
        presentedView?.removeGestureRecognizer(gr)
        presentedViewDragGR = nil
    }

    @objc func handlePresentedViewDrag() {
        guard let gr = presentedViewDragGR, let view = gr.view else { return }

        let offsetY = gr.translation(in: view).y
        gr.setTranslation(.zero, in: view)

        switch gr.state {
        case .began:
            lastDrawerY = currentDrawerY

        case .changed:
            lastDrawerY = currentDrawerY
            let positionY = currentDrawerY + offsetY
            currentDrawerY = min(max(positionY, 0), containerViewH)
            currentDrawerCornerRadius = cornerRadius(at: currentDrawerY)

        case .ended:
            let drawerVelocityY = gr.velocity(in: view).y / containerViewH
            let endPosY = endingPositionY(positionY: currentDrawerY,
                                          velocityY: drawerVelocityY)
            animateTransition(to: endPosY)

        case .cancelled:
            animateTransition(to: lastDrawerY, clamping: true)

        default:
            break
        }
    }
}

private extension PresentationController {
    func animateTransition(to endPositionY: CGFloat, clamping: Bool = false) {
        addPositionAnimationEnding(at: endPositionY, clamping: clamping)
        addCornerRadiusAnimationEnding(at: endPositionY, clamping: clamping)
    }

    func addPositionAnimationEnding(at endPositionY: CGFloat, clamping: Bool = false) {
        guard endPositionY != currentDrawerY else { return }

        let endPosY = (clamping ? clamped(endPositionY) : endPositionY)
        guard endPosY != currentDrawerY else { return }

        let animator = makeAnimator(to: endPosY)

        animator.addAnimations { [weak self] in
            self?.currentDrawerY = endPosY
        }

        if endPosY == containerViewH {
            animator.addCompletion { [weak self] _ in
                self?.presentedViewController.dismiss(animated: true)
            }
        }

        animator.startAnimation()
    }

    func addCornerRadiusAnimationEnding(at endPositionY: CGFloat, clamping: Bool = false) {
        guard drawerPartialY > 0 else { return }
        guard endPositionY != currentDrawerY else { return }

        let endPosY = (clamping ? clamped(endPositionY) : endPositionY)
        guard endPosY != currentDrawerY else { return }

        let animator = makeAnimator(to: endPosY)

        let endingCornerRadius = cornerRadius(at: endPosY)
        animator.addAnimations { [weak self] in
            self?.currentDrawerCornerRadius = endingCornerRadius
        }

        animator.startAnimation()
    }

    func makeAnimator(to endPositionY: CGFloat) -> UIViewPropertyAnimator {
        let timingConfiguration: TimingConfiguration
        if endPositionY == drawerPartialY {
            timingConfiguration = configuration.partialTransitionTimingConfiguration
        } else {
            timingConfiguration = configuration.fullTransitionTimingConfiguration
        }

        let duration = timingConfiguration.durationInSeconds
        let timingParams = timingConfiguration.timingCurveProvider
        return UIViewPropertyAnimator(duration: duration,
                                      timingParameters: timingParams)
    }

    func cornerRadius(at positionY: CGFloat) -> CGFloat {
        let maxCornerRadius = configuration.maximumCornerRadius
        guard drawerPartialY > 0 else { return 0 }
        let fraction: CGFloat
        if positionY <= drawerPartialY {
            fraction = positionY / drawerPartialY
        } else {
            fraction = 1 - (positionY - drawerPartialY) / (containerViewH - drawerPartialY)
        }
        return fraction * maxCornerRadius
    }
}

private extension PresentationController {
    func endingPositionY(positionY: CGFloat, velocityY: CGFloat) -> CGFloat {
        let velocityThresholdY = configuration.flickSpeedThreshold
        let allowPartialExpansion = configuration.supportsPartialExpansion
        let stagedDismissal = configuration.dismissesInStages
        return endingPositionY(positionY: positionY,
                               upperMarkY: upperMarkY,
                               lowerMarkY: lowerMarkY,
                               velocityY: velocityY,
                               velocityThresholdY: velocityThresholdY,
                               allowPartialExpansion: allowPartialExpansion,
                               stagedDismissal: stagedDismissal)
    }

    func endingPositionY(positionY: CGFloat, upperMarkY: CGFloat, lowerMarkY: CGFloat,
                         velocityY: CGFloat, velocityThresholdY: CGFloat,
                         allowPartialExpansion: Bool, stagedDismissal: Bool) -> CGFloat {
        let isMovingUp = (velocityY < 0) // recall that Y-axis points down
        let isMovingDown = !isMovingUp
        let isMovingQuickly = (abs(velocityY) > velocityThresholdY)
        let isMovingUpQuickly = isMovingUp && isMovingQuickly
        let isMovingDownQuickly = isMovingDown && isMovingQuickly
        let isAboveUpperMark = (positionY < upperMarkY)
        let isAboveLowerMark = (positionY < lowerMarkY)

        guard !isMovingUpQuickly else { return 0 }
        guard !isMovingDownQuickly else { return containerViewH }

        guard !isAboveUpperMark else {
            if isMovingUp {
                return 0
            } else {
                return stagedDismissal ? drawerPartialY : containerViewH
            }
        }

        guard !isAboveLowerMark else {
            if isMovingDown {
                return containerViewH
            } else {
                return (allowPartialExpansion ? drawerPartialY : 0)
            }
        }

        return containerViewH
    }

    func clamped(_ positionY: CGFloat) -> CGFloat {
        if positionY < upperMarkY {
            return 0
        } else if positionY > lowerMarkY {
            return containerViewH
        } else {
            return drawerPartialY
        }
    }
}
