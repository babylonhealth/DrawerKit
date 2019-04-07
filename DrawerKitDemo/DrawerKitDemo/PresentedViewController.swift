import UIKit
import DrawerKit

class PresentedViewController: UIViewController {
    private var notificationTokens: [NotificationToken] = []

    @IBOutlet weak var presentedView: PresentedView!
    @IBAction func dismissButtonTapped() {
        drawerPresentationController?.setDrawerState(.dismissed)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationTokens = [
            NotificationCenter.default
                .addObserver(DrawerNotifications.TransitionWillStart.self) { notification in
                    print("transitionWillStart, isPresenting = \(notification.info.isPresenting)")
                },
            NotificationCenter.default
                .addObserver(DrawerNotifications.TransitionDidFinish.self) { notification in
                    print("transitionDidFinish, isPresenting = \(notification.info.isPresenting)")
                },
            NotificationCenter.default
                .addObserver(DrawerNotifications.DrawerInteriorTapped.self) { notification in
                    print("drawerInteriorTapped")
                },
            NotificationCenter.default
                .addObserver(DrawerNotifications.DrawerExteriorTapped.self) { notification in
                    print("drawerExteriorTapped")
                }
        ]
        self.notificationTokens.append(contentsOf: notificationTokens)
    }

    @IBAction func unwindFromModal(with segue: UIStoryboardSegue) {}
}

extension PresentedViewController: UIScrollViewDelegate {}

extension PresentedViewController: DrawerPresentable {

//    var heightOfCollapsedDrawer: CGFloat {
//        return 100
//    }

    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }

        if #available(iOS 11, *) {
            return view.dividerView.frame.origin.y + view.adjustedContentInset.top
        } else {
            return view.dividerView.frame.origin.y + topLayoutGuide.length
        }
    }
}

extension PresentedViewController: DrawerAnimationParticipant {
    public var drawerAnimationActions: DrawerAnimationActions {
        let prepareAction: DrawerAnimationActions.PrepareHandler = {
            [weak self] info in
            switch (info.startDrawerState, info.endDrawerState) {
            case (.dismissed, .partiallyExpanded):
                self?.presentedView.prepareCollapsedToPartiallyExpanded()
            case (.partiallyExpanded, .dismissed):
                self?.presentedView.preparePartiallyExpandedToCollapsed()
            case (.dismissed, .fullyExpanded):
                self?.presentedView.prepareCollapsedToFullyExpanded()
            case (.fullyExpanded, .dismissed):
                self?.presentedView.prepareFullyExpandedToCollapsed()
            case (.partiallyExpanded, .fullyExpanded):
                self?.presentedView.preparePartiallyExpandedToFullyExpanded()
            case (.fullyExpanded, .partiallyExpanded):
                self?.presentedView.prepareFullyExpandedToPartiallyExpanded()
            default:
                break
            }
        }

        let animateAlongAction: DrawerAnimationActions.AnimateAlongHandler = {
            [weak self] info in
            switch (info.startDrawerState, info.endDrawerState) {
            case (.dismissed, .partiallyExpanded):
                self?.presentedView.animateAlongCollapsedToPartiallyExpanded()
            case (.partiallyExpanded, .dismissed):
                self?.presentedView.animateAlongPartiallyExpandedToCollapsed()
            case (.dismissed, .fullyExpanded):
                self?.presentedView.animateAlongCollapsedToFullyExpanded()
            case (.fullyExpanded, .dismissed):
                self?.presentedView.animateAlongFullyExpandedToCollapsed()
            case (.partiallyExpanded, .fullyExpanded):
                self?.presentedView.animateAlongPartiallyExpandedToFullyExpanded()
            case (.fullyExpanded, .partiallyExpanded):
                self?.presentedView.animateAlongFullyExpandedToPartiallyExpanded()
            default:
                break
            }
        }

        let cleanupAction: DrawerAnimationActions.CleanupHandler = {
            [weak self] info in
            switch (info.startDrawerState, info.endDrawerState) {
            case (.dismissed, .partiallyExpanded):
                self?.presentedView.cleanupCollapsedToPartiallyExpanded()
            case (.partiallyExpanded, .dismissed):
                self?.presentedView.cleanupPartiallyExpandedToCollapsed()
            case (.dismissed, .fullyExpanded):
                self?.presentedView.cleanupCollapsedToFullyExpanded()
            case (.fullyExpanded, .dismissed):
                self?.presentedView.cleanupFullyExpandedToCollapsed()
            case (.partiallyExpanded, .fullyExpanded):
                self?.presentedView.cleanupPartiallyExpandedToFullyExpanded()
            case (.fullyExpanded, .partiallyExpanded):
                self?.presentedView.cleanupFullyExpandedToPartiallyExpanded()
            default:
                break
            }
        }

        return DrawerAnimationActions(prepare: prepareAction,
                                      animateAlong: animateAlongAction,
                                      cleanup: cleanupAction)
    }
}
