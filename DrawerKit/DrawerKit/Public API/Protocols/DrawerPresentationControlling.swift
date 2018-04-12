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
}

extension UIViewController {
    public var drawerPresentationController: DrawerPresentationControlling? {
        return presentationController as? DrawerPresentationControlling
    }
}
