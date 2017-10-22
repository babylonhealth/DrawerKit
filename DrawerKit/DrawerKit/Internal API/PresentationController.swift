import UIKit

final class PresentationController: UIPresentationController {
    let configuration: DrawerConfiguration // intentionally internal and immutable
    let inDebugMode: Bool

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
        super.init(presentedViewController: presentedVC, presenting: presentingVC)
    }
}

extension PresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerViewSize)
        let state: DrawerState = (supportsPartialExpansion ? .partiallyExpanded : .fullyExpanded)
        frame.origin.y = drawerPositionY(for: state)
        return frame
    }

    override func presentationTransitionWillBegin() {
        containerView?.backgroundColor = .clear
        setupDrawerFullExpansionTapRecogniser()
        setupDrawerDismissalTapRecogniser()
        setupDrawerDragRecogniser()
        setupDebugHeightMarks()
        addCornerRadiusAnimationEnding(at: .partiallyExpanded)
    }

    override func dismissalTransitionWillBegin() {
        addCornerRadiusAnimationEnding(at: .collapsed)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        removeDrawerFullExpansionTapRecogniser()
        removeDrawerDismissalTapRecogniser()
        removeDrawerDragRecogniser()
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
}

private extension PresentationController {
    func clientPrepareViews(_ info: DrawerAnimationInfo) {
        //        presenterVC?.drawerTransitionActions.prepare?(info)
        //        contentVC?.drawerTransitionActions.prepare?(info)
    }

    func clientAnimateAlong(_ info: DrawerAnimationInfo) {
        //        presenterVC?.drawerTransitionActions.prepare?(info)
        //        contentVC?.drawerTransitionActions.prepare?(info)
    }

    func clientCleanupViews(_ endingPosition: UIViewAnimatingPosition,
                            _ info: DrawerAnimationInfo) {
        //        var endInfo = info
        //        endInfo.endPosition = endingPosition
        //        presenterVC?.drawerTransitionActions.cleanup?(info)
        //        contentVC?.drawerTransitionActions.cleanup?(info)
    }

    func makeInformation(_ isPresenting: Bool,
                         _ geometry: DrawerGeometry,
                         _ actualDurationInSeconds: TimeInterval,
                         _ endingPosition: UIViewAnimatingPosition? = nil) -> DrawerAnimationInfo {
        return DrawerAnimationInfo(configuration: configuration,
                                   geometry: geometry,
                                   actualDurationInSeconds: actualDurationInSeconds,
                                   isPresenting: isPresenting,
                                   startDrawerState: .collapsed, // XXX
                                   targetEndDrawerState: .partiallyExpanded, // XXX
                                   endDrawerState: .partiallyExpanded, // XXX
                                   endPosition: endingPosition)
    }
}
