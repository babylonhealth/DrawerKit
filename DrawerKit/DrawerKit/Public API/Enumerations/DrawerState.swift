import Foundation

public typealias VisibleFraction = CGFloat

public enum DrawerState {
    case collapsed
    case partiallyExpanded(VisibleFraction, TransitionDirection)
    case fullyExpanded
    case transitioning(VisibleFraction, TransitionDirection)
}

extension DrawerState: Equatable {
    public static func ==(lhs: DrawerState, rhs: DrawerState) -> Bool {
        return lhs.visibleFraction == rhs.visibleFraction && lhs.direction == rhs.direction
    }
}

extension DrawerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .collapsed:
            return ".collapsed"
        case .fullyExpanded:
            return ".fullyExpanded"
        case let .partiallyExpanded(vf, dir):
            return ".partiallyExpanded(\(vf), \(dir))"
        case let .transitioning(vf, dir):
            return ".transitioning(\(vf), \(dir))"
        }
    }
}
