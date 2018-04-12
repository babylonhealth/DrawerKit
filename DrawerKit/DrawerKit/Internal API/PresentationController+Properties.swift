import UIKit

extension PresentationController {
    var containerViewBounds: CGRect {
        return containerView?.bounds ?? .zero
    }

    var containerViewSize: CGSize {
        return containerViewBounds.size
    }

    var containerViewHeight: CGFloat {
        return containerViewSize.height
    }

    var drawerPartialHeight: CGFloat {
        guard let presentedVC = presentedViewController as? DrawerPresentable else { return 0 }
        let drawerPartialH = presentedVC.heightOfPartiallyExpandedDrawer
        return GeometryEvaluator.drawerPartialH(drawerPartialHeight: drawerPartialH,
                                                containerViewHeight: containerViewHeight)
    }

    var drawerPartialY: CGFloat {
        return GeometryEvaluator.drawerPartialY(drawerPartialHeight: drawerPartialHeight,
                                                containerViewHeight: containerViewHeight)
    }

    var upperMarkY: CGFloat {
        return GeometryEvaluator.upperMarkY(drawerPartialHeight: drawerPartialHeight,
                                            containerViewHeight: containerViewHeight,
                                            configuration: configuration)
    }

    var lowerMarkY: CGFloat {
        return GeometryEvaluator.lowerMarkY(drawerPartialHeight: drawerPartialHeight,
                                            containerViewHeight: containerViewHeight,
                                            configuration: configuration)
    }

    var currentDrawerState: DrawerState {
        get {
            return GeometryEvaluator.drawerState(for: currentDrawerY,
                                                 drawerPartialHeight: drawerPartialHeight,
                                                 containerViewHeight: containerViewHeight,
                                                 configuration: configuration)
        }

        set {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            currentDrawerY =
                GeometryEvaluator.drawerPositionY(for: newValue,
                                                  drawerPartialHeight: drawerPartialHeight,
                                                  containerViewHeight: containerViewHeight,
                                                  drawerFullY: drawerFullY)
        }
    }

    var currentDrawerY: CGFloat {
        get {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let posY = presentedView?.frame.origin.y ?? drawerFullY
            return min(max(posY, drawerFullY), containerViewHeight)
        }

        set {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let posY = min(max(newValue, drawerFullY), containerViewHeight)
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
                presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
    }

    func cornerRadius(at state: DrawerState) -> CGFloat {
        switch configuration.cornerAnimationOption {
        case .maximumAtPartialY:
            return maximumCornerRadius * triangularValue(at: state)
        case .alwaysShowBelowStatusBar:
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let positionY =
                GeometryEvaluator.drawerPositionY(for: state,
                                                  drawerPartialHeight: drawerPartialHeight,
                                                  containerViewHeight: containerViewHeight,
                                                  drawerFullY: drawerFullY)

            return maximumCornerRadius * min(positionY, DrawerGeometry.statusBarHeight) / DrawerGeometry.statusBarHeight

        }
    }

    func handleViewAlpha(at state: DrawerState) -> CGFloat {
        return triangularValue(at: state)
    }

    private func triangularValue(at state: DrawerState) -> CGFloat {
        let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
        guard drawerPartialY != drawerFullY
            && drawerPartialY != containerViewHeight
            && drawerFullY != containerViewHeight
            else { return 0 }

        let positionY =
            GeometryEvaluator.drawerPositionY(for: state,
                                              drawerPartialHeight: drawerPartialHeight,
                                              containerViewHeight: containerViewHeight,
                                              drawerFullY: drawerFullY)

        let fraction: CGFloat
        if supportsPartialExpansion {
            if positionY < drawerPartialY {
                fraction = (positionY - drawerFullY) / (drawerPartialY - drawerFullY)
            } else {
                fraction = 1 - (positionY - drawerPartialY) / (containerViewHeight - drawerPartialY)
            }
        } else {
            fraction = 1 - (positionY - drawerFullY) / (containerViewHeight - drawerFullY)
        }

        return fraction
    }
}
