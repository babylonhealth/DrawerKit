import UIKit

public struct PassthroughOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let collapsed            = PassthroughOptions(rawValue: 1 << 0)
    public static let partiallyExpanded    = PassthroughOptions(rawValue: 1 << 1)
    public static let fullyExpanded        = PassthroughOptions(rawValue: 1 << 2)
    public static let all: PassthroughOptions = [.collapsed, .partiallyExpanded, .fullyExpanded]
}

protocol PresentationContainerViewDelegate: class {
    func view(_ view: PresentationContainerView, shouldPassthroughTouchAt point: CGPoint) -> Bool
    func view(_ view: PresentationContainerView, forTouchAt point: CGPoint) -> UIView?
}

class PresentationContainerView: UIView {
    weak var touchDelegate: PresentationContainerViewDelegate?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let touchDelegate = touchDelegate,
            touchDelegate.view(self, shouldPassthroughTouchAt: point),
            let viewForTouch = touchDelegate.view(self, forTouchAt: point) else {
                return super.hitTest(point, with: event)
        }

        let pointInView = viewForTouch.convert(point, from: self)
        return viewForTouch.hitTest(pointInView, with: event)
    }
}
