import UIKit

extension TransitionGeometry {
    // Used only to avoid having to declare geometry as an optional or IUO
    init() {
        self.contextBounds = .zero
        self.drawerFrame =  .zero
        self.contentFrame = .zero
        self.userInterfaceOrientation = .unknown
        self.actualStatusBarHeight = 0
        self.navigationBarHeight = 0
        self.heightOfPartiallyExpandedDrawer = 0
    }
}
