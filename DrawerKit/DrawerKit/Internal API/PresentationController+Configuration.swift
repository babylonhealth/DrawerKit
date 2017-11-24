import UIKit

extension PresentationController {
    var totalDurationInSeconds: TimeInterval {
        return configuration.totalDurationInSeconds
    }

    var durationIsProportionalToDistanceTraveled: Bool {
        return configuration.durationIsProportionalToDistanceTraveled
    }

    var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    var fullExpansionBehaviour: DrawerConfiguration.FullExpansionBehaviour {
        return configuration.fullExpansionBehaviour
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

    var upperMarkGap: CGFloat {
        return configuration.upperMarkGap
    }

    var lowerMarkGap: CGFloat {
        return configuration.lowerMarkGap
    }

    var maximumCornerRadius: CGFloat {
        return configuration.maximumCornerRadius
    }

    var isDrawerDraggable: Bool {
        return configuration.isDrawerDraggable
    }

    var isFullyPresentableByDrawerTaps: Bool {
        return configuration.isFullyPresentableByDrawerTaps
    }

    var numberOfTapsForFullDrawerPresentation: Int {
        return configuration.numberOfTapsForFullDrawerPresentation
    }

    var isDismissableByOutsideDrawerTaps: Bool {
        return configuration.isDismissableByOutsideDrawerTaps
    }

    var numberOfTapsForOutsideDrawerDismissal: Int {
        return configuration.numberOfTapsForOutsideDrawerDismissal
    }

    var handleViewConfiguration: HandleViewConfiguration? {
        return configuration.handleViewConfiguration
    }

    var drawerBorderConfiguration: DrawerBorderConfiguration? {
        return configuration.drawerBorderConfiguration
    }

    var drawerShadowConfiguration: DrawerShadowConfiguration? {
        return configuration.drawerShadowConfiguration
    }
}
