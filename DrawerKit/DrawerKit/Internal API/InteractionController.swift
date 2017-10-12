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
        let gr = UIPanGestureRecognizer(target: self,
                                        action: #selector(handlePresentedViewDrag))
        presentedVC.view.addGestureRecognizer(gr)
        presentedViewDragGR = gr
    }

    func removePresentedViewDragRecogniser() {
        guard let gr = presentedViewDragGR else { return }
        presentedVC.view.removeGestureRecognizer(gr)
        presentedViewDragGR = nil
    }

    @objc func handlePresentedViewDrag() {
        guard let gr = presentedViewDragGR, let view = gr.view else { return }

        switch gr.state {
        case .began:
            if isPresentation {
                presentingVC.present(presentedVC, animated: true)
            } else {
                presentedVC.dismiss(animated: true)
            }

        case .changed:
            let offsetY = gr.translation(in: view).y
            gr.setTranslation(.zero, in: view)
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
