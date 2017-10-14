import UIKit

@IBDesignable
class SwitchView: UIControl {
    let label = UILabel()
    let toggler = UISwitch()

    @IBInspectable var title: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    @IBInspectable var textColor: UIColor {
        get { return label.textColor }
        set { label.textColor = newValue }
    }

    @IBInspectable var isOn: Bool {
        get { return toggler.isOn }
        set { toggler.isOn = newValue }
    }

    @IBInspectable var onTint: UIColor? {
        get { return toggler.onTintColor }
        set { toggler.onTintColor = newValue }
    }

    @IBInspectable var thumbTint: UIColor? {
        get { return toggler.thumbTintColor }
        set { toggler.thumbTintColor = newValue }
    }

    @IBInspectable var indented: Bool {
        get { return !indentationView.isHidden }
        set { indentationView.isHidden = !newValue }
    }

    @IBInspectable var indentation: CGFloat {
        get { return indentationConstraint?.constant ?? 0 }
        set {
            indentationConstraint?.constant = newValue
            layoutIfNeeded()
        }
    }

    init(title: String? = nil,
         initiallyOn: Bool = true,
         indented: Bool = false,
         indentation: CGFloat = 20) {
        super.init(frame: .zero)
        self.title = title
        self.isOn = initiallyOn
        self.indented = indented
        self.indentation = indentation
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
        var size = CGSize.zero
        let labelS = label.intrinsicContentSize
        let togglerS = toggler.intrinsicContentSize
        let indentW = (indented ? indentation : 0)
        size.width = indentW + labelS.width + minPadViewW + togglerS.width
        size.height = max(labelS.height, togglerS.height)
        return size
    }

    override var isEnabled: Bool {
        didSet { toggler.isEnabled = isEnabled }
    }

    override func addTarget(_ target: Any?,
                            action: Selector,
                            for controlEvents: UIControlEvents) {
        toggler.addTarget(target, action: action, for: controlEvents)
    }

    override func removeTarget(_ target: Any?,
                               action: Selector?,
                               for controlEvents: UIControlEvents) {
        toggler.removeTarget(target, action: action, for: controlEvents)
    }

    private let containerView = UIStackView()
    private let padViewL = UIView()
    private let padViewR = UIView()
    private let minPadViewW: CGFloat = 8
    private let indentationView = UIView()
    private var indentationConstraint: NSLayoutConstraint!
    private let textFont = UIFont.systemFont(ofSize: 15)
}

private extension SwitchView {
    func setup() {
        toggler.isOn = isOn
        setupLabel()
        setupContainerView()
        setupSelf()
        setupConstraints()
    }

    func setupLabel() {
        label.font = textFont
        label.textAlignment = .left
        label.text = title
    }

    func setupContainerView() {
        containerView.axis = .horizontal
        containerView.alignment = .center
        containerView.distribution = .fill
        containerView.spacing = 0
        containerView.addArrangedSubview(indentationView)
        containerView.addArrangedSubview(label)
        containerView.addArrangedSubview(padViewL)
        containerView.addArrangedSubview(toggler)
        containerView.addArrangedSubview(padViewR)
    }

    func setupSelf() {
        backgroundColor = .clear
        addSubview(containerView)
    }

    func setupConstraints() {
        setupIndentationViewConstraints()
        setupPadViewLConstraints()
        setupPadViewRConstraints()
        setupContainerViewConstraints()
    }

    func setupIndentationViewConstraints() {
        indentationView.translatesAutoresizingMaskIntoConstraints = false
        indentationView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        indentationConstraint = indentationView.widthAnchor.constraint(equalToConstant: indentation)
        indentationConstraint.isActive = true
        indentationView.isHidden = !indented
    }

    func setupPadViewLConstraints() {
        padViewL.translatesAutoresizingMaskIntoConstraints = false
        padViewL.widthAnchor.constraint(greaterThanOrEqualToConstant: minPadViewW).isActive = true
        padViewL.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }

    func setupPadViewRConstraints() {
        padViewR.translatesAutoresizingMaskIntoConstraints = false
        padViewR.widthAnchor.constraint(equalToConstant: 2).isActive = true
    }

    func setupContainerViewConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
