import UIKit

// Convenience functions to get the transition configuration
// parameters directly from the transition controller, purely
// for the benefit of clients to the Drawer library.

extension TransitionController {
    public var totalDurationInSeconds: TimeInterval {
        return configuration.totalDurationInSeconds
    }

    public var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
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
}
