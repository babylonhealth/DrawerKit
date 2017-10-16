import UIKit
import DrawerKit

class PresentedViewController: UIViewController {
    private var drawerController: DrawerController!

    override func awakeFromNib() {
        super.awakeFromNib()

        // you can provide the configuration values in the initialiser...
        var configuration = DrawerConfiguration(/* ..., ..., ..., */)

        // ... or after initialisation
        configuration.durationInSeconds = 0.8
        configuration.timingCurveProvider = UISpringTimingParameters(dampingRatio: 0.8)
        configuration.supportsPartialExpansion = true
        configuration.dismissesInStages = true
        configuration.isDrawerDraggable = true
        configuration.isDismissableByOutsideDrawerTaps = true
        configuration.numberOfTapsForOutsideDrawerDismissal = 1
        configuration.flickSpeedThreshold = 3
        configuration.upperMarkGap = 30
        configuration.lowerMarkGap = 30
        configuration.maximumCornerRadius = 20

        drawerController = DrawerController(configuration: configuration, inDebugMode: true)
        modalPresentationStyle = .custom
        transitioningDelegate = drawerController
    }

    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

extension PresentedViewController: PartiallyExpandableDrawer {
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
