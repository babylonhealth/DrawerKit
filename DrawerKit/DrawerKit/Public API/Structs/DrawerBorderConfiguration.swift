import UIKit

/// Configuration options for the drawer's border.

public struct DrawerBorderConfiguration {
    /// The drawer's layer’s border thickness. The default value is 0,
    /// so effectively the default is not to have any border at all.
    public let borderThickness: CGFloat

    /// The drawer's layer’s border's color. The default value is `nil`, so
    /// effectively the default is not to have any border at all.
    public let borderColor: UIColor?

    public init(borderThickness: CGFloat = 0, borderColor: UIColor? = nil) {
        self.borderThickness = max(0, borderThickness)
        self.borderColor = borderColor
    }
}

extension DrawerBorderConfiguration: Equatable {
    public static func ==(lhs: DrawerBorderConfiguration, rhs: DrawerBorderConfiguration) -> Bool {
        return lhs.borderThickness == rhs.borderThickness && lhs.borderColor == rhs.borderColor
    }
}
