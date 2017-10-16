import UIKit
import DrawerKit

class PresentedViewController: UIViewController {
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
}

extension PresentedViewController: DrawerPresentable {
    var drawerConfiguration: DrawerConfiguration {
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

        return configuration
    }
    
    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }
        return view.dividerView.frame.origin.y
    }

    var inDrawerDebugMode: Bool {
        return true
    }
}

extension PresentedViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return (view as? PresentedView)?.imageView
    }
}
