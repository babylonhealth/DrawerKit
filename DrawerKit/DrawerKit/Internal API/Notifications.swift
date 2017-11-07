import Foundation

class NotificationToken {
    let token: NSObjectProtocol
    let center: NotificationCenter

    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }

    deinit { center.removeObserver(token) }
}


protocol NotificationEnum {
    var name: Notification.Name { get }
}


extension NotificationCenter {
    private static let _$key$_ = "_$key$_"

    func post(notification: NotificationEnum, object: Any? = nil) {
        let userInfo = [NotificationCenter._$key$_: notification]
        post(name: notification.name, object: object, userInfo: userInfo)
    }

    func addObserver<A: NotificationEnum>(name: Notification.Name,
                                          object: Any? = nil, queue: OperationQueue? = nil,
                                          using block: @escaping (A, Any?) -> ()) -> NotificationToken {
        let token = addObserver(forName: name, object: object, queue: queue, using: { note in
            guard let note = note.userInfo?[NotificationCenter._$key$_] as? A else { assert(false) }
            block(note, object)
        })

        return NotificationToken(token: token, center: self)
    }
}
