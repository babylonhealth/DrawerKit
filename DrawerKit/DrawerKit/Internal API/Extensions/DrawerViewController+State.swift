import Foundation

// Convenience functions to get the transition state properties
// directly from the drawer view controller.

extension DrawerViewController {
    var startDrawerState: DrawerState {
        get { return state.startDrawerState }
        set { state.startDrawerState = newValue }
    }

    var currentDrawerState: DrawerState {
        get { return state.currentDrawerState }
        set { state.currentDrawerState = newValue }
    }

    var endDrawerState: DrawerState {
        get { return state.endDrawerState }
        set { state.endDrawerState = newValue }
    }

    var startDragDirection: TransitionDirection? {
        get { return state.startDragDirection }
        set { state.startDragDirection = newValue }
    }

    var currentDragDirection: TransitionDirection? {
        get { return state.currentDragDirection }
        set { state.currentDragDirection = newValue }
    }
}
