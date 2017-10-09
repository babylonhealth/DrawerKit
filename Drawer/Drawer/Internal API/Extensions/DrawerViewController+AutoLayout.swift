import UIKit

extension DrawerViewController {
    // Priorities aren't set to required to avoid any conflicts with potentially
    // pre-existing constraints.

    func makeTopsEqual(_ view1: UIView, _ view2: UIView) {
        let constraint = view1.topAnchor.constraint(equalTo: view2.topAnchor)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }

    func makeBottomsEqual(_ view1: UIView, _ view2: UIView) {
        let constraint = view1.bottomAnchor.constraint(equalTo: view2.bottomAnchor)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }

    func makeLeadingsEqual(_ view1: UIView, _ view2: UIView) {
        let constraint = view1.leadingAnchor.constraint(equalTo: view2.leadingAnchor)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }

    func makeTrailingsEqual(_ view1: UIView, _ view2: UIView) {
        let constraint = view1.trailingAnchor.constraint(equalTo: view2.trailingAnchor)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }
}
