import UIKit

/// Protocol that view controllers presenting a drawer must conform to.
public protocol DrawerPresenting: class {
    var drawerDisplayController: DrawerDisplayController? { get }
}
