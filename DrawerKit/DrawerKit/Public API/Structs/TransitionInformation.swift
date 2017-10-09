import UIKit

// Data passed to view controllers to prepare and/or cleanup their views before
// and/or after a drawer transition, and to perform completion closures when a
// drawer transition ends.

public struct TransitionInformation {
    public let configuration: TransitionConfiguration
    public let geometry: TransitionGeometry
    public let presenting: Bool
    public let startDrawerState: DrawerState
    public let endDrawerState: DrawerState
    public var endPosition: UIViewAnimatingPosition? // intentionally mutable
    public let actualDurationInSeconds: TimeInterval

    internal init(configuration: TransitionConfiguration,
                  geometry: TransitionGeometry,
                  presenting: Bool,
                  startDrawerState: DrawerState,
                  endDrawerState: DrawerState,
                  endPosition: UIViewAnimatingPosition?,
                  actualDurationInSeconds: TimeInterval) {
        self.configuration = configuration
        self.geometry = geometry
        self.presenting = presenting
        self.startDrawerState = startDrawerState
        self.endDrawerState = endDrawerState
        self.endPosition = endPosition
        self.actualDurationInSeconds = actualDurationInSeconds
    }
}

extension TransitionInformation {
    public var totalDurationInSeconds: TimeInterval {
        return configuration.totalDurationInSeconds
    }

    public var timingCurveProvider: UITimingCurveProvider {
        return configuration.timingCurveProvider
    }

    public var coversStatusBar: Bool {
        return configuration.coversStatusBar
    }

    public var supportsPartialExpansion: Bool {
        return configuration.supportsPartialExpansion
    }

    public var dismissesInStages: Bool {
        return configuration.dismissesInStages
    }

    public var isDrawerDraggable: Bool {
        return configuration.isDrawerDraggable
    }

    public var isDismissableByOutsideDrawerTaps: Bool {
        return configuration.isDismissableByOutsideDrawerTaps
    }

    public var numberOfTapsForOutsideDrawerDismissal: Int {
        return configuration.numberOfTapsForOutsideDrawerDismissal
    }
}

extension TransitionInformation {
    public var contextBounds: CGRect {
        return geometry.contextBounds
    }

    public var drawerFrame: CGRect {
        return geometry.drawerFrame
    }

    public var contentFrame: CGRect {
        return geometry.contentFrame
    }

    public var userInterfaceOrientation: UIInterfaceOrientation {
        return geometry.userInterfaceOrientation
    }

    public var actualStatusBarHeight: CGFloat {
        return geometry.actualStatusBarHeight
    }

    public var heightOfPartiallyExpandedDrawer: CGFloat {
        return geometry.heightOfPartiallyExpandedDrawer
    }
}

extension TransitionInformation: Equatable {
    public static func ==(lhs: TransitionInformation, rhs: TransitionInformation) -> Bool {
        return lhs.configuration == rhs.configuration
            && lhs.geometry == rhs.geometry
            && lhs.presenting == rhs.presenting
            && lhs.startDrawerState == rhs.startDrawerState
            && lhs.endDrawerState == rhs.endDrawerState
            && lhs.endPosition == rhs.endPosition
            && lhs.actualDurationInSeconds == rhs.actualDurationInSeconds
    }
}
