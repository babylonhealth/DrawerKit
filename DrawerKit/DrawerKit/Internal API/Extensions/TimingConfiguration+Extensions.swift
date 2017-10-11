import UIKit

extension TimingConfiguration {
    public static func ==(lhs: TimingConfiguration, rhs: TimingConfiguration) -> Bool {
        return lhs.durationInSeconds == rhs.durationInSeconds
            && lhs.timingCurveProvider === rhs.timingCurveProvider
    }
}
