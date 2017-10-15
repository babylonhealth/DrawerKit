import UIKit

protocol CubicBezierViewDelegate: class {
    func cubicBezierView(_ view: CubicBezierView,
                         controlPoint1: CGPoint,
                         controlPoint2: CGPoint)
}

@IBDesignable
class CubicBezierView: UIControl, HandleViewDelegate {
    weak var delegate: CubicBezierViewDelegate?
    private var renderer = Renderer()
    private var handleAtZeroZero: HandleView!
    private var handleAtOneOne: HandleView!
    private var actualW: CGFloat = 0
    private var actualH: CGFloat = 0
    private var runningUnderIB = false
    private let fakeSize: CGFloat = 250
    private let dimmingView = UIView()

    @IBInspectable var fractionalRadius: CGFloat = 0.6 {
        didSet { setup(); setNeedsDisplay() }
    }

    @IBInspectable var curveLineWidth: CGFloat = 5 {
        didSet { renderer.curveLineWidth = curveLineWidth; setNeedsDisplay() }
    }

    @IBInspectable var curveLineColor: UIColor = .black {
        didSet { renderer.curveLineColor = curveLineColor; setNeedsDisplay() }
    }

    @IBInspectable var handleSize: CGFloat = 25 {
        didSet { setup(); renderer.handleSize = handleSize; setNeedsDisplay() }
    }

    @IBInspectable var handleLineWidth: CGFloat = 2 {
        didSet { renderer.handleLineWidth = handleLineWidth; setNeedsDisplay() }
    }

    @IBInspectable var handleLineColor: UIColor = .white {
        didSet { renderer.handleLineColor = handleLineColor; setNeedsDisplay() }
    }

    @IBInspectable var handleBorderWidth: CGFloat = 3 {
        didSet { renderer.handleBorderWidth = handleBorderWidth; setNeedsDisplay() }
    }

    @IBInspectable var handleBorderColor: UIColor = .white {
        didSet { renderer.handleBorderColor = handleBorderColor; setNeedsDisplay() }
    }

    @IBInspectable var handleInteriorColor: UIColor = .lightGray {
        didSet { renderer.handleInteriorColor = handleInteriorColor; setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        computeActualSize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        renderer.renderCurve()
        renderer.renderControls()
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                dimmingView.removeFromSuperview()
                isUserInteractionEnabled = true
            } else {
                addSubview(dimmingView)
                dimmingView.frame = bounds
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
                isUserInteractionEnabled = false
            }
        }
    }

    fileprivate func handleViewDidMove(_ view: HandleView) {
        switch view {
        case handleAtZeroZero:
            renderer.frame1 = view.frame
        case handleAtOneOne:
            renderer.frame2 = view.frame
        default:
            return
        }

        delegate?.cubicBezierView(self,
                                  controlPoint1: handleAtZeroZero.center / actualW,
                                  controlPoint2: handleAtOneOne.center / actualW)

        setNeedsDisplay()
    }

    override var frame: CGRect {
        didSet { computeActualSize() }
    }

    private func setup() {
        var pointAtZeroZero = CGPoint(
            x: (bounds.size.width - actualW) / 2,
            y: (bounds.size.height - actualH) / 2 + actualH
        )

        // This is needed because IBDesignable doesn't wait for layout.
        if actualW == 0 || actualH == 0 {
            runningUnderIB = true
            actualW = fakeSize
            actualH = fakeSize
            pointAtZeroZero = CGPoint(x: 0, y: actualH)
        }

        if handleAtZeroZero == nil {
            handleAtZeroZero = HandleView(anchor: pointAtZeroZero,
                                          inverted: false,
                                          delegate: self)
            addSubview(handleAtZeroZero)
        }
        handleAtZeroZero.fractionalRadius = fractionalRadius
        handleAtZeroZero.frame.size.width = handleSize
        handleAtZeroZero.frame.size.height = handleSize
        handleAtZeroZero.center.x = pointAtZeroZero.x + fractionalRadius * actualW
        handleAtZeroZero.center.y = pointAtZeroZero.y

        var pointAtOneOne = pointAtZeroZero
        pointAtOneOne.x += actualW
        pointAtOneOne.y -= actualH
        if handleAtOneOne == nil {
            handleAtOneOne = HandleView(anchor: pointAtOneOne,
                                        inverted: true,
                                        delegate: self)
            addSubview(handleAtOneOne)
        }
        handleAtOneOne.fractionalRadius = fractionalRadius
        handleAtOneOne.frame.size.width = handleSize
        handleAtOneOne.frame.size.height = handleSize
        handleAtOneOne.center.x = pointAtOneOne.x - fractionalRadius * actualW
        handleAtOneOne.center.y = pointAtOneOne.y

        if runningUnderIB {
            let offsetY1: CGFloat = (-30.0/250.0) * fakeSize
            handleAtZeroZero.setCenter(for: offsetY1)
            let offsetY2: CGFloat = (30.0/250.0) * fakeSize
            handleAtOneOne.setCenter(for: offsetY2)
        }

        updateRenderer()
    }

    private func updateRenderer() {
        renderer.anchor1 = handleAtZeroZero.anchor
        renderer.frame1 = handleAtZeroZero.frame
        renderer.anchor2 = handleAtOneOne.anchor
        renderer.frame2 = handleAtOneOne.frame
    }

    private func computeActualSize() {
        actualW = min(frame.size.width, frame.size.height)
        actualH = actualW
        setup()
        setNeedsDisplay()
    }
}

private protocol HandleViewDelegate: class {
    func handleViewDidMove(_ view: HandleView)
}

private class HandleView: UIView {
    let anchor: CGPoint
    let inverted: Bool
    var fractionalRadius: CGFloat?
    weak var delegate: HandleViewDelegate?

    init(anchor: CGPoint, inverted: Bool, delegate: HandleViewDelegate?) {
        self.anchor = anchor
        self.inverted = inverted
        self.delegate = delegate
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var center: CGPoint {
        didSet { delegate?.handleViewDidMove(self) }
    }

    func setup() {
        backgroundColor = .clear
        let gr = UIPanGestureRecognizer(target: self, action: #selector(handleDrag(gr:)))
        addGestureRecognizer(gr)
    }

    @objc
    func handleDrag(gr: UIPanGestureRecognizer) {
        let offset = gr.translation(in: gr.view?.superview)
        gr.setTranslation(.zero, in: gr.view?.superview)
        switch gr.state {
        case .changed:
            setCenter(for: offset.y)
        default:
            break
        }
    }

    func setCenter(for offsetY: CGFloat) {
        guard let superview = superview else { return }
        guard let fractionalRadius = fractionalRadius else { return }
        let s: CGFloat = (inverted ? -1 : 1)
        var pos = center
        pos.y += offsetY
        let dy = s * (pos.y - anchor.y)
        guard dy <= 0 else { return }
        let svW = superview.bounds.size.width
        let svH = superview.bounds.size.height
        let radius = fractionalRadius * min(svW, svH)
        let rsq = radius * radius
        let dxsq = rsq - dy * dy
        guard dxsq >= 0 else { return }
        let dx = s * sqrt(dxsq)
        pos.x = (anchor.x + dx)
        center = pos
    }
}

private struct Renderer {
    var curveLineWidth: CGFloat = 5
    var curveLineColor: UIColor = .black

    var handleSize: CGFloat = 25
    var handleInteriorColor: UIColor = .lightGray

    var handleLineWidth: CGFloat = 2
    var handleLineColor: UIColor = .white

    var handleBorderWidth: CGFloat = 3
    var handleBorderColor: UIColor = .white

    var anchor1: CGPoint = .zero
    var frame1: CGRect = .zero
    var center1: CGPoint { return center(frame1) }

    var anchor2: CGPoint = .zero
    var frame2: CGRect = .zero
    var center2: CGPoint { return center(frame2) }

    func renderControls() {
        renderControl(anchor: anchor1, frame: frame1)
        renderControl(anchor: anchor2, frame: frame2)
    }

    func renderCurve() {
        curveLineColor.setStroke()
        let path = UIBezierPath()
        path.move(to: anchor1)
        path.addCurve(to: anchor2, controlPoint1: center1, controlPoint2: center2)
        path.lineWidth = curveLineWidth
        path.stroke()
    }

    func renderControl(anchor: CGPoint, frame: CGRect) {
        handleLineColor.setStroke()
        let path = UIBezierPath()
        path.move(to: anchor)
        path.addLine(to: center(frame))
        path.lineWidth = handleLineWidth
        path.stroke()

        handleBorderColor.setFill()
        UIBezierPath(ovalIn: frame).fill()
        handleInteriorColor.setFill()
        let insetRect = frame.insetBy(dx: handleBorderWidth, dy: handleBorderWidth)
        UIBezierPath(ovalIn: insetRect).fill()
    }

    func center(_ frame: CGRect) -> CGPoint {
        var c = frame.origin
        c.x += frame.size.width / 2
        c.y += frame.size.height / 2
        return c
    }
}

private extension CGPoint {
    static func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
        return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
    }
}

