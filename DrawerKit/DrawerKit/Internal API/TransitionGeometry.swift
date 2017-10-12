import UIKit

// TODO: Implement the features that depend on this struct.
// For the moment, this is not being used anywhere.

struct TransitionGeometry {
    var userInterfaceOrientation: UIInterfaceOrientation
    var actualStatusBarHeight: CGFloat
    var navigationBarHeight: CGFloat
    var heightOfPartiallyExpandedDrawer: CGFloat

    init(userInterfaceOrientation: UIInterfaceOrientation,
         actualStatusBarHeight: CGFloat,
         navigationBarHeight: CGFloat,
         heightOfPartiallyExpandedDrawer: CGFloat) {
        self.userInterfaceOrientation = userInterfaceOrientation
        self.actualStatusBarHeight = actualStatusBarHeight
        self.navigationBarHeight = navigationBarHeight
        self.heightOfPartiallyExpandedDrawer = heightOfPartiallyExpandedDrawer
    }
}

extension TransitionGeometry: Equatable {
    static func ==(lhs: TransitionGeometry, rhs: TransitionGeometry) -> Bool {
        return lhs.userInterfaceOrientation == rhs.userInterfaceOrientation
            && lhs.actualStatusBarHeight == rhs.actualStatusBarHeight
            && lhs.navigationBarHeight == rhs.navigationBarHeight
            && lhs.heightOfPartiallyExpandedDrawer == rhs.heightOfPartiallyExpandedDrawer
    }
}
