import UIKit

/// All the configurable parameters in one place.
public struct DrawerConfiguration: Equatable {
    public var durationInSeconds: TimeInterval
    public var timingCurveProvider: UITimingCurveProvider

    public var supportsPartialExpansion: Bool
    public var dismissesInStages: Bool
    public var isDrawerDraggable: Bool

    public var isDismissableByOutsideDrawerTaps: Bool
    public var numberOfTapsForOutsideDrawerDismissal: Int

    public var flickSpeedThreshold: CGFloat

    public var upperMarkGap: CGFloat
    public var lowerMarkGap: CGFloat

    public var maximumCornerRadius: CGFloat

    public init(durationInSeconds: TimeInterval = 0.8,
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
        self.numberOfTapsForOutsideDrawerDismissal = numberOfTapsForOutsideDrawerDismissal
        self.flickSpeedThreshold = max(0, flickSpeedThreshold)
        self.upperMarkGap = max(0, upperMarkGap)
        self.lowerMarkGap = max(0, lowerMarkGap)
        self.maximumCornerRadius = maximumCornerRadius
    }
}
