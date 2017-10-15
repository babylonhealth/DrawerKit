import UIKit

/// A collection of convenience getter functions to access the drawer
/// configuration parameters directly from the drawer display controller.
extension DrawerDisplayController {
    /// How long the animations that move the drawer up and down last.
    /// The default value is 0.8 seconds.
    public var durationInSeconds: TimeInterval {
        return configuration.durationInSeconds
    }

    /// The type of timing curve to use for the animations. The full set
    /// of cubic Bezier curves and spring-based curves is supported. Note
    /// that selecting a spring-based timing curve causes the `durationInSeconds`
    /// parameter to be ignored, because the duration is computed based on the
    /// specifics of the spring-based curve. The default is `UISpringTimingParameters()`,
    /// which is the system's global spring-based timing curve.
    public var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    /// When `true`, the drawer is presented first in its partially expanded state.
    /// When `false`, the presentation is always to full screen and there is no
    /// partially expanded state. The default value is `true`.
    public var supportsPartialExpansion: Bool {
        return configuration.supportsPartialExpansion
    }

    /// When `true`, dismissing the drawer from its fully expanded state can result
    /// in the drawer stopping at its partially expanded state. When `false`, the
    /// dismissal is always straight to the collapsed state. Note that
    /// `supportsPartialExpansion` being `false` implies `dismissesInStages` being
    /// `false` as well but you can have `supportsPartialExpansion == true` and
    /// `dismissesInStages == false`, which would result in presentations to the
    /// partially expanded state but all dismissals would be straight to the collapsed
    /// state. The default value is `true`.
    public var dismissesInStages: Bool {
        return configuration.dismissesInStages
    }

    /// Whether or not the drawer can be dragged up and down. The default value is `true`.
    public var isDrawerDraggable: Bool {
        return configuration.isDrawerDraggable
    }

    /// Whether or not the drawer can be dismissed by tapping anywhere outside of it.
    /// The default value is `true`.
    public var isDismissableByOutsideDrawerTaps: Bool {
        return configuration.isDismissableByOutsideDrawerTaps
    }

    /// How many taps are required for dismissing the drawer by tapping outside of it.
    /// The default value is 1.
    public var numberOfTapsForOutsideDrawerDismissal: Int {
        return configuration.numberOfTapsForOutsideDrawerDismissal
    }

    /// How fast one needs to "flick" the drawer up or down to make it ignore the
    /// partially expanded state. Flicking fast enough up always presents to full screen
    /// and flicking fast enough down always collapses the drawer. A typically good value
    /// is around 3 points per screen height per second, and that is also the default
    /// value of this property.
    public var flickSpeedThreshold: CGFloat {
        return configuration.flickSpeedThreshold
    }

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *above* the partially
    /// expanded position. The default value is 40 points.
    public var upperMarkGap: CGFloat {
        return configuration.upperMarkGap
    }

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *below* the partially
    /// expanded position. The default value is 40 points.
    public var lowerMarkGap: CGFloat {
        return configuration.lowerMarkGap
    }

    /// The animating drawer also animates the radius of its top left and top right
    /// corners, from 0 to the value of this property. Setting this to 0 prevents any
    /// corner animations from taking place. The default value is 15 points.
    public var maximumCornerRadius: CGFloat {
        return configuration.maximumCornerRadius
    }
}
