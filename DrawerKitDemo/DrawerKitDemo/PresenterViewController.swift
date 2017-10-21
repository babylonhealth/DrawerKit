import UIKit
import DrawerKit

class PresenterViewController: UIViewController, DrawerPresenting {
    /* strong */ var drawerDisplayController: DrawerDisplayController?

    @IBAction func presentButtonTapped() {
        doModalPresentation()
    }
}

private extension PresenterViewController {
    func doModalPresentation() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "presented")
            as? PresentedViewController else { return }

        // you can provide the configuration values in the initialiser...
        var configuration = DrawerConfiguration(/* ..., ..., ..., */)

        // ... or after initialisation. All of these have default values so change only
        // what you need to configure differently. They're all listed here just so you
        // can see what can be configured.
        configuration.durationInSeconds = 0.8
        configuration.timingCurveProvider = UISpringTimingParameters(dampingRatio: 0.8)
        configuration.supportsPartialExpansion = true
        configuration.dismissesInStages = true
        configuration.isDrawerDraggable = true
        configuration.isFullyPresentableByDrawerTaps = true
        configuration.numberOfTapsForFullDrawerPresentation = 1
        configuration.isDismissableByOutsideDrawerTaps = true
        configuration.numberOfTapsForOutsideDrawerDismissal = 1
        configuration.flickSpeedThreshold = 3
        configuration.upperMarkGap = 30
        configuration.lowerMarkGap = 30
        configuration.maximumCornerRadius = 20

        drawerDisplayController = DrawerDisplayController(presentingViewController: self,
                                                          presentedViewController: vc,
                                                          configuration: configuration,
                                                          inDebugMode: true)

        present(vc, animated: true)
    }
}
