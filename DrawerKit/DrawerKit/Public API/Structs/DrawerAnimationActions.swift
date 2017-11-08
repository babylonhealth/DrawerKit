import Foundation

/// View controllers conforming to the `DrawerAnimationParticipant` protocol are
/// expected to provide an instance of this structure so that the closures in it
/// are called at appropriate times during a drawer transition to inform those
/// view controllers and give them a chance to prepare, animate along, and/or
/// cleanup their views before, during, and/or after a drawer transition takes place.

public struct DrawerAnimationActions {
    public typealias PrepareHandler = (_ info: DrawerAnimationInfo) -> Void
    public typealias AnimateAlongHandler = (_ info: DrawerAnimationInfo) -> Void
    public typealias CleanupHandler = (_ info: DrawerAnimationInfo) -> Void

    public init(prepare: PrepareHandler? = nil,
                animateAlong: AnimateAlongHandler? = nil,
                cleanup: CleanupHandler? = nil) {
        self.prepare = prepare
        self.animateAlong = animateAlong
        self.cleanup = cleanup
    }

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now prepare their views for the drawer transition animation
    /// about to start.
    let prepare: PrepareHandler?

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now perform animations in their views along with the drawer
    /// transition animation currently in progress.
    let animateAlong: AnimateAlongHandler?

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now cleanup their views since the drawer transition animation
    /// has completed.
    let cleanup: CleanupHandler?
}
