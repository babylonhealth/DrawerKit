import UIKit

// TODO:
// fix dragging crash when trying to drag opposite to motion after that motion was started by a drag
// fix disappearing act by the presenter VC when in the presence of a navigation controller
// fix dragging down and letting go doesn't stop at partial state when partial is enabled
// fix bug found by Sergey (drag down and up a bit then down to dismiss doesn't animate dismissal)
// fix slight navigation bar offset... should work as is because I'm not hardcoding the height but...
// support device rotation
// verify that it works on any device and orientation
// write unit tests

final class DrawerViewController: UIViewController {
    weak var presenterVC: (UIViewController & DrawerPresenting)?
    /* strong */ var contentVC: (UIViewController & DrawerPresentable)?

    var contextView = UIView() // dummy view, replaced by self.view in viewDidLoad
    let nonDrawerView = UIView() // the part of contextView that isn't the drawerView
    let drawerView = UIView()

    let configuration: TransitionConfiguration
    var state = TransitionState()

    var drawerDragGR: UIPanGestureRecognizer?
    var drawerTapGR: UITapGestureRecognizer?
    var nonDrawerTapGR: UITapGestureRecognizer?

    var viewAnimator: ViewAnimator?

    // this is the constraint whose constant is animated to move the drawer up and down
    var drawerYConstraint: NSLayoutConstraint!

    init(presenterVC: (UIViewController & DrawerPresenting),
         contentVC: (UIViewController & DrawerPresentable),
         configuration: TransitionConfiguration = TransitionConfiguration()) {
        self.presenterVC = presenterVC
        self.contentVC = contentVC
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .coverVertical
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DrawerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContextView()
        setupDrawerView()
        setupNonDrawerView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addContentToDrawer()
        setupGestureRecognizers()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeGestureRecognizers()
        removeContentFromDrawer()
        super.viewDidDisappear(animated)
    }
}

extension DrawerViewController {
    func presentDrawer() {
        startNonInteractiveTransitionAlong(direction: .up)
    }

    func dismissDrawer() {
        startNonInteractiveTransitionAlong(direction: .down)
    }
}
