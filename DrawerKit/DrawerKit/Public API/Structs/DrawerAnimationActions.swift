import Foundation

/// View controllers conforming to the `DrawerAnimationParticipant` protocol are
/// expected to provide an instance of this structure so that the closures in it
/// are called at appropriate times during a drawer transition to inform those
/// view controllers and give them a chance to prepare, animate along, and/or
/// cleanup their views before, during, and/or after a drawer transition takes place.

public struct DrawerAnimationActions {
    public typealias PrepareSignature = (_ info: DrawerAnimationInfo) -> Void
    public typealias AnimateAlongSignature = (_ info: DrawerAnimationInfo) -> Void
    public typealias CleanupSignature = (_ info: DrawerAnimationInfo) -> Void

    public init(prepare: PrepareSignature? = nil,
                animateAlong: AnimateAlongSignature? = nil,
                cleanup: CleanupSignature? = nil) {
        self.prepare = prepare
        self.animateAlong = animateAlong
        self.cleanup = cleanup
    }

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now prepare their views for the drawer transition animation
    /// about to start.
    public var prepare: PrepareSignature?

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now perform animations in their views along with the drawer
    /// transition animation currently in progress.
    public var animateAlong: AnimateAlongSignature?

    /// A closure used as a call-back by the drawer transition process to inform
    /// the view controllers involved, if they conform to `DrawerAnimationParticipant`,
    /// that they can now cleanup their views since the drawer transition animation
    /// has completed.
    public var cleanup: CleanupSignature?
}
