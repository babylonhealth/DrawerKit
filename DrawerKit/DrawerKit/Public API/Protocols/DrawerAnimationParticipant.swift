import UIKit

/// A protocol that either or both the presenting and presented view controllers should
/// conform to if they want to animate their views alongside drawer transition animations.

public protocol DrawerAnimationParticipant: class {
    /// An instance vended by the conforming object, containing the closures for
    /// preparing, animating along, and cleaning up before, during, and after a
    /// drawer transition animation.
    var drawerAnimationActions: DrawerAnimationActions { get }
}

extension DrawerAnimationParticipant {
    public var drawerAnimationActions: DrawerAnimationActions {
        return DrawerAnimationActions()
    }
}
