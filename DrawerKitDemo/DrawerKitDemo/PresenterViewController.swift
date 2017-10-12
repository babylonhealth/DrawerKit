import UIKit
import DrawerKit

// Search for the string 'THIS IS THE IMPORTANT PART' in both view controllers
// to see how to show the drawer. There may be more than one important part in
// each view controller.

// ======== THIS IS THE IMPORTANT PART ======== //
class PresenterViewController: UIViewController, DrawerPresenting {
    /* strong */ var drawerDisplayController: DrawerDisplayController?
    // ============================================ //

    private var durationInSeconds: CGFloat = 0.8
    private var hasFixedHeight = false
    private var coversStatusBar = true
    private var supportsPartialExpansion = true
    private var dismissesInStages = true
    private var isDrawerDraggable = true
    private var isDismissableByOutsideDrawerTaps = true
    private var numberOfTapsForOutsideDrawerDismissal: Int = 1
    private var flickSpeedThreshold: CGFloat = 3
    private var upperMarkFraction: CGFloat = 0.5
    private var lowerMarkFraction: CGFloat = 0.5
    private var maximumCornerRadius: CGFloat = 30

    @IBOutlet weak var hasFixedHeightSwitch: UISwitch!
    @IBOutlet weak var coversStatusBarSwitch: UISwitch!
    @IBOutlet weak var supportsPartialExpansionSwitch: UISwitch!
    @IBOutlet weak var dismissesInStagesSwitch: UISwitch!
    @IBOutlet weak var drawerDraggableSwitch: UISwitch!
    @IBOutlet weak var dismissableByOutsideTapButton: UIButton!
    @IBOutlet weak var durationSliderView: SliderView!
    @IBOutlet weak var flickSpeedThresholdSliderView: SliderView!
    @IBOutlet weak var upperMarkFractionSliderView: SliderView!
    @IBOutlet weak var lowerMarkFractionSliderView: SliderView!
    @IBOutlet weak var maximumCornerRadiusSliderView: SliderView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension PresenterViewController {
    private func doModalPresentation() {
        let sb = UIStoryboard(name: "PresentedVC", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "presented")
            as? PresentedViewController else { return }
        vc.hasFixedHeight = hasFixedHeight

        // ======== THIS IS THE IMPORTANT PART ======== //
        // you can provide the configuration values in the initialiser...
        var configuration = DrawerConfiguration(/* ..., ..., ..., */)

        // ... or after initialisation
        configuration.durationInSeconds = 0.8 // TimeInterval(durationSliderView.value)
        configuration.timingCurveProvider = UISpringTimingParameters(dampingRatio: 0.7)
        configuration.coversStatusBar = coversStatusBar
        configuration.supportsPartialExpansion = supportsPartialExpansion
        configuration.dismissesInStages = dismissesInStages
        configuration.isDrawerDraggable = isDrawerDraggable
        configuration.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
        configuration.numberOfTapsForOutsideDrawerDismissal = numberOfTapsForOutsideDrawerDismissal
        configuration.flickSpeedThreshold = 3 // flickSpeedThresholdSliderView.value.cgFloat
        configuration.upperMarkFraction = 0.8 // upperMarkFractionSliderView.value.cgFloat
        configuration.lowerMarkFraction = 0.5 // lowerMarkFractionSliderView.value.cgFloat
        configuration.maximumCornerRadius = 15 // maximumCornerRadiusSliderView.value.cgFloat

        drawerDisplayController = DrawerDisplayController(presentingViewController: self,
                                                          presentedViewController: vc,
                                                          configuration: configuration,
                                                          inDebugMode: true)
        // ============================================ //

        present(vc, animated: true)
    }
}

extension PresenterViewController {
    @IBAction func presentButtonTapped() {
        doModalPresentation()
    }

    @IBAction func switchToggled(sender: UISwitch) {
        handleSwitchToggled(sender)
    }

    @IBAction func numberOfTapsButtonTapped(_ sender: UIButton) {
        handleNumberOfTapsButtonTapped(sender)
    }
}

private extension PresenterViewController {
    func setup() {
//        durationSliderView.configureWith(
//            title: "Duration in secs", minValue: 0.3, maxValue: 5,
//            initialValue: 0.8, defaultValue: 0.8)
//        flickSpeedThresholdSliderView.configureWith(
//            title: "Speed threshold", minValue: 1, maxValue: 5,
//            initialValue: 3, defaultValue: 3)
//        upperMarkFractionSliderView.configureWith(
//            title: "Upper mark fraction", minValue: 0, maxValue: 1,
//            initialValue: 0.8, defaultValue: 0.8)
//        lowerMarkFractionSliderView.configureWith(
//            title: "Lower mark fraction", minValue: 0, maxValue: 1,
//            initialValue: 0.5, defaultValue: 0.5)
//        maximumCornerRadiusSliderView.configureWith(
//            title: "Max corner radius", minValue: 0, maxValue: 30,
//            initialValue: 15, defaultValue: 15)
        hasFixedHeightSwitch.isOn = hasFixedHeight
        coversStatusBarSwitch.isOn = coversStatusBar
        supportsPartialExpansionSwitch.isOn = supportsPartialExpansion
        dismissesInStagesSwitch.isEnabled = supportsPartialExpansion
        dismissesInStagesSwitch.isOn = dismissesInStages
        drawerDraggableSwitch.isOn = isDrawerDraggable
        dismissableByOutsideTapButton.setTitle("\(numberOfTapsForOutsideDrawerDismissal)", for: .normal)
    }

    func handleSwitchToggled(_ toggler: UISwitch) {
        switch toggler {
        case hasFixedHeightSwitch:
            hasFixedHeight = toggler.isOn
        case coversStatusBarSwitch:
            coversStatusBar = toggler.isOn
        case supportsPartialExpansionSwitch:
            supportsPartialExpansion = toggler.isOn
            dismissesInStagesSwitch.isEnabled = toggler.isOn
        case dismissesInStagesSwitch:
            dismissesInStages = toggler.isOn
        case drawerDraggableSwitch:
            isDrawerDraggable = toggler.isOn
        default:
            return
        }
    }

    func handleNumberOfTapsButtonTapped(_ button: UIButton) {
        let curValue = Int(button.titleLabel?.text ?? "0") ?? 0
        let newValue = (curValue + 1) % 4
        button.setTitle("\(newValue)", for: .normal)
        switch button {
        case dismissableByOutsideTapButton:
            isDismissableByOutsideDrawerTaps = (newValue > 0)
            numberOfTapsForOutsideDrawerDismissal = newValue
        default:
            return
        }
    }
}

extension Double {
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
}
