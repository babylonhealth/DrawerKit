import UIKit

// protocol that view controllers presenting a drawer must conform to
public protocol DrawerPresenting: class {
    /* strong */ var drawerTransitionController: TransitionController? { get }
    var drawerTransitionActions: TransitionActions { get }
}

public extension DrawerPresenting where Self: UIViewController {
    public var drawerTransitionActions: TransitionActions {
        return TransitionActions()
    }
}
