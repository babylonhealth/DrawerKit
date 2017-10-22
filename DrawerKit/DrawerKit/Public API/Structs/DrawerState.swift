import UIKit

/// An enumeration to describe the various states the drawer can be in.

public enum DrawerState: Equatable { // the implementation of Equatable is internal
    case collapsed
    case partiallyExpanded
    case fullyExpanded
    case transitioning(CGFloat) // current drawer Y position
}
