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
    var lastDrawerState: DrawerState = .collapsed

    let intermediate: UIViewController

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
        self.intermediate = UIViewController()
        super.init(presentedViewController: presentedVC, presenting: presentingVC)

        intermediate.view.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension PresentationController {
    private var frameOfPresentedViewInIntermediateView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        let state: DrawerState = (supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded)
        let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
        frame.origin.y = GeometryEvaluator.drawerPositionY(for: state,
                                                           drawerPartialHeight: drawerPartialHeight,
                                                           containerViewHeight: containerViewHeight,
                                                           drawerFullY: drawerFullY)
        return frame
    }

    override func presentationTransitionWillBegin() {
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

        containerView?.addSubview(intermediate.view)
        intermediate.view.frame = frameOfPresentedViewInContainerView
        intermediate.view.backgroundColor = .clear

        intermediate.addChildViewController(presentedViewController)
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        enableDrawerFullExpansionTapRecogniser(enabled: true)
        enableDrawerDismissalTapRecogniser(enabled: true)
        presentedViewController.didMove(toParentViewController: intermediate)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: .collapsed)
        enableDrawerFullExpansionTapRecogniser(enabled: false)
        enableDrawerDismissalTapRecogniser(enabled: false)
        presentedViewController.willMove(toParentViewController: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeDrawerFullExpansionTapRecogniser()
        removeDrawerDismissalTapRecogniser()
        removeDrawerDragRecogniser()
        removeHandleView()
        presentedViewController.removeFromParentViewController()
    }

    override func containerViewWillLayoutSubviews() {
        intermediate.view.frame = frameOfPresentedViewInContainerView
        presentedView?.frame = frameOfPresentedViewInIntermediateView
    }
}
