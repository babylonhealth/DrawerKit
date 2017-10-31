import UIKit

class PresentedView: UIView {
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        handleView.layer.masksToBounds = true
        handleView.layer.cornerRadius = 3
    }
}

extension PresentedView {
    func prepareCollapsedToPartiallyExpanded() {
        handleView.alpha = 0
        titleLabel.alpha = 0
        bodyLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        dismissButton.alpha = 0
    }

    func animateAlongCollapsedToPartiallyExpanded() {
        handleView.alpha = 1
        titleLabel.alpha = 1
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
        handleView.alpha = 1
        bodyLabel.transform = .identity
    }

    func animateAlongPartiallyExpandedToFullyExpanded() {
        handleView.alpha = 0
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
        // XXX
    }

    func animateAlongCollapsedToFullyExpanded() {
        // XXX
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
