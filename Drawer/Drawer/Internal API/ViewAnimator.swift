import UIKit

final class ViewAnimator: UIViewPropertyAnimator {

    let startVisibleFraction: VisibleFraction
    let endVisibleFraction: VisibleFraction

    init(startVisibleFraction: VisibleFraction,
         endVisibleFraction: VisibleFraction,
         totalDurationInSeconds: TimeInterval,
         curveProvider: UITimingCurveProvider) {

        self.startVisibleFraction = startVisibleFraction
        self.endVisibleFraction = endVisibleFraction

        // This is an alternative way to define the duration, which gives the partial
        // expansion the same duration as the full expansion, whereas the non-commented
        // code gives them the same speed.
        // TODO: make this a configurable option.
        // super.init(duration: totalDurationInSeconds, timingParameters: curveProvider)
        let fractionToGo = abs(endVisibleFraction - startVisibleFraction)
        let duration = TimeInterval(fractionToGo) * totalDurationInSeconds
        super.init(duration: duration, timingParameters: curveProvider)

        self.visibleFraction = startVisibleFraction
    }

    var visibleFraction: VisibleFraction {
        get {
            let value = min(max(fractionComplete, 0), 1)
            return startVisibleFraction + value * visibleFractionRange
        }
        set {
            guard !isRunning else { return }
            let value = min(max(newValue, 0), 1)
            fractionComplete = (value - startVisibleFraction) / visibleFractionRange
        }
    }

    private var visibleFractionRange: VisibleFraction {
        return (endVisibleFraction - startVisibleFraction)
    }
}
