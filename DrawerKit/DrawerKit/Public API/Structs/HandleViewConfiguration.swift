import UIKit

/// Configuration options for the handle view.

public struct HandleViewConfiguration {
    public enum CornerRadius: Equatable {
        /// Results in a corner radius that is half the handle view's height.
        case automatic
        case custom(radius: CGFloat)

        public static func ==(lhs: HandleViewConfiguration.CornerRadius,
                              rhs: HandleViewConfiguration.CornerRadius) -> Bool {
            switch (lhs, rhs) {
            case (.automatic, .automatic):
                return true
            case let (.custom(lhsRadius), .custom(rhsRadius)):
                return lhsRadius == rhsRadius
            default:
                return false
            }
        }
    }

    /// Whether or not to automatically dim the handle view as the drawer approaches
    /// its collapsed or fully expanded states. The default is `true`. Set it to `false`
    /// when configuring the drawer not to cover the full screen so that the handle view
    /// is always visible in that case.
    public var autoAnimatesDimming: Bool

    /// The handle view's background color. The default value is `UIColor.gray`.
    public var backgroundColor: UIColor

    /// The handle view's bounding rectangle's size. The default value is
    /// `CGSize(width: 40, height: 6)`.
    public var size: CGSize

    /// The handle view's vertical distance from the top of the drawer. In other words,
    /// the constant to be used when setting up the layout constraint
    /// `handleView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: top)`
    /// The default value is 8 points.
    public var top: CGFloat

    /// The handle view's corner radius. The default is `CornerRadius.automatic`, which
    /// results in a corner radius equal to half the handle view's height.
    public var cornerRadius: CornerRadius

    public init(autoAnimatesDimming: Bool = true,
                backgroundColor: UIColor = .gray,
                size: CGSize = CGSize(width: 40, height: 6),
                top: CGFloat = 8,
                cornerRadius: CornerRadius = .automatic) {
        self.autoAnimatesDimming = autoAnimatesDimming

        if backgroundColor == .clear {
            self.backgroundColor = .gray
        } else {
            self.backgroundColor = backgroundColor
        }

        let validatedSize = CGSize(width: max(0, size.width), height: max(0, size.height))
        if validatedSize.width == 0 || validatedSize.height == 0 {
            self.size = CGSize(width: 40, height: 6)
        } else {
            self.size = validatedSize
        }

        self.top = max(0, top)

        switch cornerRadius {
        case .automatic:
            self.cornerRadius = .automatic
        case let .custom(radius):
            self.cornerRadius = .custom(radius: max(0, radius))
        }
    }
}

extension HandleViewConfiguration: Equatable {
    public static func ==(lhs: HandleViewConfiguration, rhs: HandleViewConfiguration) -> Bool {
        return lhs.autoAnimatesDimming == rhs.autoAnimatesDimming
            && lhs.backgroundColor == rhs.backgroundColor
            && lhs.top == rhs.top
            && lhs.size == rhs.size
            && lhs.cornerRadius == rhs.cornerRadius
    }
}
