import UIKit

extension PresentationController {
    @objc func handleDrawerFullExpansionTap() {
        guard let tapGesture = drawerFullExpansionTapGR else { return }
        let tapY = tapGesture.location(in: presentedView).y
        guard tapY < drawerPartialHeight else { return }
        NotificationCenter.default.post(notification: DrawerNotification.drawerInteriorTapped)
        animateTransition(to: .fullyExpanded)
    }
    
    @objc func handleDrawerDismissalTap() {
        guard let tapGesture = drawerDismissalTapGR else { return }
        let tapY = tapGesture.location(in: containerView).y
        guard tapY < currentDrawerY else { return }
        NotificationCenter.default.post(notification: DrawerNotification.drawerExteriorTapped)
        tapGesture.isEnabled = false
        animateBlur(to: 0)
        presentedViewController.dismiss(animated: true)
    }
    
    @objc func handleDrawerDrag() {
        guard let panGesture = drawerDragGR, let view = panGesture.view else { return }
        
        switch panGesture.state {
        case .began:
            startingDrawerStateForDrag = targetDrawerState
            if(startingDrawerStateForDrag != .fullyExpanded){
                animationPosition = currentDrawerY
            }
            fallthrough
            
        case .changed:
            currentDrawerY += panGesture.translation(in: view).y
            targetDrawerState = currentDrawerState
            currentDrawerCornerRadius = cornerRadius(at: currentDrawerState)
            panGesture.setTranslation(.zero, in: view)
            
            var height = (currentDrawerY - animationPosition) / (view.frame.height - lowerMarkGap - animationPosition)
            if height < 0 { height = 1 } else { height = 1 - height}
            if(currentDrawerState == .fullyExpanded)
            {
                animateBlur(to: 1)
            }else{
                animateBlur(to: height)
            }
            
        case .ended:
            let drawerSpeedY = panGesture.velocity(in: view).y / containerViewHeight
            let endingState = GeometryEvaluator.nextStateFrom(currentState: currentDrawerState,
                                                              speedY: drawerSpeedY,
                                                              drawerPartialHeight: drawerPartialHeight,
                                                              containerViewHeight: containerViewHeight,
                                                              configuration: configuration)
            animateTransition(to: endingState)
            let percent = CGFloat( (endingState == .collapsed) ? 0 : 1)
            animateBlur(to: percent)
        case .cancelled:
            if let startingState = startingDrawerStateForDrag {
                startingDrawerStateForDrag = nil
                animateTransition(to: startingState)
                let percent = CGFloat( (startingState == .collapsed) ? 0 : 1)
                animateBlur(to: percent)
            }
            
        default:
            break
        }
    }
}

extension PresentationController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = gestureRecognizer.view,
            view.isDescendant(of: presentedViewController.view),
            let subview = view.hitTest(touch.location(in: view), with: nil) {
            return !(subview is UIControl)
        } else {
            return true
        }
    }
}
