import UIKit

extension PresentationController {
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
        guard maximumCornerRadius != 0 && drawerPartialY != 0
            && drawerPartialY != containerViewH else { return 0 }

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
