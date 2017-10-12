import UIKit

@IBDesignable
class SliderView: UIView {
    static func loadFromNib() -> SliderView {
        let nib = UINib(nibName: "SliderView", bundle: nil)
        let items = nib.instantiate(withOwner: nil, options: nil)
        let view = items.filter { $0 is SliderView }.first as? SliderView
        return view!
    }

    func configureWith(title: String,
                       minValue: Double, maxValue: Double,
                       initialValue: Double, defaultValue: Double) {
        let minV = min(minValue, maxValue)
        let maxV = max(minValue, maxValue)
        let initialV = min(max(minValue, initialValue), maxValue)
        let defaultV = min(max(minValue, defaultValue), maxValue)
        titleLabel.text = title
        minValueLabel.text = format(value: minV)
        maxValueLabel.text = format(value: maxV)
        minValueButton.tag = ButtonTag.min.rawValue
        maxValueButton.tag = ButtonTag.max.rawValue
        textField.delegate = self
        slider.minimumValue = Float(minV)
        slider.maximumValue = Float(maxV)
        slider.value = Float(initialV)
        self.defaultValue = defaultV
    }

    var value: Double {
        get { return Double(_value) }
        set {
            let currentValue = Double(_value)
            guard newValue != currentValue else { return }
            set(value: newValue)
        }
    }

    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var minValueButton: UIButton!
    @IBOutlet weak var maxValueButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var slider: UISlider!

    private var defaultValue: Double = 0
    private var _value: Double = 0

    let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.allowsFloats = true
        f.minimumIntegerDigits = 1
        f.minimumFractionDigits = 1
        f.maximumFractionDigits = 1
        return f
    }()
}

private extension SliderView {
    enum ButtonTag: Int {
    case min = 0
    case max
    }

    @IBAction func buttonTapped(sender: UIButton) {
        guard let btnTag = ButtonTag(rawValue: sender.tag) else { return }
        switch btnTag {
        case .min:
            value = Double(slider.minimumValue)
        case .max:
            value = Double(slider.maximumValue)
        }
    }

    @IBAction func sliderValueChanged() {
        guard value != Double(slider.value) else { return }
        value = Double(slider.value)
    }
}

extension SliderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Double(textField.text ?? "0") else {
            self.value = defaultValue
            return
        }
        self.value = value
    }
}

private extension SliderView {
    func set(value: Double) {
        let sanitisedValue = sanitize(value: value)
        textField.text = format(value: sanitisedValue)
        slider.value = Float(sanitisedValue)
        _value = Double(sanitisedValue)
    }

    func sanitize(value: Double) -> Double {
        let minValue = Double(slider.minimumValue)
        let maxValue = Double(slider.maximumValue)
        let value = min(maxValue, max(value, minValue))
        return Double(trunc(10 * value)) / 10
    }

    func format(value: Double) -> String? {
        let nsValue = NSNumber(value: value)
        return formatter.string(from: nsValue)
    }
}
