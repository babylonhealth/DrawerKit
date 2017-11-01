import UIKit

extension PresentationController {
    @objc func handleDrawerFullExpansionTap() {
        guard let tapGesture = drawerFullExpansionTapGR else { return }
        let tapY = tapGesture.location(in: presentedView).y
        guard tapY < drawerPartialH else { return }
        animateTransition(to: .fullyExpanded)
    }

    @objc func handleDrawerDismissalTap() {
        guard let tapGesture = drawerDismissalTapGR else { return }
        let tapY = tapGesture.location(in: containerView).y
        guard tapY < currentDrawerY else { return }
        tapGesture.isEnabled = false
        presentedViewController.dismiss(animated: true)
    }

    @objc func handleDrawerDrag() {
        guard let panGesture = drawerDragGR, let view = panGesture.view else { return }

        switch panGesture.state {
        case .began:
            lastDrawerState = GeometryEvaluator.drawerState(for: currentDrawerY,
                                                            drawerPartialHeight: drawerPartialH,
                                                            containerViewHeight: containerViewH,
                                                            configuration: configuration,
                                                            clampToNearest: true)

        case .changed:
            lastDrawerState = GeometryEvaluator.drawerState(for: currentDrawerY,
                                                            drawerPartialHeight: drawerPartialH,
                                                            containerViewHeight: containerViewH,
                                                            configuration: configuration,
                                                            clampToNearest: true)
            currentDrawerY += panGesture.translation(in: view).y
            currentDrawerCornerRadius = cornerRadius(at: currentDrawerState)
            panGesture.setTranslation(.zero, in: view)

        case .ended:
            let drawerFullY = configuration.fullExpansionBehaviour.drawerFullY
            let drawerSpeedY = panGesture.velocity(in: view).y / containerViewH
            let endingState = GeometryEvaluator.nextStateFrom(currentState: currentDrawerState,
                                                              speedY: drawerSpeedY,
                                                              drawerPartialHeight: drawerPartialH,
                                                              containerViewHeight: containerViewH,
                                                              drawerFullY: drawerFullY,
                                                              configuration: configuration)
            animateTransition(to: endingState)

        case .cancelled:
            animateTransition(to: lastDrawerState)

        default:
            break
        }
    }
}
