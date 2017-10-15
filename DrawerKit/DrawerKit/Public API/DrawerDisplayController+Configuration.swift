import UIKit

/// A collection of convenience getter functions to access the drawer
/// configuration parameters directly from the drawer display controller.
extension DrawerDisplayController {
    public var durationInSeconds: TimeInterval {
        return configuration.durationInSeconds
    }

    public var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    public var supportsPartialExpansion: Bool {
        return configuration.supportsPartialExpansion
    }

    public var dismissesInStages: Bool {
        return configuration.dismissesInStages
    }

    public var isDrawerDraggable: Bool {
        return configuration.isDrawerDraggable
    }

    public var isDismissableByOutsideDrawerTaps: Bool {
        return configuration.isDismissableByOutsideDrawerTaps
    }

    public var numberOfTapsForOutsideDrawerDismissal: Int {
        return configuration.numberOfTapsForOutsideDrawerDismissal
    }

    public var flickSpeedThreshold: CGFloat {
        return configuration.flickSpeedThreshold
    }

    public var upperMarkGap: CGFloat {
        return configuration.upperMarkGap
    }

    public var lowerMarkGap: CGFloat {
        return configuration.lowerMarkGap
    }

    public var maximumCornerRadius: CGFloat {
        return configuration.maximumCornerRadius
    }
}
