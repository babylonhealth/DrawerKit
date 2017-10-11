import UIKit

/// A collection of convenience getter functions to access the drawer
/// configuration parameters directly from the drawer display controller.
extension DrawerDisplayController {
    public var fullTransitionTimingConfiguration: TimingConfiguration {
        return configuration.fullTransitionTimingConfiguration
    }

    public var partialTransitionTimingConfiguration: TimingConfiguration {
        return configuration.partialTransitionTimingConfiguration
    }

    public var coversStatusBar: Bool {
        return configuration.coversStatusBar
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

    public var upperMarkFraction: CGFloat {
        return configuration.upperMarkFraction
    }

    public var lowerMarkFraction: CGFloat {
        return configuration.lowerMarkFraction
    }

    public var maximumCornerRadius: CGFloat {
        return configuration.maximumCornerRadius
    }
}
