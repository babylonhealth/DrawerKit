import UIKit

/// A collection of convenience getter functions to access the drawer
/// geometry data directly from a drawer animation info instance.
///
/// Refer to `DrawerGeometry.swift` for detailed descriptions of the
/// various properties.

extension DrawerAnimationInfo {
    public var containerBounds: CGRect {
        return geometry.containerBounds
    }

    public var startingFrame: CGRect {
        return geometry.startingFrame
    }

    public var endingFrame: CGRect {
        return geometry.endingFrame
    }

    public var userInterfaceOrientation: UIInterfaceOrientation {
        return DrawerGeometry.userInterfaceOrientation
    }

    public var statusBarHeight: CGFloat {
        return DrawerGeometry.statusBarHeight
    }

    public var navigationBarHeight: CGFloat {
        return geometry.navigationBarHeight
    }

    public var heightOfPartiallyExpandedDrawer: CGFloat {
        return geometry.heightOfPartiallyExpandedDrawer
    }
}
