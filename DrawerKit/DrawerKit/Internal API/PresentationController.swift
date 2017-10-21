import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    private var lastDrawerY: CGFloat = 0
    private var drawerFullExpansionTapGR: UITapGestureRecognizer?
    private var drawerDismissalTapGR: UITapGestureRecognizer?
    private var drawerDragGR: UIPanGestureRecognizer?
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
        setupDrawerFullExpansionTapRecogniser()
        setupDrawerDismissalTapRecogniser()
        setupDrawerDragRecogniser()
        setupDebugHeightMarks()
        addCornerRadiusAnimationEnding(at: drawerPartialY)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: containerViewH)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeDrawerFullExpansionTapRecogniser()
        removeDrawerDismissalTapRecogniser()
        removeDrawerDragRecogniser()
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
        return min(max(presentedVC.heightOfPartiallyExpandedDrawer, 0), containerViewH)
    }

    var drawerPartialY: CGFloat {
        return containerViewH - drawerPartialH
    }

    var upperMarkY: CGFloat {
        return max(drawerPartialY - upperMarkGap, 0)
    }

    var lowerMarkY: CGFloat {
        return min(drawerPartialY + lowerMarkGap, containerViewH)
    }

    var currentDrawerY: CGFloat {
        get {
            let posY = presentedView?.frame.origin.y ?? 0
            return min(max(posY, 0), containerViewH)
        }
        set {
            let posY = min(max(newValue, 0), containerViewH)
            presentedView?.frame.origin.y = posY
        }
    }

    var currentDrawerCornerRadius: CGFloat {
        get {
            let radius = presentedView?.layer.cornerRadius ?? 0
            return min(max(radius, 0), maximumCornerRadius)
        }
        set {
            let radius = min(max(newValue, 0), maximumCornerRadius)
            presentedView?.layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                presentedView?.layer.maskedCorners =
                    [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                presentedView?.roundCorners([.topLeft, .topRight], radius: radius)
            }
        }
    }
}

private extension PresentationController {
    func setupDrawerFullExpansionTapRecogniser() {
        guard drawerFullExpansionTapGR == nil else { return }
        let isFullyPresentable = isFullyPresentableByDrawerTaps
        let numTapsRequired = numberOfTapsForFullDrawerPresentation
        guard isFullyPresentable && numTapsRequired > 0 else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleDrawerFullExpansionTap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = numTapsRequired
        presentedView?.addGestureRecognizer(tapGesture)
        drawerFullExpansionTapGR = tapGesture
    }

    func removeDrawerFullExpansionTapRecogniser() {
        guard let tapGesture = drawerFullExpansionTapGR else { return }
        presentedView?.removeGestureRecognizer(tapGesture)
        drawerFullExpansionTapGR = nil
    }

    @objc func handleDrawerFullExpansionTap() {
        guard let tapGesture = drawerFullExpansionTapGR else { return }
        let tapY = tapGesture.location(in: presentedView).y
        guard tapY < drawerPartialH else { return }
        animateTransition(to: 0)
    }
}

private extension PresentationController {
    func setupDrawerDismissalTapRecogniser() {
        guard drawerDismissalTapGR == nil else { return }
        let isDismissable = isDismissableByOutsideDrawerTaps
        let numTapsRequired = numberOfTapsForOutsideDrawerDismissal
        guard isDismissable && numTapsRequired > 0 else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDismissalTap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = numTapsRequired
        containerView?.addGestureRecognizer(tapGesture)
        drawerDismissalTapGR = tapGesture
    }

    func removeDrawerDismissalTapRecogniser() {
        guard let tapGesture = drawerDismissalTapGR else { return }
        containerView?.removeGestureRecognizer(tapGesture)
        drawerDismissalTapGR = nil
    }

    @objc func handleDrawerDismissalTap() {
        guard let tapGesture = drawerDismissalTapGR else { return }
        let tapY = tapGesture.location(in: containerView).y
        guard tapY < currentDrawerY else { return }
        presentedViewController.dismiss(animated: true)
    }
}

private extension PresentationController {
    func setupDrawerDragRecogniser() {
        guard drawerDragGR == nil && isDrawerDraggable else { return }
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDrag))
        presentedView?.addGestureRecognizer(panGesture)
        drawerDragGR = panGesture
    }

    func removeDrawerDragRecogniser() {
        guard let panGesture = drawerDragGR else { return }
        presentedView?.removeGestureRecognizer(panGesture)
        drawerDragGR = nil
    }

    @objc func handleDrawerDrag() {
        guard let panGesture = drawerDragGR, let view = panGesture.view else { return }

        switch panGesture.state {
        case .began:
            lastDrawerY = currentDrawerY

        case .changed:
            lastDrawerY = currentDrawerY
            let offsetY = panGesture.translation(in: view).y
            panGesture.setTranslation(.zero, in: view)
            let positionY = currentDrawerY + offsetY
            currentDrawerY = min(max(positionY, 0), containerViewH)
            currentDrawerCornerRadius = cornerRadius(at: currentDrawerY)

        case .ended:
            let drawerVelocityY = panGesture.velocity(in: view).y / containerViewH
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
        guard maximumCornerRadius > 0 && drawerPartialY > 0 && endPositionY != currentDrawerY else { return }

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
        guard inDebugMode && (upperMarkGap > 0 || lowerMarkGap > 0),
            let containerView = containerView else { return }

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
