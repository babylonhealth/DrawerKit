import UIKit

/// Geometric data about a drawer transition, passed to either or both the presenting
/// and presented view controllers as part of `DrawerAnimationInfo`, if they conform
/// to `DrawerAnimationParticipant`.

public struct DrawerGeometry {
    /// The bounds rectangle of the drawer's container view.
    public let containerBounds: CGRect

    /// The drawer's frame, in its container view's coordinate system.
    public let drawerFrame: CGRect

    /// The current user interface orientation.
    public let userInterfaceOrientation: UIInterfaceOrientation

    /// The status bar's current height.
    public let statusBarHeight: CGFloat

    /// The navigation bar's current height, if there is a navigation bar.
    /// Otherwise, the value of this property is zero.
    public let navigationBarHeight: CGFloat

    /// The drawer's height in its partially expanded state.
    public let heightOfPartiallyExpandedDrawer: CGFloat

    internal init(containerBounds: CGRect,
                  drawerFrame: CGRect,
                  userInterfaceOrientation: UIInterfaceOrientation,
                  statusBarHeight: CGFloat,
                  navigationBarHeight: CGFloat,
                  heightOfPartiallyExpandedDrawer: CGFloat) {
        self.containerBounds = containerBounds
        self.drawerFrame = drawerFrame
        self.userInterfaceOrientation = userInterfaceOrientation
        self.statusBarHeight = statusBarHeight
        self.navigationBarHeight = navigationBarHeight
        self.heightOfPartiallyExpandedDrawer = heightOfPartiallyExpandedDrawer
    }
}

extension DrawerGeometry: Equatable {
    public static func ==(lhs: DrawerGeometry, rhs: DrawerGeometry) -> Bool {
        return lhs.containerBounds == rhs.containerBounds
            && lhs.drawerFrame == rhs.drawerFrame
            && lhs.userInterfaceOrientation == rhs.userInterfaceOrientation
            && lhs.statusBarHeight == rhs.statusBarHeight
            && lhs.navigationBarHeight == rhs.navigationBarHeight
            && lhs.heightOfPartiallyExpandedDrawer == rhs.heightOfPartiallyExpandedDrawer
    }
}
