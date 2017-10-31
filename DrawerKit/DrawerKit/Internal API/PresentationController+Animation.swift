import UIKit

extension PresentationController {
    func animateTransition(to endingState: DrawerState) {
        guard endingState != currentDrawerState else { return }

        let startingState = currentDrawerState

        let maxCornerRadius = maximumCornerRadius
        let endingCornerRadius = cornerRadius(at: endingState)

        let (startingPositionY, endingPositionY) = positionsY(startingState: startingState,
                                                              endingState: endingState)

        let animator = makeAnimator(startingPositionY: startingPositionY,
                                    endingPositionY: endingPositionY)

        let presentingVC = presentingViewController
        let presentedVC = presentedViewController

        let presentedViewFrame = presentedView?.frame ?? .zero

        var startingFrame = presentedViewFrame
        startingFrame.origin.y = startingPositionY

        var endingFrame = presentedViewFrame
        endingFrame.origin.y = endingPositionY

        let geometry = AnimationSupport.makeGeometry(containerBounds: containerViewBounds,
                                                     startingFrame: startingFrame,
                                                     endingFrame: endingFrame,
                                                     presentingVC: presentingVC,
                                                     presentedVC: presentedVC)

        let info = AnimationSupport.makeInfo(startDrawerState: startingState,
                                             targetDrawerState: endingState,
                                             configuration,
                                             geometry,
                                             animator.duration,
                                             endingPositionY < startingPositionY)

        AnimationSupport.clientPrepareViews(presentingVC: presentingVC,
                                            presentedVC: presentedVC,
                                            info)

        animator.addAnimations {
            self.currentDrawerY = endingPositionY
            if maxCornerRadius != 0 {
                self.currentDrawerCornerRadius = endingCornerRadius
            }
            AnimationSupport.clientAnimateAlong(presentingVC: presentingVC,
                                                presentedVC: presentedVC,
                                                info)
        }

        animator.addCompletion { endingPosition in
            let isStartingStateCollapsed = (startingState == .collapsed)
            let isEndingStateCollapsed = (endingState == .collapsed)

            let shouldDismiss =
                (isStartingStateCollapsed && endingPosition == .start) ||
                    (isEndingStateCollapsed && endingPosition == .end)

            if shouldDismiss {
                self.presentedViewController.dismiss(animated: true)
            }

            let isStartingStateCollapsedOrFullyExpanded =
                (startingState == .collapsed || startingState == .fullyExpanded)

            let isEndingStateCollapsedOrFullyExpanded =
                (endingState == .collapsed || endingState == .fullyExpanded)

            let shouldSetCornerRadiusToZero =
                (isEndingStateCollapsedOrFullyExpanded && endingPosition == .end) ||
                (isStartingStateCollapsedOrFullyExpanded && endingPosition == .start)

            if maxCornerRadius != 0 && shouldSetCornerRadiusToZero {
                self.currentDrawerCornerRadius = 0
            }

            AnimationSupport.clientCleanupViews(presentingVC: presentingVC,
                                                presentedVC: presentedVC,
                                                endingPosition,
                                                info)
        }

        animator.startAnimation()
    }

    func addCornerRadiusAnimationEnding(at endingState: DrawerState) {
        guard maximumCornerRadius != 0 && drawerPartialY != 0
            && endingState != currentDrawerState else { return }

        let startingState = currentDrawerState
        let (startingPositionY, endingPositionY) = positionsY(startingState: startingState,
                                                              endingState: endingState)

        let animator = makeAnimator(startingPositionY: startingPositionY,
                                    endingPositionY: endingPositionY)

        let endingCornerRadius = cornerRadius(at: endingState)
        animator.addAnimations {
            self.currentDrawerCornerRadius = endingCornerRadius
        }

        let isStartingStateCollapsedOrFullyExpanded =
            (startingState == .collapsed || startingState == .fullyExpanded)

        let isEndingStateCollapsedOrFullyExpanded =
            (endingState == .collapsed || endingState == .fullyExpanded)

        if isStartingStateCollapsedOrFullyExpanded || isEndingStateCollapsedOrFullyExpanded {
            animator.addCompletion { endingPosition in
                let shouldSetCornerRadiusToZero =
                    (isEndingStateCollapsedOrFullyExpanded && endingPosition == .end) ||
                    (isStartingStateCollapsedOrFullyExpanded && endingPosition == .start)
                if shouldSetCornerRadiusToZero {
                    self.currentDrawerCornerRadius = 0
                }
            }
        }

        animator.startAnimation()
    }

    private func makeAnimator(startingPositionY: CGFloat,
                              endingPositionY: CGFloat) -> UIViewPropertyAnimator {
        let duration =
            AnimationSupport.actualTransitionDuration(from: startingPositionY,
                                                      to: endingPositionY,
                                                      containerViewHeight: containerViewH,
                                                      configuration: configuration)

        return UIViewPropertyAnimator(duration: duration,
                                      timingParameters: timingCurveProvider)
    }

    private func positionsY(startingState: DrawerState,
                            endingState: DrawerState) -> (starting: CGFloat, ending: CGFloat) {
        let startingPositionY =
            GeometryEvaluator.drawerPositionY(for: startingState,
                                              drawerPartialHeight: drawerPartialH,
                                              containerViewHeight: containerViewH)

        let endingPositionY =
            GeometryEvaluator.drawerPositionY(for: endingState,
                                              drawerPartialHeight: drawerPartialH,
                                              containerViewHeight: containerViewH)

        return (startingPositionY, endingPositionY)
    }
}
