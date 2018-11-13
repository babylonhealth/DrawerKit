public protocol DrawerPresentationControlling: class {
    /// The scroll view to enable pull-to-dismiss on the drawer. It can be
    /// placed at any origin of any arbitrary size.
    ///
    /// The drawer materialises pull-to-dismiss by installing an internal
    /// controller as the scroll view delegate, and manipulating the vertical
    /// content offset.
    ///
    /// - important: If the navigation bar is non-translucent, it is strongly
    ///              recommended _not to use_ the `coversFullscreen` full
    ///              expansion behavior due to interoperability issues with the
    ///              obscure `UINavigationBar` Large Title mechanism.
    ///
    /// - note: The drawer presentation controller does not retain the view.
    var scrollViewForPullToDismiss: UIScrollView? { get set }

    /// Changes the state of the drawer.
    /// - parameters:
    ///   - state: the new drawer state. Passing `.dismissed` value will dismiss the presented view controller.
    ///            It's not allowed to pass `.transitioning` state, passing it will result in `fatalError`.
    ///
    ///   - animateAlongside: closure to perform alongside transition, default is `nil`.
    ///
    ///   - animated: whether the state change should be animated, default is `true`.
    ///
    ///   - completion: a closure to be called when the state transition finishes, default is `nil`.
    func setDrawerState(_ state: DrawerState, animated: Bool, animateAlongside: (() -> Void)?, completion: (() -> Void)?)
}

extension DrawerPresentationControlling {
    public func setDrawerState(_ state: DrawerState, animateAlongside: (() -> Void)? = nil, animated: Bool = true) {
        setDrawerState(state, animated: animated, animateAlongside: animateAlongside, completion: nil)
    }
}

extension UIViewController {
    public var drawerPresentationController: DrawerPresentationControlling? {
        guard let controller = presentationController as? DrawerPresentationControlling else {
            return navigationController?.drawerPresentationController
        }
        return controller
    }
}
