import UIKit

extension DrawerViewController {
    func setupGestureRecognizers() {
        setupDrawerDragGestureRecognizer()
        setupNonDrawerTapGestureRecognizer()
    }

    func removeGestureRecognizers() {
        removeDrawerDragGestureRecognizer()
        removeNonDrawerTapGestureRecognizer()
    }
}

private extension DrawerViewController {
    func setupDrawerDragGestureRecognizer() {
        guard isDrawerDraggable && drawerDragGR == nil else { return }
        let gr = UIPanGestureRecognizer()
        gr.maximumNumberOfTouches = 1
        gr.addTarget(self, action: #selector(handleDrawerDrag))
        drawerView.addGestureRecognizer(gr)
        drawerDragGR = gr
    }

    func removeDrawerDragGestureRecognizer() {
        drawerDragGR?.view?.removeGestureRecognizer(drawerDragGR!)
        drawerDragGR = nil
    }

    @objc func handleDrawerDrag() {
        guard isDrawerDraggable, let gr = drawerDragGR else { return }
        switch gr.state {
        case .began:
            handleDrawerDragBegan()
        case .changed:
            handleDrawerDragChanged()
        case .ended:
            handleDrawerDragEnded()
        default:
            break
        }
    }

    func handleDrawerDragBegan() {
        guard let gr = drawerDragGR else { return }
        guard let isDraggingUp = gr.isDraggingUp else { return }
        startDraggingTransition(draggingUp: isDraggingUp)
    }

    func handleDrawerDragChanged() {
        guard let animator = viewAnimator, let gr = drawerDragGR else { return }
        guard let isDraggingUp = gr.isDraggingUp else { return }
        currentDragDirection = (isDraggingUp ? .up : .down)
        var currentVF = animator.visibleFraction
        let geometry = currentGeometry()
        let curPositionY = DrawerViewController.positionY(for: currentVF, geometry)
        let newPositionY = max(curPositionY + gr.verticalOffset, 0)
        currentVF = DrawerViewController.visibleFraction(for: newPositionY, geometry)
        animator.visibleFraction = currentVF
    }

    func handleDrawerDragEnded() {
        let reversing = (currentDragDirection != startDragDirection)
        continueAnimation(reversing: reversing)
    }
}

private extension DrawerViewController {
    func setupNonDrawerTapGestureRecognizer() {
        let isDismissable = isDismissableByOutsideDrawerTaps
        let numberOfTaps = numberOfTapsForOutsideDrawerDismissal
        guard isDismissable && numberOfTaps > 0 && nonDrawerTapGR == nil else { return }
        let gr = UITapGestureRecognizer(target: self, action: #selector(handleNonDrawerTap))
        gr.numberOfTouchesRequired = 1
        gr.numberOfTapsRequired = numberOfTaps
        nonDrawerView.addGestureRecognizer(gr)
        nonDrawerTapGR = gr
    }

    func removeNonDrawerTapGestureRecognizer() {
        nonDrawerTapGR?.view?.removeGestureRecognizer(nonDrawerTapGR!)
        nonDrawerTapGR = nil
    }

    @objc func handleNonDrawerTap() {
        guard isDismissableByOutsideDrawerTaps, let _ = nonDrawerTapGR else { return }
        startNonDrawerTapTransition()
    }
}
