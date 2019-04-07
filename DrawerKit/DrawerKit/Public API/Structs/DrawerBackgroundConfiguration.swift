import UIKit

/// Configuration options for the drawer's background.
public struct DrawerBackgroundConfiguration {
    /// BackgroundView builder.
    internal let make: () -> UIView

    /// BackgroundView handler.
    internal let handle: (UIView, HandleContext) -> Void

    public init<BackgroundView>(make: @escaping () -> BackgroundView,
                                handle: @escaping (BackgroundView, HandleContext) -> Void)
        where BackgroundView: UIView {
        self.make = make
        self.handle = { handle($0 as! BackgroundView, $1) }
    }

    // MARK: - HandleContext

    public struct HandleContext {
        public let currentY: CGFloat
        public let containerHeight: CGFloat
    }
}

extension DrawerBackgroundConfiguration {
    /// Dark background
    public static let dark: DrawerBackgroundConfiguration = .init(
        make: { () -> UIView in
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            backgroundView.alpha = 0
            return backgroundView
        },
        handle: {
            $0.alpha = (1 - $1.currentY / $1.containerHeight)
        }
    )
}
