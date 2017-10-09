import UIKit

// protocol that view controllers presented inside a drawer must conform to
public protocol DrawerPresentable: class {
    weak var drawerTransitionController: TransitionController? { get set }
    var drawerTransitionActions: TransitionActions { get }
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
}

public extension DrawerPresentable where Self: UIViewController {
    public var drawerTransitionActions: TransitionActions {
        return TransitionActions()
    }

    public var heightOfPartiallyExpandedDrawer: CGFloat {
        return 0
    }
}
