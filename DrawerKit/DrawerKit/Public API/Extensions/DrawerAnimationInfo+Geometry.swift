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

    public var drawerFrame: CGRect {
        return geometry.drawerFrame
    }

    public var userInterfaceOrientation: UIInterfaceOrientation {
        return geometry.userInterfaceOrientation
    }

    public var statusBarHeight: CGFloat {
        return geometry.statusBarHeight
    }

    public var navigationBarHeight: CGFloat {
        return geometry.navigationBarHeight
    }

    public var heightOfPartiallyExpandedDrawer: CGFloat {
        return geometry.heightOfPartiallyExpandedDrawer
    }
}
