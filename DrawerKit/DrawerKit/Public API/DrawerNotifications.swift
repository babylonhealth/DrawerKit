import UIKit

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

    public static let transitionWillStartNotification = Notification.Name(rawValue: "DrawerNotification.transitionWillStart")
    public static let transitionDidFinishNotification = Notification.Name(rawValue: "DrawerNotification.transitionDidFinish")
    public static let drawerInteriorTappedNotification = Notification.Name(rawValue: "DrawerNotification.drawerInteriorTapped")
    public static let drawerExteriorTappedNotification = Notification.Name(rawValue: "DrawerNotification.drawerExteriorTapped")
}
