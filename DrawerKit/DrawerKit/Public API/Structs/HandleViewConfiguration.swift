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

    /// The handle view's background color. The default value is `UIColor.gray`.
    public var backgroundColor: UIColor

    /// The handle view's bounding rectangle's size. The default value is
    /// `CGSize(width: 40, height: 6)`.
    public var size: CGSize

    /// The handle view's corner radius. The default is `CornerRadius.automatic`, which
    /// results in a corner radius equal to half the handle view's height.
    public var cornerRadius: CornerRadius

    public init(backgroundColor: UIColor = .gray,
                size: CGSize = CGSize(width: 40, height: 6),
                cornerRadius: CornerRadius = .automatic) {
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
        return lhs.backgroundColor == rhs.backgroundColor
            && lhs.size == rhs.size
            && lhs.cornerRadius == rhs.cornerRadius
    }
}
