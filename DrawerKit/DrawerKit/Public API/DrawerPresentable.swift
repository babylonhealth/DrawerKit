import UIKit

/// Protocol that view controllers presented inside a drawer must conform to.
@objc
public protocol DrawerPresentable: class {
    var drawerController: DrawerController { get }
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

