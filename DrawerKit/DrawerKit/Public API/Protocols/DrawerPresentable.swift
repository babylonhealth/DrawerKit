import UIKit

/// A protocol that view controllers presented inside a drawer must conform to.

public protocol DrawerPresentable: class {
    /// The height at which the drawer must be presented when it's in its
    /// partially expanded state. If negative, its value is clamped to zero.
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
}
