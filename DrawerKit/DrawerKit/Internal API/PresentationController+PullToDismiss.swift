final class PullToDismissManager: NSObject, UIScrollViewDelegate {
    private(set) weak var delegate: UIScrollViewDelegate?
    private weak var presentationController: PresentationController?

    var scrollStartDrawerState: DrawerState?
    var scrollMaxTopInset: CGFloat = 0.0
    var scrollEndVelocity: CGPoint?
    var scrollViewIsDecelerating: Bool = false
    var scrollViewNeedsTransitionAsDragEnds = false {
        didSet {
            presentationController?.gestureAvailabilityConditionsDidChange()
        }
    }

    init(delegate: UIScrollViewDelegate?, presentationController: PresentationController) {
        self.delegate = delegate
        self.presentationController = presentationController
    }

    @objc override func conforms(to aProtocol: Protocol) -> Bool {
        return super.conforms(to: aProtocol) || (delegate?.conforms(to: aProtocol) ?? false)
    }

    @objc override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || (delegate?.responds(to: aSelector) ?? false)
    }

    @objc override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return delegate
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let presentationController = presentationController,
              !scrollViewNeedsTransitionAsDragEnds else { return }

        scrollStartDrawerState = presentationController.currentDrawerState
        scrollEndVelocity = nil

        // Record the maximum top content inset that has even been observed.
        // This is necessary to support `UINavigationController` drawers with
        // Large Titles, since there is no any other way to query this
        // information.
        scrollMaxTopInset = max(scrollView.topInset, scrollMaxTopInset)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let presentationController = presentationController,
              scrollView.isScrollEnabled,
              !scrollViewNeedsTransitionAsDragEnds,
              !scrollViewIsDecelerating,
              scrollEndVelocity == nil
            else { return }

        let currentDrawerState = presentationController.currentDrawerState
        let topInset = scrollView.topInset
        let negativeVerticalOffset = -(scrollView.contentOffset.y + topInset)

        // Intercept the content offset changes beyond the top content inset.
        // The algorithm is aware of dynamic content inset adjustments induced
        // by the Navigation Bar Large Title Mode since iOS 11.0.
        let shouldOverrideScroll = scrollStartDrawerState != currentDrawerState
            || (scrollMaxTopInset == topInset && negativeVerticalOffset > 0.0)
            || currentDrawerState.isTransitioning

        if shouldOverrideScroll {
            presentationController.applyTranslationY(negativeVerticalOffset)
            scrollView.contentOffset.y = -topInset

            // Detect and animate any top content inset change due to its parent
            // `UINavigationController` (if any) moving away from (0, 0) in
            // screen coordinates.
            let delta = topInset - scrollView.topInset

            UIView.animate(withDuration: 0.1) {
                presentationController.applyTranslationY(max(delta, 0.0))
                presentationController.presentedViewController.view.layoutIfNeeded()
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let presentationController = presentationController,
           scrollStartDrawerState != presentationController.currentDrawerState {
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

        guard let presentationController = presentationController,
              let velocity = scrollEndVelocity,
              scrollViewNeedsTransitionAsDragEnds else {
            cleanup()
            return
        }

        let drawerSpeedY = -velocity.y / presentationController.containerViewHeight
        let endingState = GeometryEvaluator.nextStateFrom(currentState: presentationController.currentDrawerState,
                                                          speedY: drawerSpeedY,
                                                          drawerPartialHeight: presentationController.drawerPartialHeight,
                                                          containerViewHeight: presentationController.containerViewHeight,
                                                          configuration: presentationController.configuration)

        presentationController.animateTransition(
            to: endingState,
            animateAlongside: {
                presentationController.presentedViewController.view.layoutIfNeeded()
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

