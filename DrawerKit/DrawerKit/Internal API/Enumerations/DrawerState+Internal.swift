import Foundation

extension DrawerState {
    var visibleFraction: VisibleFraction {
        switch self {
        case .collapsed:
            return 0
        case .fullyExpanded:
            return 1
        case let .partiallyExpanded(vf, _), let .transitioning(vf, _):
            return vf
        }
    }

    var direction: TransitionDirection {
        switch self {
        case .collapsed:
            return .up
        case .fullyExpanded:
            return .down
        case let .partiallyExpanded(_, dir), let .transitioning(_, dir):
            return dir
        }
    }

    mutating func changeDirection(to newDirection: TransitionDirection) {
        guard newDirection != self.direction else { return }
        switch self {
        case .collapsed, .fullyExpanded:
            return
        case let .partiallyExpanded(vf, _):
            self = .partiallyExpanded(vf, newDirection)
        case let .transitioning(vf, _):
            self = .transitioning(vf, newDirection)
        }
    }
}
