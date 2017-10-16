import UIKit

/// Protocol that view controllers presented inside a drawer must conform to.
public protocol DrawerPresentable: class {
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
}
