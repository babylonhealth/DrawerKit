extension PresentationController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !scrollViewNeedsTransitionAsDragEnds else { return }

        scrollStartDrawerState = currentDrawerState
        scrollEndVelocity = nil

        // Record the maximum top content inset that has even been observed.
        // This is necessary to support `UINavigationController` drawers with
        // Large Titles, since there is no any other way to query this
        // information.
        scrollMaxTopInset = max(scrollView.topInset, scrollMaxTopInset)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isScrollEnabled,
              !scrollViewNeedsTransitionAsDragEnds,
              !scrollViewIsDecelerating,
              scrollEndVelocity == nil
            else { return }

        let topInset = scrollView.topInset
        let negativeVerticalOffset = -(scrollView.contentOffset.y + topInset)

        // Intercept the content offset changes beyond the top content inset.
        // The algorithm is aware of dynamic content inset adjustments induced
        // by the Navigation Bar Large Title Mode since iOS 11.0.
        let shouldOverrideScroll = scrollStartDrawerState != currentDrawerState
            || (scrollMaxTopInset == topInset && negativeVerticalOffset > 0.0)
            || currentDrawerState.isTransitioning

        if shouldOverrideScroll {
            self.applyTranslationY(negativeVerticalOffset)
            scrollView.contentOffset.y = -topInset

            // Detect and animate any top content inset change due to its parent
            // `UINavigationController` (if any) moving away from (0, 0) in
            // screen coordinates.
            let delta = topInset - scrollView.topInset

            UIView.animate(withDuration: 0.1) {
                self.applyTranslationY(max(delta, 0.0))
                self.presentedViewController.view.layoutIfNeeded()
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollStartDrawerState != currentDrawerState {
            scrollEndVelocity = velocity
            scrollViewNeedsTransitionAsDragEnds = true
            targetContentOffset.pointee = scrollView.contentOffset
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewIsDecelerating = decelerate

        func cleanup() {
            scrollEndVelocity = nil
            scrollViewNeedsTransitionAsDragEnds = false
        }

        guard let velocity = scrollEndVelocity, scrollViewNeedsTransitionAsDragEnds else {
            cleanup()
            return
        }

        let drawerSpeedY = -velocity.y / containerViewHeight
        let endingState = GeometryEvaluator.nextStateFrom(currentState: currentDrawerState,
                                                          speedY: drawerSpeedY,
                                                          drawerPartialHeight: drawerPartialHeight,
                                                          containerViewHeight: containerViewHeight,
                                                          configuration: configuration)

        animateTransition(
            to: endingState,
            animateAlongside: {
                self.presentedViewController.view.layoutIfNeeded()
                scrollView.contentOffset.y = -scrollView.topInset
                scrollView.flashScrollIndicators()
            },
            completion: cleanup
        )
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewIsDecelerating = false
    }
}

private extension DrawerState {
    var isTransitioning: Bool {
        switch self {
        case .transitioning:
            return true
        default:
            return false
        }
    }
}

private extension UIScrollView {
    var topInset: CGFloat {
        if #available(iOS 11.0, *) {
            return adjustedContentInset.top
        } else {
            return contentInset.top
        }
    }
}
