import UIKit
import DrawerKit

// Search for the string 'THIS IS THE IMPORTANT PART' in both view controllers
// to see how to show the drawer. There may be more than one important part in
// each view controller.

// ======== THIS IS THE IMPORTANT PART ======== //
class PresenterViewController: UIViewController, DrawerPresenting {
    /* strong */ var drawerDisplayController: DrawerDisplayController?
    // ============================================ //
    private static let defaultDuration: Float = 0.8
    private var _duration: TimeInterval = 0
    private var duration: Float {
        get { return Float(_duration) }
        set {
            let currentDuration = Float(_duration)
            guard newValue != currentDuration else { return }
            set(duration: newValue)
        }
    }

    private var hasFixedHeight = false
    private var coversStatusBar = true
    private var supportsPartialExpansion = true
    private var dismissesInStages = true
    private var isDrawerDraggable = true
    private var isDismissableByOutsideDrawerTaps = true
    private var numberOfTapsForOutsideDrawerDismissal: Int = 1

    @IBOutlet weak var hasFixedHeightSwitch: UISwitch!
    @IBOutlet weak var coversStatusBarSwitch: UISwitch!
    @IBOutlet weak var supportsPartialExpansionSwitch: UISwitch!
    @IBOutlet weak var dismissesInStagesSwitch: UISwitch!
    @IBOutlet weak var drawerDraggableSwitch: UISwitch!
    @IBOutlet weak var dismissableByOutsideTapButton: UIButton!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var durationField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.allowsFloats = true
        f.minimumIntegerDigits = 1
        f.minimumFractionDigits = 1
        f.maximumFractionDigits = 1
        return f
    }()
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
        let partialTimingParams =
            TimingConfiguration(durationInSeconds: 0.8,
                                timingCurveProvider: UISpringTimingParameters(dampingRatio: 0.7))
        let fullTimingParams =
            TimingConfiguration(durationInSeconds: 0.8,
                                timingCurveProvider: UISpringTimingParameters(dampingRatio: 0.2))
        configuration.partialTransitionTimingConfiguration = partialTimingParams
        configuration.fullTransitionTimingConfiguration = fullTimingParams

        configuration.coversStatusBar = coversStatusBar
        configuration.supportsPartialExpansion = supportsPartialExpansion
        configuration.dismissesInStages = dismissesInStages
        configuration.isDrawerDraggable = isDrawerDraggable
        configuration.isDismissableByOutsideDrawerTaps = isDismissableByOutsideDrawerTaps
//        configuration.flickSpeedThreshold = flickSpeedThreshold // XXX
//        configuration.upperMarkFraction = upperMarkFraction
//        configuration.lowerMarkFraction = lowerMarkFraction
//        configuration.maximumCornerRadius = maximumCornerRadius

        drawerDisplayController = DrawerDisplayController(presentingViewController: self,
                                                          presentedViewController: vc,
                                                          configuration: configuration)
        // ============================================ //

        present(vc, animated: true)
    }
}

extension PresenterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let duration = Float(textField.text ?? "0") else {
            self.duration = PresenterViewController.defaultDuration
            return
        }
        self.duration = duration
    }
}

extension PresenterViewController {
    @IBAction func presentButtonTapped() {
        doModalPresentation()
    }

    @IBAction func sliderSideButtonTapped(sender: UIButton) {
        handleSliderSideButtonTapped(sender)
    }

    @IBAction func durationSliderChanged() {
        guard duration != durationSlider.value else { return }
        duration = durationSlider.value
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
        duration = PresenterViewController.defaultDuration
        hasFixedHeightSwitch.isOn = hasFixedHeight
        coversStatusBarSwitch.isOn = coversStatusBar
        supportsPartialExpansionSwitch.isOn = supportsPartialExpansion
        dismissesInStagesSwitch.isEnabled = supportsPartialExpansion
        dismissesInStagesSwitch.isOn = dismissesInStages
        drawerDraggableSwitch.isOn = isDrawerDraggable
        dismissableByOutsideTapButton.setTitle("\(numberOfTapsForOutsideDrawerDismissal)", for: .normal)
    }

    func handleSliderSideButtonTapped(_ button: UIButton) {
        enum ButtonTag: Int {
            case min = 0
            case max
        }
        guard let btnTag = ButtonTag(rawValue: button.tag) else { return }
        switch btnTag {
        case .min:
            duration = durationSlider.minimumValue
        case .max:
            duration = durationSlider.maximumValue
        }
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

    func set(duration: Float) {
        let sanitisedDuration = sanitize(duration: duration)
        let nsDuration = NSNumber(value: sanitisedDuration)
        durationField.text = PresenterViewController.formatter.string(from: nsDuration)
        durationSlider.value = sanitisedDuration
        _duration = TimeInterval(sanitisedDuration)
    }

    func sanitize(duration: Float) -> Float {
        let minDuration = durationSlider.minimumValue
        let maxDuration = durationSlider.maximumValue
        let value = min(maxDuration, max(duration, minDuration))
        return Float(truncf(10 * value)) / 10
    }
}
