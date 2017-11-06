import UIKit

/// Geometric data about a drawer transition, passed to either or both the presenting
/// and presented view controllers as part of `DrawerAnimationInfo`, if they conform
/// to `DrawerAnimationParticipant`.

public struct DrawerGeometry {
    /// The bounds rectangle of the drawer's container view.
    public let containerBounds: CGRect

    /// The drawer's starting frame, in its container view's coordinate system.
    public let startingFrame: CGRect

    /// The drawer's ending frame, in its container view's coordinate system.
    public let endingFrame: CGRect

    /// The navigation bar's current height, if there is a navigation bar.
    /// Otherwise, the value of this property is zero.
    public let navigationBarHeight: CGFloat

    /// The drawer's height in its partially expanded state.
    public let heightOfPartiallyExpandedDrawer: CGFloat

    /// The current user interface orientation.
    public static var userInterfaceOrientation: UIInterfaceOrientation {
        // TODO: should use trait collections... statusBarOrientation is deprecated
        return UIApplication.shared.statusBarOrientation
    }

    /// The status bar's current height.
    public static var statusBarHeight: CGFloat {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        switch userInterfaceOrientation {
        case .portrait, .portraitUpsideDown:
            return statusBarFrame.size.height
        case .landscapeLeft, .landscapeRight:
            return statusBarFrame.size.width
        case .unknown:
            return 0 // May UIKit have mercy on our apps
        }
    }

    internal init(containerBounds: CGRect,
                  startingFrame: CGRect,
                  endingFrame: CGRect,
                  navigationBarHeight: CGFloat,
                  heightOfPartiallyExpandedDrawer: CGFloat) {
        self.containerBounds = containerBounds
        self.startingFrame = startingFrame
        self.endingFrame = endingFrame
        self.navigationBarHeight = navigationBarHeight
        self.heightOfPartiallyExpandedDrawer = heightOfPartiallyExpandedDrawer
    }
}

extension DrawerGeometry: Equatable {
    public static func ==(lhs: DrawerGeometry, rhs: DrawerGeometry) -> Bool {
        return lhs.containerBounds == rhs.containerBounds
            && lhs.startingFrame == rhs.startingFrame
            && lhs.endingFrame == rhs.endingFrame
            && lhs.navigationBarHeight == rhs.navigationBarHeight
            && lhs.heightOfPartiallyExpandedDrawer == rhs.heightOfPartiallyExpandedDrawer
    }
}
