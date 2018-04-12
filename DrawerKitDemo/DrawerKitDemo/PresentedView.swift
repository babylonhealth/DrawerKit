import UIKit

class PresentedView: UIScrollView {
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
}

extension PresentedView {
    func prepareCollapsedToPartiallyExpanded() {
        bodyLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dismissButton.alpha = 0
    }

    func animateAlongCollapsedToPartiallyExpanded() {
        bodyLabel.transform = .identity
        dismissButton.alpha = 1
    }

    func cleanupCollapsedToPartiallyExpanded() {
        animateAlongCollapsedToPartiallyExpanded()
    }

    func preparePartiallyExpandedToCollapsed() {
        animateAlongCollapsedToPartiallyExpanded()
    }

    func animateAlongPartiallyExpandedToCollapsed() {
        prepareCollapsedToPartiallyExpanded()
    }

    func cleanupPartiallyExpandedToCollapsed() {
        prepareCollapsedToPartiallyExpanded()
    }
}

extension PresentedView {
    func preparePartiallyExpandedToFullyExpanded() {
        bodyLabel.transform = .identity
    }

    func animateAlongPartiallyExpandedToFullyExpanded() {
        bodyLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }

    func cleanupPartiallyExpandedToFullyExpanded() {
        animateAlongPartiallyExpandedToFullyExpanded()
    }

    func prepareFullyExpandedToPartiallyExpanded() {
        animateAlongPartiallyExpandedToFullyExpanded()
    }

    func animateAlongFullyExpandedToPartiallyExpanded() {
        preparePartiallyExpandedToFullyExpanded()
    }

    func cleanupFullyExpandedToPartiallyExpanded() {
        preparePartiallyExpandedToFullyExpanded()
    }
}

extension PresentedView {
    func prepareCollapsedToFullyExpanded() {
        bodyLabel.transform = .identity
    }

    func animateAlongCollapsedToFullyExpanded() {
        bodyLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }

    func cleanupCollapsedToFullyExpanded() {
        animateAlongCollapsedToFullyExpanded()
    }

    func prepareFullyExpandedToCollapsed() {
        animateAlongCollapsedToFullyExpanded()
    }

    func animateAlongFullyExpandedToCollapsed() {
        prepareCollapsedToFullyExpanded()
    }

    func cleanupFullyExpandedToCollapsed() {
        prepareCollapsedToFullyExpanded()
    }
}
