import UIKit

/// A protocol that view controllers presented inside a drawer must conform to.

public protocol DrawerPresentable: class {
    /// The height at which the drawer must be presented when it's in its
    /// partially expanded state. If negative, its value is clamped to zero.
    var heightOfPartiallyExpandedDrawer: CGFloat { get }

    /// The height at which the drawer must be presented when it's in its
    /// collapsed state. If negative, its value is clamped to zero.
    /// Default implementation returns 0.
    var heightOfCollapsedDrawer: CGFloat { get }

    /// Whether the drawer expands to cover the entire screen, the entire screen minus
    /// the status bar, or the entire screen minus a custom gap. If this property
    /// returns `nil` then the value of `fullExpansionBehaviour` in the `DrawerConfiguration`
    /// will be used instead. The default is `nil`.
    var fullExpansionBehaviour: DrawerConfiguration.FullExpansionBehaviour? { get }
}

public extension DrawerPresentable {
    var heightOfCollapsedDrawer: CGFloat { return 0 }
    var fullExpansionBehaviour: DrawerConfiguration.FullExpansionBehaviour? { return nil }
}
