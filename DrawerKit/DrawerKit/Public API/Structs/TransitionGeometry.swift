import UIKit

// Geometric data about a transition, needed to compute the next drawer state;
// also passed to view controllers as part of TransitionInformation.

public struct TransitionGeometry {
    public var contextBounds: CGRect
    public var drawerFrame: CGRect  // in the coordinate system of the context view
    public var contentFrame: CGRect // in the coordinate system of the drawer view
    public var userInterfaceOrientation: UIInterfaceOrientation
    public var actualStatusBarHeight: CGFloat
    public var navigationBarHeight: CGFloat
    public var heightOfPartiallyExpandedDrawer: CGFloat

    internal init(contextBounds: CGRect,
                  drawerFrame: CGRect,
                  contentFrame: CGRect,
                  userInterfaceOrientation: UIInterfaceOrientation,
                  actualStatusBarHeight: CGFloat,
                  navigationBarHeight: CGFloat,
                  heightOfPartiallyExpandedDrawer: CGFloat) {
        self.contextBounds = contextBounds
        self.drawerFrame = drawerFrame
        self.contentFrame = contentFrame
        self.userInterfaceOrientation = userInterfaceOrientation
        self.actualStatusBarHeight = actualStatusBarHeight
        self.navigationBarHeight = navigationBarHeight
        self.heightOfPartiallyExpandedDrawer = heightOfPartiallyExpandedDrawer
    }
}

extension TransitionGeometry: Equatable {
    public static func ==(lhs: TransitionGeometry, rhs: TransitionGeometry) -> Bool {
        return lhs.contextBounds == rhs.contextBounds
            && lhs.drawerFrame == rhs.drawerFrame
            && lhs.contentFrame == rhs.contentFrame
            && lhs.userInterfaceOrientation == rhs.userInterfaceOrientation
            && lhs.actualStatusBarHeight == rhs.actualStatusBarHeight
            && lhs.navigationBarHeight == rhs.navigationBarHeight
            && lhs.heightOfPartiallyExpandedDrawer == rhs.heightOfPartiallyExpandedDrawer
    }
}
