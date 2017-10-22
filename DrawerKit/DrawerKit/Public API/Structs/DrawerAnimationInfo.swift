import UIKit

/// Data passed to either or both the presenting and presented view controllers,
/// if they conform to `DrawerAnimationParticipant`, for them to prepare, animate along,
/// and/or cleanup their views before, during, and/or after a drawer transition.

public struct DrawerAnimationInfo {
    /// The configuration parameters the drawer presentation was initialised with.
    public let configuration: DrawerConfiguration

    /// Geometric data associated with the drawer transition being reported, useful
    /// for conforming view controllers to make decisions about their views before,
    /// during, and/or after the drawer transition takes place.
    public let geometry: DrawerGeometry

    /// The duration, in seconds, for the drawer transition being reported. Note
    /// that this need not be equal to `configuration.totalDurationInSeconds`.
    public let actualDurationInSeconds: TimeInterval

    /// Whether the drawer transition being reported corresponds to a presentation
    /// or dismissal.
    public let isPresenting: Bool

    /// The starting state for the drawer transition being reported.
    public let startDrawerState: DrawerState

    /// The drawer state at which the drawer is supposed to end, for the drawer
    /// transition being reported.
    public let targetDrawerState: DrawerState

    /// The ending state for the drawer transition being reported. Note that it need
    /// not be the same state as `targetDrawerState`. See `endPosition` below for
    /// more details.
    public let endDrawerState: DrawerState

    /// The transition being reported is from some starting state to a desired ending
    /// state but the user may cancel or otherwise interactively change the transition
    /// and it may end at a different drawer state. If it ends at the target ending
    /// state, then the value of this property is `.end`; if it ends back at the starting
    /// state, then the value of this property is `.start`; if it ends somewhere else
    /// in between, then the value of this property is `.current`. This last case should
    /// actually never happen for reported transitions.
    public internal(set) var endPosition: UIViewAnimatingPosition?

    internal init(configuration: DrawerConfiguration,
                  geometry: DrawerGeometry,
                  actualDurationInSeconds: TimeInterval,
                  isPresenting: Bool,
                  startDrawerState: DrawerState,
                  targetDrawerState: DrawerState,
                  endDrawerState: DrawerState,
                  endPosition: UIViewAnimatingPosition? = nil) {
        self.configuration = configuration
        self.geometry = geometry
        self.actualDurationInSeconds = actualDurationInSeconds
        self.isPresenting = isPresenting
        self.startDrawerState = startDrawerState
        self.targetDrawerState = targetDrawerState
        self.endDrawerState = endDrawerState
        self.endPosition = endPosition
    }
}

extension DrawerAnimationInfo: Equatable {
    public static func ==(lhs: DrawerAnimationInfo, rhs: DrawerAnimationInfo) -> Bool {
        return lhs.configuration == rhs.configuration
            && lhs.geometry == rhs.geometry
            && lhs.actualDurationInSeconds == rhs.actualDurationInSeconds
            && lhs.isPresenting == rhs.isPresenting
            && lhs.startDrawerState == rhs.startDrawerState
            && lhs.targetDrawerState == rhs.targetDrawerState
            && lhs.endDrawerState == rhs.endDrawerState
            && lhs.endPosition == rhs.endPosition
    }
}
