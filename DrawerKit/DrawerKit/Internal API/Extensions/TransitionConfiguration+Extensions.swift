import UIKit

extension DrawerConfiguration {
    public static func ==(lhs: DrawerConfiguration, rhs: DrawerConfiguration) -> Bool {
        return lhs.fullTransitionTimingConfiguration == rhs.fullTransitionTimingConfiguration
            && lhs.partialTransitionTimingConfiguration == rhs.partialTransitionTimingConfiguration
            && lhs.coversStatusBar == rhs.coversStatusBar
            && lhs.supportsPartialExpansion == rhs.supportsPartialExpansion
            && lhs.dismissesInStages == rhs.dismissesInStages
            && lhs.isDrawerDraggable == rhs.isDrawerDraggable
            && lhs.isDismissableByOutsideDrawerTaps == rhs.isDismissableByOutsideDrawerTaps
            && lhs.numberOfTapsForOutsideDrawerDismissal == rhs.numberOfTapsForOutsideDrawerDismissal
            && lhs.flickSpeedThreshold == rhs.flickSpeedThreshold
            && lhs.upperMarkFraction == rhs.upperMarkFraction
            && lhs.lowerMarkFraction == rhs.lowerMarkFraction
            && lhs.maximumCornerRadius == rhs.maximumCornerRadius
    }
}
