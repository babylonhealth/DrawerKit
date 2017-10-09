import Foundation

extension DrawerViewController {
    func startNonInteractiveTransitionAlong(direction: TransitionDirection) {
        guard !isAnimatingAlong(direction: direction) else { return }
        createTransition(trigger: .nonInteractive(direction))
        viewAnimator?.startAnimation()
    }

    func startDraggingTransition(draggingUp: Bool) {
        startDragDirection = (draggingUp ? .up : .down)
        if hasAnimatorAndItIsRunning {
            viewAnimator?.pauseAnimation()
            updateDrawerStateOnPausing()
        }
        createFullTransition(reversed: !draggingUp)
    }

    func startNonDrawerTapTransition() {
        guard !isAnimatingAlong(direction: .down) else { return }
        guard !isAnimatingAlong(direction: .up) else {
            viewAnimator?.isReversed = !viewAnimator!.isReversed
            return
        }
        startNonInteractiveTransitionAlong(direction: .down)
    }

    func continueAnimation(reversing: Bool) {
        guard let animator = viewAnimator else { return }
        animator.isReversed = reversing
        animator.continueAnimation(withTimingParameters: animator.timingParameters,
                                   durationFactor: 0)
    }
}

private extension DrawerViewController {
    var hasAnimator: Bool {
        return (viewAnimator != nil)
    }

    var hasAnimatorAndItIsRunning: Bool {
        return (hasAnimator && viewAnimator!.isRunning)
    }

    func isAnimatingAlong(direction: TransitionDirection) -> Bool {
        return hasAnimatorAndItIsRunning && currentDrawerState.direction == direction
    }
}

private extension DrawerViewController {
    func createAnimator(from startState: DrawerState, to endState: DrawerState,
                        _ geometry: TransitionGeometry) {
        guard endState.visibleFraction != startState.visibleFraction else { return }

        let startVF = startState.visibleFraction
        let endVF = endState.visibleFraction
        let presenting = (endVF >= startVF)

        viewAnimator = ViewAnimator(startVisibleFraction: startVF,
                                    endVisibleFraction: endVF,
                                    totalDurationInSeconds: totalDurationInSeconds,
                                    curveProvider: timingCurveProvider)

        let info = makeInformation(presenting, geometry, viewAnimator!.duration)
        clientPrepareViews(info)

        drawerView.isHidden = false
        let endDrawerYConstant =
            DrawerViewController.drawerYConstant(for: endVF, configuration, geometry)

        viewAnimator?.addAnimations { [ weak self ] in
            self?.drawerYConstraint.constant = endDrawerYConstant
            self?.contextView.layoutIfNeeded()
        }

        viewAnimator?.addCompletion { [ weak self ] position in
            self?.viewAnimator?.isReversed = false
            self?.updateDrawerStateOnFinishing(position, startState, endState, geometry)
            self?.clientCleanupViews(position, info)
            self?.cleanupIfReachingCollapsedState()
            self?.clientCompletionClosures(position, info)
        }

        viewAnimator?.pauseAnimation()
    }

    func createFullTransition(reversed: Bool) {
        let geometry = currentGeometry()
        startDrawerState = (reversed ? .fullyExpanded : .collapsed)
        endDrawerState = (reversed ? .collapsed : .fullyExpanded)
        createAnimator(from: startDrawerState, to: endDrawerState, geometry)
        viewAnimator?.visibleFraction = currentDrawerState.visibleFraction
    }

    func createTransition(trigger: TransitionTrigger) {
        let geometry = currentGeometry()
        startDrawerState = currentDrawerState
        endDrawerState = DrawerViewController.nextDrawerState(from: currentDrawerState,
                                                              trigger: trigger,
                                                              configuration, geometry)
        createAnimator(from: currentDrawerState, to: endDrawerState, geometry)
        viewAnimator?.visibleFraction = currentDrawerState.visibleFraction
    }
}

private extension DrawerViewController {
    func updateDrawerStateOnPausing() {
        guard let animator = viewAnimator else { return }
        let geometry = currentGeometry()
        let visibleFraction = animator.visibleFraction
        currentDrawerState = DrawerViewController.drawerState(for: visibleFraction,
                                                              currentDrawerState,
                                                              geometry)
    }

    func updateDrawerStateOnFinishing(_ endingPosition: UIViewAnimatingPosition,
                                      _ startState: DrawerState, _ endState: DrawerState,
                                      _ geometry: TransitionGeometry) {
        switch endingPosition {
        case .start:
            currentDrawerState = startState
        case .end:
            currentDrawerState = endState
        case .current:
            guard let visibleFraction = viewAnimator?.visibleFraction else { return }
            currentDrawerState = DrawerViewController.drawerState(for: visibleFraction,
                                                                  currentDrawerState,
                                                                  geometry)
        }
        drawerView.isHidden = (currentDrawerState == .collapsed)
    }
}

private extension DrawerViewController {
    func clientPrepareViews(_ info: TransitionInformation) {
        presenterVC?.drawerTransitionActions.prepare?(info)
        contentVC?.drawerTransitionActions.prepare?(info)
    }

    func clientCleanupViews(_ endingPosition: UIViewAnimatingPosition,
                            _ info: TransitionInformation) {
        var endInfo = info
        endInfo.endPosition = endingPosition
        presenterVC?.drawerTransitionActions.cleanup?(info)
        contentVC?.drawerTransitionActions.cleanup?(info)
    }

    func clientCompletionClosures(_ endingPosition: UIViewAnimatingPosition,
                                  _ info: TransitionInformation) {
        var endInfo = info
        endInfo.endPosition = endingPosition
        presenterVC?.drawerTransitionActions.completion?(info)
        contentVC?.drawerTransitionActions.completion?(info)
    }

    func cleanupIfReachingCollapsedState() {
        guard currentDrawerState == .collapsed else { return }
        removeGestureRecognizers()
        removeContentFromDrawer()
        self.dismiss(animated: false)
    }

    func makeInformation(_ presenting: Bool,
                         _ geometry: TransitionGeometry,
                         _ actualDurationInSeconds: TimeInterval,
                         _ endingPosition: UIViewAnimatingPosition? = nil) -> TransitionInformation {
        return TransitionInformation(configuration: configuration,
                                     geometry: geometry,
                                     presenting: presenting,
                                     startDrawerState: startDrawerState,
                                     endDrawerState: endDrawerState,
                                     endPosition: endingPosition,
                                     actualDurationInSeconds: actualDurationInSeconds)
    }
}
