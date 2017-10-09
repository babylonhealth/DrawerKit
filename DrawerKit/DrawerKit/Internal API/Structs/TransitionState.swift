import Foundation

struct TransitionState {
    var startDrawerState: DrawerState = .collapsed
    var currentDrawerState: DrawerState = .collapsed
    var endDrawerState: DrawerState = .fullyExpanded

    var startDragDirection: TransitionDirection?
    var currentDragDirection: TransitionDirection?
}

extension TransitionState: Equatable {
    public static func ==(lhs: TransitionState, rhs: TransitionState) -> Bool {
        return lhs.startDrawerState == rhs.startDrawerState
            && lhs.currentDrawerState == rhs.currentDrawerState
            && lhs.endDrawerState == rhs.endDrawerState
            && lhs.startDragDirection == rhs.startDragDirection
            && lhs.currentDragDirection == rhs.currentDragDirection
    }
}
