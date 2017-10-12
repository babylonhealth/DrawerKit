import UIKit

extension PresentationController {
    var durationInSeconds: TimeInterval {
        return configuration.durationInSeconds
    }

    var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    var supportsPartialExpansion: Bool {
        return configuration.supportsPartialExpansion
    }

    var dismissesInStages: Bool {
        return configuration.dismissesInStages
    }

    var flickSpeedThreshold: CGFloat {
        return configuration.flickSpeedThreshold
    }

    var upperMarkFraction: CGFloat {
        return configuration.upperMarkFraction
    }

    var lowerMarkFraction: CGFloat {
        return configuration.lowerMarkFraction
    }

    var maximumCornerRadius: CGFloat {
        return configuration.maximumCornerRadius
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
