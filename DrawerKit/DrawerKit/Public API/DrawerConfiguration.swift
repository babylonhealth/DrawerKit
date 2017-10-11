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

    public var upperMarkFraction: CGFloat
    public var lowerMarkFraction: CGFloat

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
                upperMarkFraction: CGFloat = 0.5,
                lowerMarkFraction: CGFloat = 0.5,
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
        self.upperMarkFraction = upperMarkFraction
        self.lowerMarkFraction = lowerMarkFraction
        self.maximumCornerRadius = maximumCornerRadius
    }
}
