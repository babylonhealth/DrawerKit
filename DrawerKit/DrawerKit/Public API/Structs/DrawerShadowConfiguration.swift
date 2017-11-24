import UIKit

/// Configuration options for the drawer's shadow.

public struct DrawerShadowConfiguration {
    /// The drawer's layer’s shadow's opacity. The default value is 0, so
    /// effectively the default is not to have any shadow at all.
    public let shadowOpacity: CGFloat

    /// The blur radius (in points) used to render the drawer's layer’s shadow.
    /// The default value is 0, so effectively the default is not to have any
    /// shadow at all.
    public let shadowRadius: CGFloat

    /// The offset (in points) of the drawer's layer’s shadow. The default value is
    /// `CGSize.zero`, so effectively the default is not to have any shadow at all.
    public let shadowOffset: CGSize

    /// The drawer's layer’s shadow's color. The default value is `nil`, so
    /// effectively the default is not to have any shadow at all.
    public let shadowColor: UIColor?

    public init(shadowOpacity: CGFloat = 0,
                shadowRadius: CGFloat = 0,
                shadowOffset: CGSize = .zero,
                shadowColor: UIColor? = nil) {
        self.shadowOpacity = min(max(0, shadowOpacity), 1)
        self.shadowRadius = max(0, shadowRadius)
        let validatedSize = CGSize(width: max(0, shadowOffset.width),
                                   height: max(0, shadowOffset.height))
        self.shadowOffset = validatedSize
        self.shadowColor = shadowColor
    }
}

extension DrawerShadowConfiguration: Equatable {
    public static func ==(lhs: DrawerShadowConfiguration, rhs: DrawerShadowConfiguration) -> Bool {
        return lhs.shadowOpacity == rhs.shadowOpacity
            && lhs.shadowRadius == rhs.shadowRadius
            && lhs.shadowOffset == rhs.shadowOffset
            && lhs.shadowColor == rhs.shadowColor
    }
}
