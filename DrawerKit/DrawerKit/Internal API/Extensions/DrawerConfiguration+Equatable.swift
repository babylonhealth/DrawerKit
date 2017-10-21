import UIKit

extension DrawerConfiguration {
    public static func ==(lhs: DrawerConfiguration, rhs: DrawerConfiguration) -> Bool {
        return lhs.durationInSeconds == rhs.durationInSeconds
            && lhs.timingCurveProvider === rhs.timingCurveProvider
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
    }
}
