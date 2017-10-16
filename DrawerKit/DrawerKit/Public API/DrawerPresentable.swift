import UIKit

/// Protocol that view controllers presented inside a drawer must conform to.
public protocol DrawerPresentable: UIViewControllerTransitioningDelegate, UIAdaptivePresentationControllerDelegate {
    var drawerConfiguration: DrawerConfiguration { get }
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
    var inDrawerDebugMode: Bool { get }
}

//public extension DrawerPresentable where Self: UIViewController {
//    public var drawerConfiguration: DrawerConfiguration {
//        return DrawerConfiguration()
//    }
//
//    public var heightOfPartiallyExpandedDrawer: CGFloat {
//        return 0
//    }
//
//    public var inDrawerDebugMode: Bool {
//        return false
//    }
//}

