import UIKit

@IBDesignable
class SliderView: UIControl {
    let label = UILabel()
    let textField = UITextField()
    let minimumValueButton: UIButton = UIButton(type: .custom)
    let maximumValueButton: UIButton = UIButton(type: .custom)
    let slider = UISlider()

    @IBInspectable var title: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    @IBInspectable var textColor: UIColor {
        get { return label.textColor }
        set {
            label.textColor = newValue
            textField.textColor = newValue
            minimumValueButton.setTitleColor(newValue, for: .normal)
            maximumValueButton.setTitleColor(newValue, for: .normal)
        }
    }

    @IBInspectable var minimumValue: Double {
        get { return Double(slider.minimumValue) }
        set {
            slider.minimumValue = Float(newValue)
            minimumValueButton.setTitle(format(value: newValue), for: .normal)
        }
    }

    @IBInspectable var maximumValue: Double {
        get { return Double(slider.maximumValue) }
        set {
            slider.maximumValue = Float(newValue)
            maximumValueButton.setTitle(format(value: newValue), for: .normal)
        }
    }

    @IBInspectable var value: Double {
        get { return Double(_value) }
        set {
            let currentValue = Double(_value)
            guard newValue != currentValue else { return }
            set(value: newValue)
        }
    }

    @IBInspectable var maximumFractionDigits: Int {
        get { return formatter.maximumFractionDigits }
        set {
            formatter.maximumFractionDigits = max(0, newValue)
            minimumValueButton.setTitle(format(value: sanitize(value: minimumValue)), for: .normal)
            maximumValueButton.setTitle(format(value: sanitize(value: maximumValue)), for: .normal)
            textField.text = format(value: sanitize(value: value))
        }
    }

    @IBInspectable var minimumTrackTintColor: UIColor? {
        get { return slider.minimumTrackTintColor }
        set { slider.minimumTrackTintColor = newValue }
    }

    @IBInspectable var maximumTrackTintColor: UIColor? {
        get { return slider.maximumTrackTintColor }
        set { slider.maximumTrackTintColor = newValue }
    }

    @IBInspectable var thumbTintColor: UIColor? {
        get { return slider.thumbTintColor }
        set { slider.thumbTintColor = newValue }
    }

    init(title: String? = nil,
         minimumValue: Double = 0,
         maximumValue: Double = 1,
         initialValue: Double = 0.5) {
        super.init(frame: .zero)
        let minValue = min(minimumValue, maximumValue)
        let maxValue = max(minimumValue, maximumValue)
        self.minimumValue = minValue
        self.maximumValue = maxValue
        self.initialValue = min(max(minValue, initialValue), maxValue)
        self.title = title
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        return containerViewIntrinsicContentSize
    }

    override var isEnabled: Bool {
        didSet {
            textField.isEnabled = isEnabled
            minimumValueButton.isEnabled = isEnabled
            maximumValueButton.isEnabled = isEnabled
            slider.isEnabled = isEnabled
        }
    }

    override func addTarget(_ target: Any?,
                            action: Selector,
                            for controlEvents: UIControlEvents) {
        slider.addTarget(target, action: action, for: controlEvents)
    }

    override func removeTarget(_ target: Any?,
                               action: Selector?,
                               for controlEvents: UIControlEvents) {
        slider.removeTarget(target, action: action, for: controlEvents)
    }

    private var initialValue: Double = 0.5
    private var _value: Double = 0.5

    private let containerView = UIStackView()
    private let textContainer = UIStackView()
    private let upperView = UIStackView()

    private let textFont = UIFont.systemFont(ofSize: 15)
    private let minMaxButtonW: CGFloat = 35
    private let minMaxButtonH: CGFloat = 35
    private let formatter = NumberFormatter()
}

private extension SliderView {
    enum ButtonTag: Int {
        case min = 0
        case max
    }

    func setup() {
        setupFormatter()
        setupLabel()
        setupTextField()
        setupTextContainer()
        setupButton(minimumValueButton, value: minimumValue, tag: .min)
        minimumValueButton.contentHorizontalAlignment = .left
        setupButton(maximumValueButton, value: maximumValue, tag: .max)
        maximumValueButton.contentHorizontalAlignment = .right
        setupUpperView()
        setupSlider()
        setupContainerView()
        setupSelf()
    }

    func setupFormatter() {
        formatter.allowsFloats = true
        formatter.minimumIntegerDigits = 1
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
    }

    func setupLabel() {
        label.font = textFont
        label.text = title
        label.textAlignment = .right
    }

    func setupTextField() {
        textField.text = format(value: initialValue)
        textField.font = textFont
        textField.textAlignment = .left
        textField.delegate = self
    }

    func setupTextContainer() {
        textContainer.axis = .horizontal
        textContainer.alignment = .firstBaseline
        textContainer.distribution = .fill
        textContainer.spacing = 8
        upperView.addArrangedSubview(minimumValueButton)
        textContainer.addArrangedSubview(label)
        textContainer.addArrangedSubview(textField)
        textContainer.addArrangedSubview(UIView())
    }

    var textContainerIntrinsicContentSize: CGSize {
        var size = CGSize.zero
        let labelS = label.intrinsicContentSize
        let minPadW = textContainer.spacing
        let fieldS = textField.intrinsicContentSize
        size.width = minMaxButtonW + 3 * minPadW + labelS.width + fieldS.width
        size.height = max(minMaxButtonH, labelS.height, fieldS.height)
        return size
    }

    func setupButton(_ button: UIButton, value: Double, tag: ButtonTag) {
        button.addTarget(self, action: #selector(buttonTapped(btn:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: minMaxButtonW).isActive = true
        button.heightAnchor.constraint(equalToConstant: minMaxButtonH).isActive = true
        button.titleLabel?.font = label.font
        button.setTitleColor(label.textColor, for: .normal)
        button.setTitle(format(value: sanitize(value: value)), for: .normal)
        button.tag = tag.rawValue
    }

    func setupUpperView() {
        upperView.axis = .horizontal
        upperView.alignment = .firstBaseline
        upperView.distribution = .fill
        upperView.spacing = 8
        upperView.addArrangedSubview(textContainer)
        upperView.addArrangedSubview(maximumValueButton)
    }

    var upperViewIntrinsicContentSize: CGSize {
        var size = CGSize.zero
        let textContainerS = textContainerIntrinsicContentSize
        size.width = textContainerS.width + upperView.spacing + minMaxButtonW
        size.height = max(textContainerS.height, minMaxButtonH)
        return size
    }

    func setupSlider() {
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = Float(minimumValue)
        slider.maximumValue = Float(maximumValue)
        slider.value = Float(initialValue)
    }

    func setupContainerView() {
        containerView.axis = .vertical
        containerView.alignment = .fill
        containerView.distribution = .fill
        containerView.spacing = 0
        containerView.addArrangedSubview(upperView)
        containerView.addArrangedSubview(slider)
    }

    var containerViewIntrinsicContentSize: CGSize {
        var size = CGSize.zero
        let upperViewS = upperViewIntrinsicContentSize
        let sliderS = slider.intrinsicContentSize
        size.width = max(upperViewS.width, sliderS.width)
        size.height = upperViewS.height + containerView.spacing + sliderS.height
        return size
    }

    func setupSelf() {
        addSubview(containerView)
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

extension SliderView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Double(textField.text ?? "\(initialValue)") else {
            self.value = initialValue
            return
        }
        self.value = value
    }
}

private extension SliderView {
    @objc func buttonTapped(btn: UIButton) {
        guard let btnTag = ButtonTag(rawValue: btn.tag) else { return }
        switch btnTag {
        case .min:
            self.value = Double(slider.minimumValue)
        case .max:
            self.value = Double(slider.maximumValue)
        }
    }

    @objc func sliderValueChanged() {
        guard value != Double(slider.value) else { return }
        self.value = Double(slider.value)
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
        let minimumValue = Double(slider.minimumValue)
        let maximumValue = Double(slider.maximumValue)
        let value = min(maximumValue, max(value, minimumValue))
        var k = maximumFractionDigits
        var factor: Double = 1; while k > 0 { factor *= 10; k -= 1 }
        return Double(trunc(factor * value)) / factor
    }

    func format(value: Double) -> String? {
        let nsValue = NSNumber(value: value)
        return formatter.string(from: nsValue)
    }
}
