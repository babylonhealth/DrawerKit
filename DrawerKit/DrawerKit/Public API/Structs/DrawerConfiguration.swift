import UIKit

/// All the configurable parameters in one place.

public struct DrawerConfiguration {
    public enum FullExpansionBehaviour: Equatable {
        case coversFullScreen
        case doesNotCoverStatusBar
        case leavesCustomGap(gap: CGFloat)

        var drawerFullY: CGFloat {
            switch self {
            case .coversFullScreen:
                return 0
            case .doesNotCoverStatusBar:
                return DrawerGeometry.statusBarHeight
            case let .leavesCustomGap(gap):
                return gap
            }
        }

        public static func ==(lhs: DrawerConfiguration.FullExpansionBehaviour,
                              rhs: DrawerConfiguration.FullExpansionBehaviour) -> Bool {
            switch (lhs, rhs) {
            case (.coversFullScreen, .coversFullScreen),
                 (.doesNotCoverStatusBar, .doesNotCoverStatusBar):
                return true
            case let (.leavesCustomGap(lhsGap), .leavesCustomGap(rhsGap)):
                return lhsGap == rhsGap
            default:
                return false
            }
        }
    }

    public enum CornerAnimationOption {
        /// The corners would be at their maximum radius when the drawer is
        /// partially expanded, and shrink as the drawer moves away in either
        /// direction.
        case maximumAtPartialY

        /// The corners would be always shown below the status bar at their
        /// maximum radius, and shrink only as the drawer moves into the frame
        /// of the status bar towards the top screen edge.
        case alwaysShowBelowStatusBar
    }

    /// The total duration, in seconds, for the drawer to transition from its
    /// collapsed state to its fully-expanded state, or vice-versa. The default
    /// value is 0.4 seconds.
    public var totalDurationInSeconds: TimeInterval

    /// When the drawer transitions between its collapsed and partially-expanded
    /// states, or between its partially-expanded and its fully-expanded states, in
    /// either direction, the distance traveled by the drawer is some fraction of
    /// the total distance traveled between the collapsed and fully-expanded states.
    /// You have a choice between having those fractional transitions take the same
    /// amount of time as the full transition, and having them take a time that is
    /// a fraction of the total time, where the fraction used is the fraction of
    /// space those partial transitions travel. In the first case, all transitions
    /// have the same duration (`totalDurationInSeconds`) but different speeds, while
    /// in the second case different transitions have different durations but the same
    /// speed. The default is `false`, that is, all transitions last the same amount
    /// of time.
    public var durationIsProportionalToDistanceTraveled: Bool

    /// The type of timing curve to use for the animations. The full set of cubic
    /// Bezier curves and spring-based curves is supported. Note that selecting a
    /// spring-based timing curve may cause the `totalDurationInSeconds` parameter
    /// to be ignored because the duration, for a fully general spring-based timing
    /// curve provider, is computed based on the specifics of the spring-based curve.
    /// The default is `UISpringTimingParameters()`, which is the system's global
    /// spring-based timing curve.
    public var timingCurveProvider: UITimingCurveProvider

    /// Whether the drawer expands to cover the entire screen, the entire screen minus
    /// the status bar, or the entire screen minus a custom gap. The default is to cover
    /// the full screen.
    public var fullExpansionBehaviour: FullExpansionBehaviour

    /// When `true`, the drawer is presented first in its partially expanded state.
    /// When `false`, the presentation is always to full screen and there is no
    /// partially expanded state. The default value is `true`.
    public var supportsPartialExpansion: Bool

    /// When `true`, dismissing the drawer from its fully expanded state can result
    /// in the drawer stopping at its partially expanded state. When `false`, the
    /// dismissal is always straight to the collapsed state. Note that
    /// `supportsPartialExpansion` being `false` implies `dismissesInStages` being
    /// `false` as well but you can have `supportsPartialExpansion == true` and
    /// `dismissesInStages == false`, which would result in presentations to the
    /// partially expanded state but all dismissals would be straight to the collapsed
    /// state. The default value is `true`.
    public var dismissesInStages: Bool

    /// Whether or not the drawer can be dragged up and down. The default value is `true`.
    public var isDrawerDraggable: Bool

    /// Whether or not the drawer can be fully presentable by tapping on it.
    /// The default value is `true`.
    public var isFullyPresentableByDrawerTaps: Bool

    /// How many taps are required for fully presenting the drawer by tapping on it.
    /// The default value is 1.
    public var numberOfTapsForFullDrawerPresentation: Int

    /// Whether or not the drawer can be dismissed by tapping anywhere outside of it.
    /// The default value is `true`.
    public var isDismissableByOutsideDrawerTaps: Bool

    /// How many taps are required for dismissing the drawer by tapping outside of it.
    /// The default value is 1.
    public var numberOfTapsForOutsideDrawerDismissal: Int

    /// How fast one needs to "flick" the drawer up or down to make it ignore the
    /// partially expanded state. Flicking fast enough up always presents to full screen
    /// and flicking fast enough down always collapses the drawer. A typically good value
    /// is around 3 points per screen height per second, and that is also the default
    /// value of this property.
    public var flickSpeedThreshold: CGFloat

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *above* the partially
    /// expanded position. The default value is 40 points.
    public var upperMarkGap: CGFloat

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *below* the partially
    /// expanded position. The default value is 40 points.
    public var lowerMarkGap: CGFloat

    /// The animating drawer also animates the radius of its top left and top right
    /// corners, from 0 to the value of this property. Setting this to 0 prevents any
    /// corner animations from taking place. The default value is 15 points.
    public var maximumCornerRadius: CGFloat

    /// How the drawer should animate its corner radius if specified. The
    /// default value is `maximumAtPartialY`.
    public var cornerAnimationOption: CornerAnimationOption
    
    /// The configuration options for the handle view, should it be shown. Set this
    /// property to `nil` to hide the handle view. The default value is
    /// `HandleViewConfiguration()`.
    public var handleViewConfiguration: HandleViewConfiguration?

    /// The configuration options for the drawer's border, should it be shown. Set this
    /// property to `nil` so as not to have a drawer border. The default value is `nil`.
    public var drawerBorderConfiguration: DrawerBorderConfiguration?

    /// The configuration options for the drawer's shadow, should it be shown. Set this
    /// property to `nil` so as not to have a drawer shadow. The default value is `nil`.
    public var drawerShadowConfiguration: DrawerShadowConfiguration?

    public init(totalDurationInSeconds: TimeInterval = 0.4,
                durationIsProportionalToDistanceTraveled: Bool = false,
                timingCurveProvider: UITimingCurveProvider = UISpringTimingParameters(),
                fullExpansionBehaviour: FullExpansionBehaviour = .coversFullScreen,
                supportsPartialExpansion: Bool = true,
                dismissesInStages: Bool = true,
                isDrawerDraggable: Bool = true,
                isFullyPresentableByDrawerTaps: Bool = true,
                numberOfTapsForFullDrawerPresentation: Int = 1,
                isDismissableByOutsideDrawerTaps: Bool = true,
                numberOfTapsForOutsideDrawerDismissal: Int = 1,
                flickSpeedThreshold: CGFloat = 3,
                upperMarkGap: CGFloat = 40,
                lowerMarkGap: CGFloat = 40,
                maximumCornerRadius: CGFloat = 15,
                cornerAnimationOption: CornerAnimationOption = .maximumAtPartialY,
                handleViewConfiguration: HandleViewConfiguration? = HandleViewConfiguration(),
                drawerBorderConfiguration: DrawerBorderConfiguration? = nil,
                drawerShadowConfiguration: DrawerShadowConfiguration? = nil) {
        self.totalDurationInSeconds = (totalDurationInSeconds > 0 ? totalDurationInSeconds : 0.4)
        self.durationIsProportionalToDistanceTraveled = durationIsProportionalToDistanceTraveled
        self.timingCurveProvider = timingCurveProvider
        switch fullExpansionBehaviour {
        case .coversFullScreen, .doesNotCoverStatusBar:
            self.fullExpansionBehaviour = fullExpansionBehaviour
        case let .leavesCustomGap(gap):
            let validatedGap = max(0, gap)
            self.fullExpansionBehaviour = (validatedGap == 0 ?
                .coversFullScreen : .leavesCustomGap(gap: validatedGap))
        }
        self.supportsPartialExpansion = supportsPartialExpansion
        self.dismissesInStages = dismissesInStages
        self.isDrawerDraggable = isDrawerDraggable
        self.isFullyPresentableByDrawerTaps = isFullyPresentableByDrawerTaps
        self.numberOfTapsForFullDrawerPresentation = max(0, numberOfTapsForFullDrawerPresentation)
        self.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
        self.numberOfTapsForOutsideDrawerDismissal = max(0, numberOfTapsForOutsideDrawerDismissal)
        self.flickSpeedThreshold = max(0, flickSpeedThreshold)
        self.upperMarkGap = max(0, upperMarkGap)
        self.lowerMarkGap = max(0, lowerMarkGap)
        self.maximumCornerRadius = max(0, maximumCornerRadius)
        self.cornerAnimationOption = cornerAnimationOption
        self.handleViewConfiguration = handleViewConfiguration
        self.drawerBorderConfiguration = drawerBorderConfiguration
        self.drawerShadowConfiguration = drawerShadowConfiguration
    }
}

extension DrawerConfiguration: Equatable {
    public static func ==(lhs: DrawerConfiguration, rhs: DrawerConfiguration) -> Bool {
        return lhs.totalDurationInSeconds == rhs.totalDurationInSeconds
            && lhs.durationIsProportionalToDistanceTraveled == rhs.durationIsProportionalToDistanceTraveled
            && lhs.timingCurveProvider === rhs.timingCurveProvider
            && lhs.fullExpansionBehaviour == rhs.fullExpansionBehaviour
            && lhs.supportsPartialExpansion == rhs.supportsPartialExpansion
            && lhs.dismissesInStages == rhs.dismissesInStages
            && lhs.isDrawerDraggable == rhs.isDrawerDraggable
            && lhs.isFullyPresentableByDrawerTaps == rhs.isFullyPresentableByDrawerTaps
            && lhs.numberOfTapsForFullDrawerPresentation == rhs.numberOfTapsForFullDrawerPresentation
            && lhs.isDismissableByOutsideDrawerTaps == rhs.isDismissableByOutsideDrawerTaps
            && lhs.numberOfTapsForOutsideDrawerDismissal == rhs.numberOfTapsForOutsideDrawerDismissal
            && lhs.flickSpeedThreshold == rhs.flickSpeedThreshold
            && lhs.upperMarkGap == rhs.upperMarkGap
            && lhs.lowerMarkGap == rhs.lowerMarkGap
            && lhs.maximumCornerRadius == rhs.maximumCornerRadius
            && lhs.handleViewConfiguration == rhs.handleViewConfiguration
            && lhs.drawerBorderConfiguration == rhs.drawerBorderConfiguration
            && lhs.drawerShadowConfiguration == rhs.drawerShadowConfiguration
    }
}
