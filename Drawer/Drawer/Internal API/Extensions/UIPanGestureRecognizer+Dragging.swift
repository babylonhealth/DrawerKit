import UIKit

extension UIPanGestureRecognizer {
    // returns an optional because the user might not be dragging at all
    var isDraggingUp: Bool? {
        guard let superview = view?.superview else { return nil }
        let vy = velocity(in: superview).y
        guard vy != 0 else { return nil }
        return vy < 0 // up velocity is negative
    }

    var verticalOffset: CGFloat {
        guard let view = view else { return 0 }
        let offset = translation(in: view)
        setTranslation(CGPoint.zero, in: view)
        return offset.y
    }
}
