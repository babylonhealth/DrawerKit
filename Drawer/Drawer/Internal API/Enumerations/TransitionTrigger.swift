import Foundation

// device rotation is also a trigger but is handled separately
enum TransitionTrigger {
    case drawerTap
    case nonDrawerTap
    case drawerDrag(TransitionDirection)
    case nonInteractive(TransitionDirection)
}

extension TransitionTrigger {
    var direction: TransitionDirection {
        switch self {
        case .nonDrawerTap:
            return .down
        case .drawerTap:
            return .up
        case let .drawerDrag(dir),
             let .nonInteractive(dir):
            return dir
        }
    }
}

extension TransitionTrigger: Equatable {
    static func ==(lhs: TransitionTrigger, rhs: TransitionTrigger) -> Bool {
        switch (lhs, rhs) {
        case (.nonDrawerTap, .nonDrawerTap),
             (.drawerTap, .drawerTap):
            return true
        case let (.drawerDrag(dir1), .drawerDrag(dir2)):
            return dir1 == dir2
        case let (.nonInteractive(dir1), .nonInteractive(dir2)):
            return dir1 == dir2
        default:
            return false
        }
    }
}

extension TransitionTrigger: CustomStringConvertible {
    var description: String {
        switch self {
        case .nonDrawerTap:
            return ".nonDrawerTap"
        case .drawerTap:
            return ".drawerTap"
        case let .drawerDrag(direction):
            return ".drawerDrag(\(direction))"
        case let .nonInteractive(direction):
            return ".nonInteractive(\(direction))"
        }
    }
}
