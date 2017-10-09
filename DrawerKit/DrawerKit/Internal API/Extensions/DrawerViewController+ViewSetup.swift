import UIKit

extension DrawerViewController {
    func setupContextView() {
        contextView = self.view
        contextView.backgroundColor = .clear
    }

    func setupDrawerView() {
        contextView.addSubview(drawerView)
        drawerView.backgroundColor = .clear
    }

    func setupNonDrawerView() {
        contextView.addSubview(nonDrawerView)
        nonDrawerView.backgroundColor = .clear
    }

    func setupConstraints() {
        setupDrawerViewConstraints()
        setupNonDrawerViewConstraints()
        setupSiblingConstraints()
    }
}

extension DrawerViewController {
    func addContentToDrawer() {
        guard let contentVC = self.contentVC else { return }
        if !contentVC.isViewLoaded { contentVC.loadView() }

        guard let contentView = contentVC.view else { return }

        contentVCParentVC = contentVC.parent

        self.addChildViewController(contentVC)
        drawerView.addSubview(contentView)
        contentVC.didMove(toParentViewController: self)

        setupContentViewConstraints(contentView)

        // the remaining constraint for the drawer that needed setting: equal height to the content view
        drawerView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }

    func removeContentFromDrawerAndAddItBackWhereItCameFrom() {
        guard let contentVC = self.contentVC else { return }

        contentVCParentVC?.addChildViewController(contentVC)
        contentVCParentVC?.view.addSubview(contentVC.view)
        contentVC.didMove(toParentViewController: contentVCParentVC)
    }
}

private extension DrawerViewController {
    func setupDrawerViewConstraints() {
        assert(contextView == drawerView.superview)
        drawerView.translatesAutoresizingMaskIntoConstraints = false

        makeLeadingsEqual(contextView, drawerView)
        makeTrailingsEqual(contextView, drawerView)

        // Top constraint: this sets the initial state of the drawer to "collapsed"
        drawerYConstraint = contextView.bottomAnchor.constraint(equalTo: drawerView.topAnchor)
        drawerYConstraint.isActive = true

        // Height constraint: Add a low-priority height constraint to the drawer view in
        // case the content view doesn't have a height constraint of its own. If it does,
        // we don't want to conflict with it, hence the low priority.
        let constraint = drawerView.heightAnchor.constraint(equalTo: contextView.heightAnchor)
        constraint.priority = UILayoutPriority.defaultLow
        constraint.isActive = true
    }

    func setupNonDrawerViewConstraints() {
        assert(contextView == nonDrawerView.superview)
        nonDrawerView.translatesAutoresizingMaskIntoConstraints = false

        makeTopsEqual(contextView, nonDrawerView)
        makeLeadingsEqual(contextView, nonDrawerView)
        makeTrailingsEqual(contextView, nonDrawerView)
    }

    func setupContentViewConstraints(_ contentView: UIView) {
        assert(drawerView == contentView.superview)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        makeTopsEqual(drawerView, contentView)
        makeTrailingsEqual(drawerView, contentView)
        makeBottomsEqual(drawerView, contentView)
        makeLeadingsEqual(drawerView, contentView)
    }

    func setupSiblingConstraints() {
        nonDrawerView.bottomAnchor.constraint(equalTo: drawerView.topAnchor).isActive = true
    }
}
