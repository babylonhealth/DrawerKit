import UIKit

/// All the configurable parameters in one place.
public struct DrawerConfiguration: Equatable {
    public var durationInSeconds: TimeInterval
    public var timingCurveProvider: UITimingCurveProvider

    public var coversStatusBar: Bool
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
                coversStatusBar: Bool = true,
                supportsPartialExpansion: Bool = true,
                dismissesInStages: Bool = true,
                isDrawerDraggable: Bool = true,
                isDismissableByOutsideDrawerTaps: Bool = true,
                numberOfTapsForOutsideDrawerDismissal: Int = 1,
                flickSpeedThreshold: CGFloat = 3,
                upperMarkGap: CGFloat = 40,
                lowerMarkGap: CGFloat = 40,
                maximumCornerRadius: CGFloat = 15) {
        self.durationInSeconds = durationInSeconds
        self.timingCurveProvider = timingCurveProvider
        self.coversStatusBar = coversStatusBar
        self.supportsPartialExpansion = supportsPartialExpansion
        self.dismissesInStages = dismissesInStages
        self.isDrawerDraggable = isDrawerDraggable
        self.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
        self.numberOfTapsForOutsideDrawerDismissal = numberOfTapsForOutsideDrawerDismissal
        self.flickSpeedThreshold = flickSpeedThreshold
        self.upperMarkGap = upperMarkGap
        self.upperMarkGap = upperMarkGap
        self.maximumCornerRadius = maximumCornerRadius
    }
}
