import UIKit

/// Protocol that view controllers presented inside a drawer must conform to.
public protocol DrawerPresentable: class {
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
}

public extension DrawerPresentable where Self: UIViewController {
    public var heightOfPartiallyExpandedDrawer: CGFloat {
        return 0
    }
}
