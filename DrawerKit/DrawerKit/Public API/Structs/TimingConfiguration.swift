import UIKit

public struct TimingConfiguration: Equatable {
    public var durationInSeconds: TimeInterval
    public var timingCurveProvider: UITimingCurveProvider

    public init(durationInSeconds: TimeInterval = 0.8,
                timingCurveProvider: UITimingCurveProvider = UISpringTimingParameters()) {
        self.durationInSeconds = durationInSeconds
        self.timingCurveProvider = timingCurveProvider
    }
}
