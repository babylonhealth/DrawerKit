import UIKit
import DrawerKit

class PresentedViewController: UIViewController {
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

extension PresentedViewController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }
        return view.dividerView.frame.origin.y
    }
}

extension PresentedViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return (view as? PresentedView)?.imageView
    }
}
