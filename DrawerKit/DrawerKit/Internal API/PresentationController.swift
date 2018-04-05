import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    let inDebugMode: Bool
    let handleView: UIView?

    let presentingDrawerAnimationActions: DrawerAnimationActions
    let presentedDrawerAnimationActions: DrawerAnimationActions

    var drawerFullExpansionTapGR: UITapGestureRecognizer?
    var drawerDismissalTapGR: UITapGestureRecognizer?
    var drawerDragGR: UIPanGestureRecognizer?

    /// The target state of the drawer. If no presentation animation is in
    /// progress, the value should be equivalent to `currentDrawerState`.
    var targetDrawerState: DrawerState {
        didSet {
            gestureAvailabilityConditionsDidChange()
        }
    }

    var startingDrawerStateForDrag: DrawerState?

    weak var scrollViewForPullToDismiss: UIScrollView? {
        didSet {
            scrollViewForPullToDismiss?.delegate = nil

            if let scrollView = scrollViewForPullToDismiss {
                scrollView.delegate = self
                drawerDragGR?.require(toFail: scrollView.panGestureRecognizer)
            }

            gestureAvailabilityConditionsDidChange()
        }
    }

    var scrollStartDrawerState: DrawerState?
    var scrollMaxTopInset: CGFloat = 0.0
    var scrollEndVelocity: CGPoint?
    var scrollViewIsDecelerating: Bool = false
    var scrollViewNeedsTransitionAsDragEnds = false {
        didSet {
            gestureAvailabilityConditionsDidChange()
        }
    }

    init(presentingVC: UIViewController?,
         presentingDrawerAnimationActions: DrawerAnimationActions,
         presentedVC: UIViewController,
         presentedDrawerAnimationActions: DrawerAnimationActions,
         configuration: DrawerConfiguration,
         inDebugMode: Bool = false) {
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        self.handleView = (configuration.handleViewConfiguration != nil ? UIView() : nil)
        self.presentingDrawerAnimationActions = presentingDrawerAnimationActions
        self.presentedDrawerAnimationActions = presentedDrawerAnimationActions
        self.targetDrawerState = configuration.supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded

        super.init(presentedViewController: presentedVC, presenting: presentingVC)
    }

    func gestureAvailabilityConditionsDidChange() {
        drawerDismissalTapGR?.isEnabled = targetDrawerState == .partiallyExpanded
        drawerFullExpansionTapGR?.isEnabled = targetDrawerState == .partiallyExpanded

        if let scrollView = scrollViewForPullToDismiss {
            switch targetDrawerState {
            case .partiallyExpanded, .collapsed:
                scrollView.isScrollEnabled = false
            case .transitioning, .fullyExpanded:
                scrollView.isScrollEnabled = !scrollViewNeedsTransitionAsDragEnds
            }
        }
    }
}

extension PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
        frame.origin.y = GeometryEvaluator.drawerPositionY(for: targetDrawerState,
                                                           drawerPartialHeight: drawerPartialHeight,
                                                           containerViewHeight: containerViewHeight,
                                                           drawerFullY: drawerFullY)
        return frame
    }

    override func presentationTransitionWillBegin() {
        // NOTE: `targetDrawerState.didSet` is not invoked within the
        //        initializer.
        gestureAvailabilityConditionsDidChange()

        presentedViewController.view.layoutIfNeeded()
        containerView?.backgroundColor = .clear
        setupDrawerFullExpansionTapRecogniser()
        setupDrawerDismissalTapRecogniser()
        setupDrawerDragRecogniser()
        setupDebugHeightMarks()
        setupHandleView()
        setupDrawerBorder()
        setupDrawerShadow()
        addCornerRadiusAnimationEnding(at: .partiallyExpanded)
        enableDrawerFullExpansionTapRecogniser(enabled: false)
        enableDrawerDismissalTapRecogniser(enabled: false)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        enableDrawerFullExpansionTapRecogniser(enabled: true)
        enableDrawerDismissalTapRecogniser(enabled: true)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: .collapsed)
        enableDrawerFullExpansionTapRecogniser(enabled: false)
        enableDrawerDismissalTapRecogniser(enabled: false)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeDrawerFullExpansionTapRecogniser()
        removeDrawerDismissalTapRecogniser()
        removeDrawerDragRecogniser()
        removeHandleView()
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

extension PresentationController: DrawerPresentationControlling {}
