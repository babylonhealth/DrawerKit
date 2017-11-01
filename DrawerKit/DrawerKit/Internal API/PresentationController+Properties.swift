import UIKit

extension PresentationController {
    var containerViewBounds: CGRect {
        return containerView?.bounds ?? .zero
    }

    var containerViewSize: CGSize {
        return containerViewBounds.size
    }

    var containerViewH: CGFloat {
        return containerViewSize.height
    }

    var drawerPartialH: CGFloat {
        guard let presentedVC = presentedViewController as? DrawerPresentable else { return 0 }
        let drawerPartialH = presentedVC.heightOfPartiallyExpandedDrawer
        return GeometryEvaluator.drawerPartialH(drawerPartialHeight: drawerPartialH,
                                                containerViewHeight: containerViewH)
    }

    var drawerPartialY: CGFloat {
        return GeometryEvaluator.drawerPartialY(drawerPartialHeight: drawerPartialH,
                                                containerViewHeight: containerViewH)
    }

    var upperMarkY: CGFloat {
        return GeometryEvaluator.upperMarkY(drawerPartialHeight: drawerPartialH,
                                            containerViewHeight: containerViewH,
                                            configuration: configuration)
    }

    var lowerMarkY: CGFloat {
        return GeometryEvaluator.lowerMarkY(drawerPartialHeight: drawerPartialH,
                                            containerViewHeight: containerViewH,
                                            configuration: configuration)
    }

    var currentDrawerState: DrawerState {
        get {
            return GeometryEvaluator.drawerState(for: currentDrawerY,
                                                 drawerPartialHeight: drawerPartialH,
                                                 containerViewHeight: containerViewH,
                                                 configuration: configuration)
        }

        set {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            currentDrawerY =
                GeometryEvaluator.drawerPositionY(for: newValue,
                                                  drawerPartialHeight: drawerPartialH,
                                                  containerViewHeight: containerViewH,
                                                  drawerFullY: drawerFullY)
        }
    }

    var currentDrawerY: CGFloat {
        get {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let posY = presentedView?.frame.origin.y ?? drawerFullY
            return min(max(posY, drawerFullY), containerViewH)
        }

        set {
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let posY = min(max(newValue, drawerFullY), containerViewH)
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
        return maximumCornerRadius * triangularValue(at: state)
    }

    func handleViewAlpha(at state: DrawerState) -> CGFloat {
        return triangularValue(at: state)
    }

    private func triangularValue(at state: DrawerState) -> CGFloat {
        let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
        guard drawerPartialY != drawerFullY
            && drawerPartialY != containerViewH
            && drawerFullY != containerViewH
            else { return 0 }

        let positionY =
            GeometryEvaluator.drawerPositionY(for: state,
                                              drawerPartialHeight: drawerPartialH,
                                              containerViewHeight: containerViewH,
                                              drawerFullY: drawerFullY)

        let fraction: CGFloat
        if supportsPartialExpansion {
            if positionY < drawerPartialY {
                fraction = (positionY - drawerFullY) / (drawerPartialY - drawerFullY)
            } else {
                fraction = 1 - (positionY - drawerPartialY) / (containerViewH - drawerPartialY)
            }
        } else {
            fraction = 1 - (positionY - drawerFullY) / (containerViewH - drawerFullY)
        }

        return fraction
    }
}
