import UIKit

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func equal(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    let epsilon: CGFloat = 0.5
    return abs(lhs - rhs) <= epsilon
}

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func smallerThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs < rhs || equal(lhs, rhs)
}

// Needs to be a free-floating function because it's accessed by extensions of
// different types.
func greaterThanOrEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    return lhs > rhs || equal(lhs, rhs)
}

extension DrawerState {
    public static func ==(lhs: DrawerState, rhs: DrawerState) -> Bool {
        switch (lhs, rhs) {
        case (.collapsed, .collapsed),
             (.partiallyExpanded, .partiallyExpanded),
             (.fullyExpanded, .fullyExpanded):
            return true
        case let (.transitioning(lhsCurPosY), .transitioning(rhsCurPosY)):
            return equal(lhsCurPosY, rhsCurPosY)
        default:
            return false
        }
    }
}

// For versions of iOS lower than  11.0
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
