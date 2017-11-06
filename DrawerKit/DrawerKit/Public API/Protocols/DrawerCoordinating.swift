import UIKit

/// A protocol that objects interested in coordinating drawer presentations must conform to.
/// Note that view controllers *can* conform to this protocol but *need not* do so. Other
/// objects can take that responsibility, if that's more convenient.

public protocol DrawerCoordinating: class {
    /// An object vended by the conforming object, whose responsibility is to control
    /// the presentation, animation, and interactivity of/with the drawer.
    var drawerDisplayController: DrawerDisplayController? { get }
}
