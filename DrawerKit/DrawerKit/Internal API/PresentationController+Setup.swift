import UIKit

extension PresentationController {
    func setupDrawerFullExpansionTapRecogniser() {
        guard drawerFullExpansionTapGR == nil else { return }
        let isFullyPresentable = isFullyPresentableByDrawerTaps
        let numTapsRequired = numberOfTapsForFullDrawerPresentation
        guard isFullyPresentable && numTapsRequired > 0 else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleDrawerFullExpansionTap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = numTapsRequired
        tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        tapGesture.delegate = self
        presentedView?.addGestureRecognizer(tapGesture)
        drawerFullExpansionTapGR = tapGesture
    }

    func removeDrawerFullExpansionTapRecogniser() {
        guard let tapGesture = drawerFullExpansionTapGR else { return }
        presentedView?.removeGestureRecognizer(tapGesture)
        drawerFullExpansionTapGR = nil
    }

    func enableDrawerFullExpansionTapRecogniser(enabled: Bool) {
        drawerFullExpansionTapGR?.isEnabled = enabled
    }
}

extension PresentationController {
    func setupDrawerDismissalTapRecogniser() {
        guard drawerDismissalTapGR == nil else { return }
        let isDismissable = isDismissableByOutsideDrawerTaps
        let numTapsRequired = numberOfTapsForOutsideDrawerDismissal
        guard isDismissable && numTapsRequired > 0 else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDismissalTap))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = numTapsRequired
        tapGesture.cancelsTouchesInView = false
        tapGesture.delaysTouchesBegan = false
        tapGesture.delaysTouchesEnded = false
        tapGesture.delegate = self
        containerView?.addGestureRecognizer(tapGesture)
        drawerDismissalTapGR = tapGesture
    }

    func removeDrawerDismissalTapRecogniser() {
        guard let tapGesture = drawerDismissalTapGR else { return }
        containerView?.removeGestureRecognizer(tapGesture)
        drawerDismissalTapGR = nil
    }

    func enableDrawerDismissalTapRecogniser(enabled: Bool) {
        drawerDismissalTapGR?.isEnabled = enabled
    }
}

extension PresentationController {
    func setupDrawerDragRecogniser() {
        guard drawerDragGR == nil, isDrawerDraggable else { return }
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(handleDrawerDrag))
        presentedView?.addGestureRecognizer(panGesture)
        drawerDragGR = panGesture
    }

    func removeDrawerDragRecogniser() {
        guard let panGesture = drawerDragGR else { return }
        presentedView?.removeGestureRecognizer(panGesture)
        drawerDragGR = nil
    }
}

extension PresentationController {
    func setupDrawerBorder() {
        if let drawerBorderConfig = configuration.drawerBorderConfiguration {
            presentedView?.layer.borderWidth = drawerBorderConfig.borderThickness
            presentedView?.layer.borderColor = drawerBorderConfig.borderColor?.cgColor
        }
    }

    func setupDrawerShadow() {
        if let drawerShadowConfig = configuration.drawerShadowConfiguration {
            presentedView?.layer.shadowColor = drawerShadowConfig.shadowColor?.cgColor
            presentedView?.layer.shadowOpacity = Float(drawerShadowConfig.shadowOpacity)
            presentedView?.layer.shadowRadius = drawerShadowConfig.shadowRadius
            presentedView?.layer.shadowOffset = drawerShadowConfig.shadowOffset
        }
    }
}

extension PresentationController {
    func setupHandleView() {
        guard
            let presentedView = self.presentedView,
            let handleView = self.handleView,
            let handleConfig = configuration.handleViewConfiguration
            else { return }

        handleView.translatesAutoresizingMaskIntoConstraints = false
        handleView.backgroundColor = handleConfig.backgroundColor
        handleView.layer.masksToBounds = true

        switch handleConfig.cornerRadius {
        case .automatic:
            handleView.layer.cornerRadius = handleConfig.size.height / 2
        case let .custom(radius):
            handleView.layer.cornerRadius = radius
        }

        presentedView.addSubview(handleView)

        NSLayoutConstraint.activate([
            handleView.widthAnchor.constraint(equalToConstant: handleConfig.size.width),
            handleView.heightAnchor.constraint(equalToConstant: handleConfig.size.height),
            handleView.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor),
            handleView.topAnchor.constraint(equalTo: presentedView.topAnchor, constant: handleConfig.top)
            ])
    }

    func removeHandleView() {
        self.handleView?.removeFromSuperview()
    }
}

extension PresentationController {
    func setupDebugHeightMarks() {
        guard inDebugMode && (upperMarkGap > 0 || lowerMarkGap > 0),
            let containerView = containerView else { return }

        if upperMarkGap > 0 {
            let upperMarkYView = UIView()
            upperMarkYView.backgroundColor = .black
            upperMarkYView.frame = CGRect(x: 0, y: upperMarkY,
                                          width: containerView.bounds.size.width, height: 3)
            containerView.addSubview(upperMarkYView)
        }

        if lowerMarkGap > 0 {
            let lowerMarkYView = UIView()
            lowerMarkYView.backgroundColor = .black
            lowerMarkYView.frame = CGRect(x: 0, y: lowerMarkY,
                                          width: containerView.bounds.size.width, height: 3)
            containerView.addSubview(lowerMarkYView)
        }

        let drawerMarkView = UIView()
        drawerMarkView.backgroundColor = .white
        drawerMarkView.frame = CGRect(x: 0, y: drawerPartialY,
                                      width: containerView.bounds.size.width, height: 3)
        containerView.addSubview(drawerMarkView)
    }
}
