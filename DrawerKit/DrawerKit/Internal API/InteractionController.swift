import UIKit

final class InteractionController: UIPercentDrivenInteractiveTransition {
    private let isPresentation: Bool
    private weak var presentingVC: UIViewController!
    private weak var presentedVC: UIViewController!
    private var presentedViewDragGR: UIPanGestureRecognizer?
    private var containerH: CGFloat = 0

    init(isPresentation: Bool, presentingVC: UIViewController, presentedVC: UIViewController) {
        self.isPresentation = isPresentation
        self.presentingVC = presentingVC
        self.presentedVC = presentedVC
        super.init()
        setupPresentedViewDragRecogniser()
        wantsInteractiveStart = false
    }
}

extension InteractionController {
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        containerH = transitionContext.containerView.bounds.size.height
        super.startInteractiveTransition(transitionContext)
    }
}

private extension InteractionController {
    func setupPresentedViewDragRecogniser() {
        guard presentedViewDragGR == nil else { return }
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handlePresentedViewDrag))
        presentedVC.view.addGestureRecognizer(panGesture)
        presentedViewDragGR = panGesture
    }

    func removePresentedViewDragRecogniser() {
        guard let panGesture = presentedViewDragGR else { return }
        presentedVC.view.removeGestureRecognizer(panGesture)
        presentedViewDragGR = nil
    }

    @objc func handlePresentedViewDrag() {
        guard let panGesture = presentedViewDragGR, let view = panGesture.view else { return }

        switch panGesture.state {
        case .began:
            if isPresentation {
                presentingVC.present(presentedVC, animated: true)
            } else {
                presentedVC.dismiss(animated: true)
            }

        case .changed:
            let offsetY = panGesture.translation(in: view).y
            panGesture.setTranslation(.zero, in: view)
            update(percentComplete + offsetY / containerH)

        case .ended:
            finish()

        case .cancelled:
            cancel()

        default:
            break
        }
    }
}
