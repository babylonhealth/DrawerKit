import UIKit

// Convenience functions to get the transition configuration
// parameters directly from the drawer view controller.

extension DrawerViewController {
    var totalDurationInSeconds: TimeInterval {
        return configuration.totalDurationInSeconds
    }

    var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    var coversStatusBar: Bool {
        return configuration.coversStatusBar
    }

    var supportsPartialExpansion: Bool {
        return configuration.supportsPartialExpansion
    }

    var dismissesInStages: Bool {
        return configuration.dismissesInStages
    }

    var isDrawerDraggable: Bool {
        return configuration.isDrawerDraggable
    }

    var isDismissableByOutsideDrawerTaps: Bool {
        return configuration.isDismissableByOutsideDrawerTaps
    }

    var numberOfTapsForOutsideDrawerDismissal: Int {
        return configuration.numberOfTapsForOutsideDrawerDismissal
    }
}
