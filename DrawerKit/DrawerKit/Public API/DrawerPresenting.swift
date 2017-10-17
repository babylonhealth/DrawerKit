import UIKit

/// Protocol that view controllers presenting a drawer must conform to.
public protocol DrawerPresenting: class {
    /// An object vended by the presenting view controller, whose responsibility
    /// is to coordinate the presentation, animation, and interactivity of/with
    /// the drawer.
    var drawerDisplayController: DrawerDisplayController? { get }
}
