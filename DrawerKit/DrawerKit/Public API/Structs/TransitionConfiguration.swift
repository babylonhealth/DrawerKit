import UIKit

// All the configurable parameters in one place.

public struct TransitionConfiguration {
    public var totalDurationInSeconds: TimeInterval
    public var timingCurveProvider: UITimingCurveProvider

    public var coversStatusBar: Bool
    public var supportsPartialExpansion: Bool
    public var dismissesInStages: Bool
    public var isDrawerDraggable: Bool

    public var isDismissableByOutsideDrawerTaps: Bool
    public let numberOfTapsForOutsideDrawerDismissal: Int // intentionally immutable

    public init(totalDurationInSeconds: TimeInterval = 0.8,
                timingCurveProvider: UITimingCurveProvider = UISpringTimingParameters(),
                coversStatusBar: Bool = true,
                supportsPartialExpansion: Bool = true,
                dismissesInStages: Bool = true,
                isDrawerDraggable: Bool = true,
                isDismissableByOutsideDrawerTaps: Bool = true,
                numberOfTapsForOutsideDrawerDismissal: Int = 1) {
        self.totalDurationInSeconds = totalDurationInSeconds
        self.timingCurveProvider = timingCurveProvider
        self.coversStatusBar = coversStatusBar
        self.supportsPartialExpansion = supportsPartialExpansion
        self.dismissesInStages = dismissesInStages
        self.isDrawerDraggable = isDrawerDraggable
        self.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
        self.numberOfTapsForOutsideDrawerDismissal = numberOfTapsForOutsideDrawerDismissal
    }
}

extension TransitionConfiguration: Equatable {
    public static func ==(lhs: TransitionConfiguration, rhs: TransitionConfiguration) -> Bool {
        return lhs.totalDurationInSeconds == rhs.totalDurationInSeconds
            && lhs.timingCurveProvider === rhs.timingCurveProvider
            && lhs.coversStatusBar == rhs.coversStatusBar
            && lhs.supportsPartialExpansion == rhs.supportsPartialExpansion
            && lhs.dismissesInStages == rhs.dismissesInStages
            && lhs.isDrawerDraggable == rhs.isDrawerDraggable
            && lhs.isDismissableByOutsideDrawerTaps == rhs.isDismissableByOutsideDrawerTaps
            && lhs.numberOfTapsForOutsideDrawerDismissal == rhs.numberOfTapsForOutsideDrawerDismissal
    }
}
