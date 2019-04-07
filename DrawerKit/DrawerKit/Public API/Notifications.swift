import Foundation

public class NotificationToken {
    public let token: NSObjectProtocol
    public let center: NotificationCenter

    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit { center.removeObserver(token) }
}

@available(*, deprecated, message: "Do not use this.")
public protocol NotificationEnum {
    var name: Notification.Name { get }
}

extension NotificationCenter {
    private static let notificationKey = "notificationKey"

    public func addObserver<T: DrawerNotificationInfo>(_ type: T.Type,
                                                       object: Any? = nil,
                                                       queue: OperationQueue? = nil,
                                                       using block: @escaping (T) -> ()) -> NotificationToken {
        let token = addObserver(forName: T.name, object: object, queue: queue, using: { note in
            guard let note = note.userInfo?[NotificationCenter.notificationKey] as? T else {
                fatalError("incorrect notification key type")
            }
            block(note)
        })

        return NotificationToken(token: token, center: self)
    }

    internal func post<T: DrawerNotificationInfo>(_ info: T, object: Any? = nil) {
        let userInfo = [NotificationCenter.notificationKey: info]
        post(name: T.name, object: object, userInfo: userInfo)
    }
}

// MARK: - Deprecated

extension NotificationCenter {
    @available(*, deprecated, message: "Do not use this.")
    public func addObserver<A: NotificationEnum>(name: Notification.Name,
                                                 object: Any? = nil, queue: OperationQueue? = nil,
                                                 using block: @escaping (A, Any?) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: { note in
            guard let note = note.userInfo?[NotificationCenter.notificationKey] as? A else { fatalError("incorrect notification key type") }
            block(note, object)
        })

        return NotificationToken(token: token, center: self)
    }

    @available(*, deprecated, message: "Do not use this.")
    internal func post(notification: NotificationEnum, object: Any? = nil) {
        let userInfo = [NotificationCenter.notificationKey: notification]
        post(name: notification.name, object: object, userInfo: userInfo)
    }
}
