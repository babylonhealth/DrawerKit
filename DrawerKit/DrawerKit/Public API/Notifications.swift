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

public protocol NotificationEnum {
    var name: Notification.Name { get }
}

extension NotificationCenter {
    private static let _$key$_ = "_$key$_"

    public func addObserver<A: NotificationEnum>(name: Notification.Name,
                                                 object: Any? = nil, queue: OperationQueue? = nil,
                                                 using block: @escaping (A, Any?) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: { note in
            guard let note = note.userInfo?[NotificationCenter._$key$_] as? A else { fatalError("incorrect notification key type") }
            block(note, object)
        })

        return NotificationToken(token: token, center: self)
    }

    internal func post(notification: NotificationEnum, object: Any? = nil) {
        let userInfo = [NotificationCenter._$key$_: notification]
        post(name: notification.name, object: object, userInfo: userInfo)
    }
}
