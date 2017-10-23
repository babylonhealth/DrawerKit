import UIKit

final class InteractionController: UIPercentDrivenInteractiveTransition {
    private let isPresentation: Bool
    private weak var presentingVC: UIViewController!
    private weak var presentedVC: UIViewController!
    private var drawerDragGR: UIPanGestureRecognizer?
    private var containerH: CGFloat = 0

    init(isPresentation: Bool, presentingVC: UIViewController, presentedVC: UIViewController) {
        self.isPresentation = isPresentation
        self.presentingVC = presentingVC
        self.presentedVC = presentedVC
        super.init()
        setupDrawerDragRecogniser()
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
    func setupDrawerDragRecogniser() {
        guard drawerDragGR == nil else { return }
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDrag))
        presentedVC.view.addGestureRecognizer(panGesture)
        drawerDragGR = panGesture
    }

    func removeDrawerDragRecogniser() {
        guard let panGesture = drawerDragGR else { return }
        presentedVC.view.removeGestureRecognizer(panGesture)
        drawerDragGR = nil
    }

    @objc func handleDrawerDrag() {
        guard
            let panGesture = drawerDragGR,
            let view = panGesture.view
            else { return }

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
