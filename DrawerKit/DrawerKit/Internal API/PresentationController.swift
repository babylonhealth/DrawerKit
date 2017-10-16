import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    private var lastDrawerY: CGFloat = 0
    private var containerViewDismissalTapGR: UITapGestureRecognizer?
    private var presentedViewDragGR: UIPanGestureRecognizer?
    private let inDebugMode: Bool

    init(presentingVC: UIViewController?,
         presentedVC: UIViewController,
         configuration: DrawerConfiguration,
         inDebugMode: Bool = false) {
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        super.init(presentedViewController: presentedVC, presenting: presentingVC)
    }
}

extension PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        frame.origin.y = (supportsPartialExpansion ? drawerPartialY : 0)
        return frame
    }

    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        setupContainerViewDismissalTapRecogniser()
        setupPresentedViewDragRecogniser()
        setupDebugHeightMarks()
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
        return drawerPartialY - upperMarkGap
    }

    var lowerMarkY: CGFloat {
        return drawerPartialY + lowerMarkGap
    }

    var currentDrawerY: CGFloat {
        get { return presentedView?.frame.origin.y ?? 0 }
        set { presentedView?.frame.origin.y = newValue }
    }

    var currentDrawerCornerRadius: CGFloat {
        get { return presentedView?.layer.cornerRadius ?? 0 }
        set {
            presentedView?.layer.cornerRadius = newValue
            if #available(iOS 11.0, *) {
                presentedView?.layer.maskedCorners =
                    [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                presentedView?.roundCorners([.topLeft, .topRight], radius: newValue)
            }
        }
    }
}

private extension PresentationController {
    func setupContainerViewDismissalTapRecogniser() {
        guard containerViewDismissalTapGR == nil else { return }
        let isDismissable = isDismissableByOutsideDrawerTaps
        let numTapsRequired = numberOfTapsForOutsideDrawerDismissal
        guard isDismissable && numTapsRequired > 0 else { return }
        let gr = UITapGestureRecognizer(target: self,
                                        action: #selector(handleContainerViewDismissalTap))
        gr.numberOfTouchesRequired = 1
        gr.numberOfTapsRequired = numTapsRequired
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
        guard presentedViewDragGR == nil else { return }
        guard isDrawerDraggable else { return }
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

        switch gr.state {
        case .began:
            lastDrawerY = currentDrawerY

        case .changed:
            lastDrawerY = currentDrawerY
            let offsetY = gr.translation(in: view).y
            gr.setTranslation(.zero, in: view)
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
        guard endPositionY != currentDrawerY else { return }

        let endPosY = (clamping ? clamped(endPositionY) : endPositionY)
        guard endPosY != currentDrawerY else { return }

        let animator = UIViewPropertyAnimator(duration: durationInSeconds,
                                              timingParameters: timingCurveProvider)

        let maxCornerRadius = maximumCornerRadius
        let endingCornerRadius = cornerRadius(at: endPosY)
        animator.addAnimations {
            self.currentDrawerY = endPosY
            if maxCornerRadius > 0 {
                self.currentDrawerCornerRadius = endingCornerRadius
            }
        }

        if endPosY == containerViewH {
            animator.addCompletion { _ in
                self.presentedViewController.dismiss(animated: true)
            }
        }

        if maxCornerRadius > 0 && endPosY != drawerPartialY {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }

    func addCornerRadiusAnimationEnding(at endPositionY: CGFloat, clamping: Bool = false) {
        guard maximumCornerRadius > 0 else { return }
        guard drawerPartialY > 0 else { return }
        guard endPositionY != currentDrawerY else { return }

        let endPosY = (clamping ? clamped(endPositionY) : endPositionY)
        guard endPosY != currentDrawerY else { return }

        let animator = UIViewPropertyAnimator(duration: durationInSeconds,
                                              timingParameters: timingCurveProvider)

        let endingCornerRadius = cornerRadius(at: endPosY)
        animator.addAnimations {
            self.currentDrawerCornerRadius = endingCornerRadius
        }

        if endPosY != drawerPartialY {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }

    func cornerRadius(at positionY: CGFloat) -> CGFloat {
        guard maximumCornerRadius > 0 else { return currentDrawerCornerRadius }
        guard drawerPartialY > 0 && drawerPartialY < containerViewH else { return 0 }
        guard positionY >= 0 && positionY <= containerViewH else { return 0 }

        let fraction: CGFloat
        if supportsPartialExpansion {
            if positionY < drawerPartialY {
                fraction = positionY / drawerPartialY
            } else {
                fraction = 1 - (positionY - drawerPartialY) / (containerViewH - drawerPartialY)
            }
        } else {
            fraction = 1 - positionY / containerViewH
        }

        return fraction * maximumCornerRadius
    }
}

private extension PresentationController {
    func endingPositionY(positionY: CGFloat, velocityY: CGFloat) -> CGFloat {
        let isNotMoving = (velocityY == 0)
        let isMovingUp = (velocityY < 0) // recall that Y-axis points down
        let isMovingDown = (velocityY > 0)
        // flickSpeedThreshold == 0 disables speed-dependence
        let isMovingQuickly = (flickSpeedThreshold > 0) && (abs(velocityY) > flickSpeedThreshold)
        let isMovingUpQuickly = isMovingUp && isMovingQuickly
        let isMovingDownQuickly = isMovingDown && isMovingQuickly
        let isAboveUpperMark = (positionY < upperMarkY)
        let isAboveLowerMark = (positionY < lowerMarkY)

        if isMovingUpQuickly { return 0 }
        if isMovingDownQuickly { return containerViewH }

        if isAboveUpperMark {
            if isMovingUp || isNotMoving {
                return 0
            } else {
                let inStages = supportsPartialExpansion && dismissesInStages
                return inStages ? drawerPartialY : containerViewH
            }
        }

        if isAboveLowerMark {
            if isMovingDown {
                return containerViewH
            } else {
                return (supportsPartialExpansion ? drawerPartialY : 0)
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
            return (supportsPartialExpansion ? drawerPartialY : 0)
        }
    }
}

private extension PresentationController {
    func setupDebugHeightMarks() {
        guard inDebugMode else { return }
        guard let containerView = containerView else { return }
        guard upperMarkGap > 0 || lowerMarkGap > 0 else { return }

        if upperMarkGap > 0 {
            let upperMarkYView = UIView()
            upperMarkYView.backgroundColor = .black
            upperMarkYView.frame = CGRect(x: 0, y: upperMarkY,
                                          width: containerView.bounds.size.width, height: 3)
            containerView.addSubview(upperMarkYView)
        }

        if lowerMarkGap > 0 {
            let lowerMarkYView = UIView()
            lowerMarkYView.backgroundColor = .black
            lowerMarkYView.frame = CGRect(x: 0, y: lowerMarkY,
                                          width: containerView.bounds.size.width, height: 3)
            containerView.addSubview(lowerMarkYView)
        }

        let drawerMarkView = UIView()
        drawerMarkView.backgroundColor = .white
        drawerMarkView.frame = CGRect(x: 0, y: drawerPartialY,
                                      width: containerView.bounds.size.width, height: 3)
        containerView.addSubview(drawerMarkView)
    }
}

// For versions of iOS lower than  11.0
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
