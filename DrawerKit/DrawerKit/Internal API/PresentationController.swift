import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    let inDebugMode: Bool
    let handleView: UIView?

    var drawerFullExpansionTapGR: UITapGestureRecognizer?
    var drawerDismissalTapGR: UITapGestureRecognizer?
    var drawerDragGR: UIPanGestureRecognizer?
    var lastDrawerState: DrawerState = .collapsed

    init(presentingVC: UIViewController?,
         presentedVC: UIViewController,
         configuration: DrawerConfiguration,
         inDebugMode: Bool = false) {
        self.configuration = configuration
        self.inDebugMode = inDebugMode
        self.handleView = (configuration.hasHandleView ? UIView() : nil)
        super.init(presentedViewController: presentedVC, presenting: presentingVC)
    }
}

extension PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        let state: DrawerState = (supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded)
        frame.origin.y = GeometryEvaluator.drawerPositionY(for: state,
                                                           drawerPartialHeight: drawerPartialH,
                                                           containerViewHeight: containerViewH)
        return frame
    }

    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        setupDrawerFullExpansionTapRecogniser()
        setupDrawerDismissalTapRecogniser()
        setupDrawerDragRecogniser()
        setupDebugHeightMarks()
        setupHandleView()
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
