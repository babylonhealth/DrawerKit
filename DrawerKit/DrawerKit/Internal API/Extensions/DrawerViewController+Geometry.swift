import UIKit

extension DrawerViewController {
    func currentGeometry() -> TransitionGeometry {
        assert(isViewLoaded)
        assert(contentVC != nil)
        contextView.layoutIfNeeded()
        let drawerY = contentVC!.heightOfPartiallyExpandedDrawer
        let navigationBarHeight =
            presenterVC?.navigationController?.navigationBar.bounds.size.height ?? 0

        return TransitionGeometry(contextBounds: contextView.bounds,
                                  drawerFrame: drawerView.frame,
                                  contentFrame: contentVC!.view.frame,
                                  userInterfaceOrientation: userInterfaceOrientation,
                                  actualStatusBarHeight: actualStatusBarHeight,
                                  navigationBarHeight: navigationBarHeight,
                                  heightOfPartiallyExpandedDrawer: drawerY)
    }
}

private extension DrawerViewController {
    var userInterfaceOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }

    var statusBarFrame: CGRect {
        return UIApplication.shared.statusBarFrame
    }

    // TODO: should use trait collections... statusBarOrientation is deprecated
    var actualStatusBarHeight: CGFloat {
        switch userInterfaceOrientation {
        case .portrait, .portraitUpsideDown:
            return statusBarFrame.size.height
        case .landscapeLeft, .landscapeRight:
            return statusBarFrame.size.width
        case .unknown:
            return 0 // May UIKit have mercy on our apps
        }
    }
}
