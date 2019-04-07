import UIKit

/// Namespace for available `DrawerNotificationInfo`s (a pair of `Notification.Name` and `userInfo`).
public enum DrawerNotifications {
    public struct TransitionWillStart: DrawerNotificationInfo {
        public let info: DrawerAnimationInfo
        public static let name = Notification.Name(rawValue: "DrawerNotification.transitionWillStart")
    }

    public struct TransitionDidFinish: DrawerNotificationInfo {
        public let info: DrawerAnimationInfo
        public static let name = Notification.Name(rawValue: "DrawerNotification.transitionDidFinish")
    }

    public struct DrawerInteriorTapped: DrawerNotificationInfo {
        public static let name = Notification.Name(rawValue: "DrawerNotification.drawerInteriorTapped")
    }

    public struct DrawerExteriorTapped: DrawerNotificationInfo {
        public static let name = Notification.Name(rawValue: "DrawerNotification.drawerExteriorTapped")
    }
}

// MARK: - DrawerNotificationInfo

/// A pair of `Notification.Name` and type-safe `userInfo`.
public protocol DrawerNotificationInfo {
    associatedtype Info = Void

    /// Type-safe `userInfo` alternative.
    var info: Info { get }

    /// Name of a notification that 1:1 corresponds with `Self`.
    static var name: Notification.Name { get }
}

extension DrawerNotificationInfo where Info == Void {
    public var info: Void { return () }
}

// MARK: - Deprecated

@available(*, deprecated, message: "Use `DrawerNotifications` instead")
public enum DrawerNotification: NotificationEnum {
    case transitionWillStart(info: DrawerAnimationInfo)
    case transitionDidFinish(info: DrawerAnimationInfo)
    case drawerInteriorTapped
    case drawerExteriorTapped

    public var name: Notification.Name {
        switch self {
        case .transitionWillStart:
            return DrawerNotification.transitionWillStartNotification
        case .transitionDidFinish:
            return DrawerNotification.transitionDidFinishNotification
        case .drawerInteriorTapped:
            return DrawerNotification.drawerInteriorTappedNotification
        case .drawerExteriorTapped:
            return DrawerNotification.drawerExteriorTappedNotification
        }
    }

    @available(*, deprecated, renamed: "DrawerNotifications.TransitionWillStart.name")
    public static let transitionWillStartNotification = Notification.Name(rawValue: "DrawerNotification.transitionWillStart")

    @available(*, deprecated, renamed: "DrawerNotifications.TransitionDidFinish.name")
    public static let transitionDidFinishNotification = Notification.Name(rawValue: "DrawerNotification.transitionDidFinish")

    @available(*, deprecated, renamed: "DrawerNotifications.DrawerInteriorTapped.name")
    public static let drawerInteriorTappedNotification = Notification.Name(rawValue: "DrawerNotification.drawerInteriorTapped")

    @available(*, deprecated, renamed: "DrawerNotifications.DrawerExteriorTapped.name")
    public static let drawerExteriorTappedNotification = Notification.Name(rawValue: "DrawerNotification.drawerExteriorTapped")
}
