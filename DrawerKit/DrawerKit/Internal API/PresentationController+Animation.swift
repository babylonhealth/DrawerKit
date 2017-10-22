import UIKit

extension PresentationController {
    func animateTransition(to endState: DrawerState) {
        guard endState != currentDrawerState else { return }

        let maxCornerRadius = maximumCornerRadius
        let endingCornerRadius = cornerRadius(at: endState)
        let endingPositionY = drawerPositionY(for: endState)

        let duration = actualTransitionDuration(for: endingPositionY)
        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: timingCurveProvider)

        animator.addAnimations {
            self.currentDrawerY = endingPositionY
            if maxCornerRadius != 0 {
                self.currentDrawerCornerRadius = endingCornerRadius
            }
        }

        if endState == .collapsed {
            animator.addCompletion { _ in
                self.presentedViewController.dismiss(animated: true)
            }
        }

        if maxCornerRadius != 0 && (endState == .collapsed || endState == .fullyExpanded) {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }

    func addCornerRadiusAnimationEnding(at endState: DrawerState) {
        guard maximumCornerRadius != 0 && drawerPartialY != 0
            && endState != currentDrawerState else { return }

        let endingPositionY = drawerPositionY(for: endState)
        let duration = actualTransitionDuration(for: endingPositionY)
        let animator = UIViewPropertyAnimator(duration: duration,
                                              timingParameters: timingCurveProvider)

        let endingCornerRadius = cornerRadius(at: endState)
        animator.addAnimations {
            self.currentDrawerCornerRadius = endingCornerRadius
        }

        if endState == .collapsed || endState == .fullyExpanded {
            animator.addCompletion { _ in
                self.currentDrawerCornerRadius = 0
            }
        }

        animator.startAnimation()
    }

    func actualTransitionDuration(for endingPositionY: CGFloat) -> TimeInterval {
        var duration = totalDurationInSeconds
        if durationIsProportionalToDistanceTraveled {
            let fractionToGo = abs(endingPositionY - currentDrawerY) / containerViewH
            duration *= TimeInterval(fractionToGo)
        }
        return duration
    }
}
