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
        // XXX - what if endingPosition == .current ?
        let endDrawerState =
            (endingPosition == .start ? startDrawerState : targetDrawerState)

        return DrawerAnimationInfo(configuration: configuration,
                                   geometry: geometry,
                                   actualDurationInSeconds: actualDurationInSeconds,
                                   isPresenting: isPresenting,
                                   startDrawerState: startDrawerState,
                                   targetDrawerState: targetDrawerState,
                                   endDrawerState: endDrawerState,
                                   endPosition: endingPosition)
    }

    static func clientPrepareViews(presentingVC: UIViewController,
                                   presentedVC: UIViewController,
                                   _ info: DrawerAnimationInfo) {
        (presentingVC as? DrawerAnimationParticipant)?.drawerAnimationActions.prepare?(info)
        (presentedVC as? DrawerAnimationParticipant)?.drawerAnimationActions.prepare?(info)
    }

    static func clientAnimateAlong(presentingVC: UIViewController,
                                   presentedVC: UIViewController,
                                   _ info: DrawerAnimationInfo) {
        (presentingVC as? DrawerAnimationParticipant)?.drawerAnimationActions.animateAlong?(info)
        (presentedVC as? DrawerAnimationParticipant)?.drawerAnimationActions.animateAlong?(info)
    }

    static func clientCleanupViews(presentingVC: UIViewController,
                                   presentedVC: UIViewController,
                                   _ endingPosition: UIViewAnimatingPosition,
                                   _ info: DrawerAnimationInfo) {
        var endInfo = info
        endInfo.endPosition = endingPosition
        (presentingVC as? DrawerAnimationParticipant)?.drawerAnimationActions.cleanup?(info)
        (presentedVC as? DrawerAnimationParticipant)?.drawerAnimationActions.cleanup?(info)
    }
}
