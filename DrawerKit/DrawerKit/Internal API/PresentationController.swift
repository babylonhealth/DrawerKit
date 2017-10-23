import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    private var lastDrawerState: DrawerState = .collapsed
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
        let state: DrawerState = (supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded)
        frame.origin.y = drawerPositionY(for: state)
        return frame
    }

    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        setupDrawerFullExpansionTapRecogniser()
        setupDrawerDismissalTapRecogniser()
        setupDrawerDragRecogniser()
        setupDebugHeightMarks()
        addCornerRadiusAnimationEnding(at: .partiallyExpanded)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: .collapsed)
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

extension DrawerState {
    static func ==(lhs: DrawerState, rhs: DrawerState) -> Bool {
        switch (lhs, rhs) {
        case (.collapsed, .collapsed),
             (.partiallyExpanded, .partiallyExpanded),
             (.fullyExpanded, .fullyExpanded):
            return true
        case let (.transitioning(lhsCurPosY), .transitioning(rhsCurPosY)):
            return equal(lhsCurPosY, rhsCurPosY)
        default:
            return false
        }
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

    var currentDrawerState: DrawerState {
        get { return drawerState(for: currentDrawerY) }
        set { currentDrawerY = drawerPositionY(for: newValue) }
    }

    func drawerPositionY(for state: DrawerState) -> CGFloat {
        switch state {
        case .collapsed:
            return containerViewH
        case .partiallyExpanded:
            return drawerPartialY
        case .fullyExpanded:
            return 0
        case let .transitioning(positionY):
            return positionY
        }
    }

    func drawerState(for positionY: CGFloat, clampToNearest: Bool = false) -> DrawerState {
        if smallerThanOrEqual(positionY, 0) {
            return .fullyExpanded
        } else if greaterThanOrEqual(positionY, containerViewH) {
            return .collapsed
        } else if equal(positionY, drawerPartialY) {
            return .partiallyExpanded
        } else {
            let posY = min(max(positionY, 0), containerViewH)
            guard clampToNearest else { return .transitioning(posY) }
            return drawerState(for: clamped(posY))
        }
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

    func cornerRadius(at state: DrawerState) -> CGFloat {
        guard maximumCornerRadius != 0
            && drawerPartialY != 0
            && drawerPartialY != containerViewH
            else { return 0 }

        let positionY = drawerPositionY(for: state)

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

    func clamped(_ positionY: CGFloat) -> CGFloat {
        if smallerThanOrEqual(positionY, upperMarkY) {
            return 0
        } else if greaterThanOrEqual(positionY, lowerMarkY) {
            return containerViewH
        } else if smallerThanOrEqual(positionY, drawerPartialY) {
            return (supportsPartialExpansion ? drawerPartialY : 0)
        } else {
            return (supportsPartialExpansion ? drawerPartialY : containerViewH)
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
        animateTransition(to: .fullyExpanded)
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
            lastDrawerState = drawerState(for: currentDrawerY, clampToNearest: true)

        case .changed:
            lastDrawerState = drawerState(for: currentDrawerY, clampToNearest: true)
            currentDrawerY += panGesture.translation(in: view).y
            currentDrawerCornerRadius = cornerRadius(at: currentDrawerState)
            panGesture.setTranslation(.zero, in: view)

        case .ended:
            let drawerSpeedY = panGesture.velocity(in: view).y / containerViewH
            let endingState = nextStateFrom(currentState: currentDrawerState,
                                            speedY: drawerSpeedY)
            animateTransition(to: endingState)

        case .cancelled:
            animateTransition(to: lastDrawerState)

        default:
            break
        }
    }
}

private extension PresentationController {
    func animateTransition(to endState: DrawerState) {
        guard endState != currentDrawerState else { return }

        let animator = UIViewPropertyAnimator(duration: durationInSeconds,
                                              timingParameters: timingCurveProvider)

        let maxCornerRadius = maximumCornerRadius
        let endingCornerRadius = cornerRadius(at: endState)
        let endingPositionY = drawerPositionY(for: endState)

        animator.addAnimations {
            self.currentDrawerY = endingPositionY
            if maxCornerRadius != 0 {
                self.currentDrawerCornerRadius = endingCornerRadius
            }
        }

        if endState == .collapsed {
            animator.addCompletion { _ in
                self.presentedViewController.dismiss(animated: true)
            }
        }

        if maxCornerRadius != 0 && (endState == .collapsed || endState == .fullyExpanded) {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }

    func addCornerRadiusAnimationEnding(at endState: DrawerState) {
        guard maximumCornerRadius != 0
            && drawerPartialY != 0
            && endState != currentDrawerState
            else { return }

        let animator = UIViewPropertyAnimator(duration: durationInSeconds,
                                              timingParameters: timingCurveProvider)

        let endingCornerRadius = cornerRadius(at: endState)
        animator.addAnimations {
            self.currentDrawerCornerRadius = endingCornerRadius
        }

        if endState == .collapsed || endState == .fullyExpanded {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }
}

private extension PresentationController {
    func nextStateFrom(currentState: DrawerState, speedY: CGFloat) -> DrawerState {
        let isNotMoving = (speedY == 0)
        let isMovingUp = (speedY < 0) // recall that Y-axis points down
        let isMovingDown = (speedY > 0)

        let isMovingQuickly = (flickSpeedThreshold != 0) && (abs(speedY) > flickSpeedThreshold)
        let isMovingUpQuickly = isMovingUp && isMovingQuickly
        let isMovingDownQuickly = isMovingDown && isMovingQuickly

        let positionY = drawerPositionY(for: currentState)
        let isAboveUpperMark = (positionY < upperMarkY)
        let isAboveLowerMark = (positionY < lowerMarkY)

        if isMovingUpQuickly { return .fullyExpanded }
        if isMovingDownQuickly { return .collapsed }

        if isAboveUpperMark {
            if isMovingUp || isNotMoving {
                return .fullyExpanded
            } else { // isMovingDown
                let inStages = supportsPartialExpansion && dismissesInStages
                return inStages ? .partiallyExpanded : .collapsed
            }
        }

        if isAboveLowerMark {
            if isMovingDown {
                return .collapsed
            } else { // isMovingUp || isNotMoving
                return (supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded)
            }
        }

        return .collapsed
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

private func equal(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    let epsilon: CGFloat = 1e-6
    return abs(lhs - rhs) <= epsilon
}

private func smallerThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs < rhs || equal(lhs, rhs)
}

private func greaterThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs > rhs || equal(lhs, rhs)
}

// For versions of iOS lower than  11.0
private extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
