import UIKit

struct AnimationSupport {
    static func actualTransitionDuration(from startingPositionY: CGFloat,
                                         to endingPositionY: CGFloat,
                                         containerViewHeight: CGFloat,
                                         configuration: DrawerConfiguration) -> TimeInterval {
        var duration = configuration.totalDurationInSeconds
        if configuration.durationIsProportionalToDistanceTraveled {
            let fractionToGo = abs(endingPositionY - startingPositionY) / containerViewHeight
            duration *= TimeInterval(fractionToGo)
        }
        return duration
    }

    static func makeGeometry(containerBounds: CGRect,
                             startingFrame: CGRect,
                             endingFrame: CGRect,
                             presentingVC: UIViewController,
                             presentedVC: UIViewController) -> DrawerGeometry {
        let navigationBarHeight =
            presentingVC.navigationController?.navigationBar.bounds.size.height ?? 0

        let heightOfPartiallyExpandedDrawer =
            (presentedVC as? DrawerPresentable)?.heightOfPartiallyExpandedDrawer ?? 0

        return DrawerGeometry(containerBounds: containerBounds,
                              startingFrame: startingFrame,
                              endingFrame: endingFrame,
                              navigationBarHeight: navigationBarHeight,
                              heightOfPartiallyExpandedDrawer: heightOfPartiallyExpandedDrawer)
    }

    static func makeInfo(startDrawerState: DrawerState,
                         targetDrawerState: DrawerState,
                         _ configuration: DrawerConfiguration,
                         _ geometry: DrawerGeometry,
                         _ actualDurationInSeconds: TimeInterval,
                         _ isPresenting: Bool,
                         _ endingPosition: UIViewAnimatingPosition? = nil) -> DrawerAnimationInfo {
        let endDrawerState = (endingPosition == .start ? startDrawerState : targetDrawerState)
        return DrawerAnimationInfo(configuration: configuration,
                                   geometry: geometry,
                                   actualDurationInSeconds: actualDurationInSeconds,
                                   isPresenting: isPresenting,
                                   startDrawerState: startDrawerState,
                                   targetDrawerState: targetDrawerState,
                                   endDrawerState: endDrawerState,
                                   endPosition: endingPosition)
    }

    static func clientPrepareViews(presentingDrawerAnimationActions: DrawerAnimationActions,
                                   presentedDrawerAnimationActions: DrawerAnimationActions,
                                   _ info: DrawerAnimationInfo) {
        NotificationCenter.default.post(notification: DrawerNotification.transitionWillStart(info: info))
        presentingDrawerAnimationActions.prepare?(info)
        presentedDrawerAnimationActions.prepare?(info)
    }

    static func clientAnimateAlong(presentingDrawerAnimationActions: DrawerAnimationActions,
                                   presentedDrawerAnimationActions: DrawerAnimationActions,
                                   _ info: DrawerAnimationInfo) {
        presentingDrawerAnimationActions.animateAlong?(info)
        presentedDrawerAnimationActions.animateAlong?(info)
    }

    static func clientCleanupViews(presentingDrawerAnimationActions: DrawerAnimationActions,
                                   presentedDrawerAnimationActions: DrawerAnimationActions,
                                   _ endingPosition: UIViewAnimatingPosition,
                                   _ info: DrawerAnimationInfo) {
        var endInfo = info
        endInfo.endPosition = endingPosition
        presentingDrawerAnimationActions.cleanup?(info)
        presentedDrawerAnimationActions.cleanup?(info)
        NotificationCenter.default.post(notification: DrawerNotification.transitionDidFinish(info: info))
    }
}
