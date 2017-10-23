import Foundation

enum DrawerState: Equatable {
    case collapsed
    case partiallyExpanded
    case fullyExpanded
    case transitioning(CGFloat) // current drawer Y position
}
