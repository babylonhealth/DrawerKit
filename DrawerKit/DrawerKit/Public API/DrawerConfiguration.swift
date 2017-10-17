import UIKit

/// All the configurable parameters in one place.
/// See `DrawerDisplayController+Configuration.swift` for documentation on
/// what the various parameters are used for.
public struct DrawerConfiguration: Equatable {
    /// How long the animations that move the drawer up and down last.
    /// The default value is 0.3 seconds.
    public var durationInSeconds: TimeInterval

    /// The type of timing curve to use for the animations. The full set
    /// of cubic Bezier curves and spring-based curves is supported. Note
    /// that selecting a spring-based timing curve causes the `durationInSeconds`
    /// parameter to be ignored, because the duration is computed based on the
    /// specifics of the spring-based curve. The default is `UISpringTimingParameters()`,
    /// which is the system's global spring-based timing curve.
    public var timingCurveProvider: UITimingCurveProvider

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


    /// Initialiser for `DrawerConfiguration`.
    public init(durationInSeconds: TimeInterval = 0.3,
                timingCurveProvider: UITimingCurveProvider = UISpringTimingParameters(),
                supportsPartialExpansion: Bool = true,
                dismissesInStages: Bool = true,
                isDrawerDraggable: Bool = true,
                isDismissableByOutsideDrawerTaps: Bool = true,
                numberOfTapsForOutsideDrawerDismissal: Int = 1,
                flickSpeedThreshold: CGFloat = 3,
                upperMarkGap: CGFloat = 40,
                lowerMarkGap: CGFloat = 40,
                maximumCornerRadius: CGFloat = 15) {
        self.durationInSeconds = (durationInSeconds > 0 ? durationInSeconds : 0.8)
        self.timingCurveProvider = timingCurveProvider
        self.supportsPartialExpansion = supportsPartialExpansion
        self.dismissesInStages = dismissesInStages
        self.isDrawerDraggable = isDrawerDraggable
        self.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
        self.numberOfTapsForOutsideDrawerDismissal = max(0, numberOfTapsForOutsideDrawerDismissal)
        self.flickSpeedThreshold = max(0, flickSpeedThreshold)
        self.upperMarkGap = max(0, upperMarkGap)
        self.lowerMarkGap = max(0, lowerMarkGap)
        self.maximumCornerRadius = max(0, maximumCornerRadius)
    }
}
