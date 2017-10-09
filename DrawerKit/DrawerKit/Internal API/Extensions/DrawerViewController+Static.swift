import Foundation

extension DrawerViewController {
    static func nextDrawerState(from startState: DrawerState,
                                trigger: TransitionTrigger,
                                _ configuration: TransitionConfiguration,
                                _ geometry: TransitionGeometry) -> DrawerState {
        let curVF = startState.visibleFraction
        guard curVF >= 0 else { return .collapsed }
        guard curVF <= 1 else { return .fullyExpanded }

        let contextH = geometry.contentFrame.height
        let drawerH = geometry.drawerFrame.height
        let contentH = geometry.contentFrame.height
        let dY = geometry.heightOfPartiallyExpandedDrawer
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        let theY = dividerY(dividerOriginY: dY, actualAvailableH: actualAvailableH)
        let peVF = partiallyExpandedVisibleFraction(contextH: contextH,
                                                    drawerH: drawerH,
                                                    contentH: contentH,
                                                    dividerOriginY: theY)
        let allowPartial = configuration.supportsPartialExpansion &&
            theY > 0 && theY < actualAvailableH

        let dismissesInStages = allowPartial && configuration.dismissesInStages

        switch trigger {
        case let .nonInteractive(dir),
             let .drawerDrag(dir):
            switch dir {
            case .up:
                return upwardDrawerState(from: startState, peVF, allowPartial)
            case .down:
                return downwardDrawerState(from: startState, peVF, dismissesInStages)
            }

        case .drawerTap: // drawer taps always finish the current transition
            switch startState.direction {
            case .up:
                return upwardDrawerState(from: startState, peVF, allowPartial)
            case .down:
                return downwardDrawerState(from: startState, peVF, dismissesInStages)
            }

        case .nonDrawerTap: // non-drawer taps always dismiss the drawer
            return downwardDrawerState(from: startState, peVF, dismissesInStages)
        }
    }

    static func drawerYConstant(for visibleFraction: VisibleFraction,
                                _ configuration: TransitionConfiguration,
                                _ geometry: TransitionGeometry) -> CGFloat {
        let contextH = geometry.contextBounds.height
        let drawerH = geometry.drawerFrame.height
        let contentH = geometry.contentFrame.height
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        var result = visibleFraction * actualAvailableH
        result += geometry.navigationBarHeight
        if !configuration.coversStatusBar {
            let statusBarH = geometry.actualStatusBarHeight
            let freeH = actualAvailableH - result
            result -= max(statusBarH - freeH, 0)
        }
        return min(max(result, 0), actualAvailableH)
    }

    static func positionY(for visibleFraction: VisibleFraction,
                          _ geometry: TransitionGeometry) -> CGFloat {
        let contextH = geometry.contextBounds.height
        let drawerH = geometry.drawerFrame.height
        let contentH = geometry.contentFrame.height
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        let result = (1 - visibleFraction) * actualAvailableH
        return min(max(result, 0), actualAvailableH)
    }

    static func visibleFraction(for positionY: CGFloat,
                                _ geometry: TransitionGeometry) -> VisibleFraction {
        let contextH = geometry.contextBounds.height
        let drawerH = geometry.drawerFrame.height
        let contentH = geometry.contentFrame.height
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        let result = (1 - positionY / actualAvailableH)
        return min(max(result, 0), 1)
    }

    static func drawerState(for visibleFraction: VisibleFraction,
                            _ currentDrawerState: DrawerState,
                            _ geometry: TransitionGeometry) -> DrawerState {
        let direction = currentDrawerState.direction
        let contextH = geometry.contextBounds.height
        let drawerH = geometry.drawerFrame.height
        let contentH = geometry.contentFrame.height
        let dividerOriginY = geometry.heightOfPartiallyExpandedDrawer

        let peVF = partiallyExpandedVisibleFraction(
            contextH: contextH, drawerH: drawerH, contentH: contentH,
            dividerOriginY: dividerOriginY
        )

        if visibleFraction <= DrawerState.collapsed.visibleFraction {
            return .collapsed
        } else if visibleFraction >= DrawerState.fullyExpanded.visibleFraction {
            return .fullyExpanded
        } else if abs(visibleFraction - peVF) < 1e-6 {
            return .partiallyExpanded(peVF, direction)
        } else {
            return .transitioning(visibleFraction, direction)
        }
    }
}

private extension DrawerViewController {
    static func upwardDrawerState(from state: DrawerState,
                                  _ partiallyExpandedVF: VisibleFraction,
                                  _ allowPartialExpansion: Bool) -> DrawerState {
        return allowPartialExpansion && state.visibleFraction < partiallyExpandedVF ?
            .partiallyExpanded(partiallyExpandedVF, .up) : .fullyExpanded
    }

    static func downwardDrawerState(from state: DrawerState,
                                    _ partiallyExpandedVF: VisibleFraction,
                                    _ dismissesInStages: Bool) -> DrawerState {
        return dismissesInStages && state.visibleFraction > partiallyExpandedVF ?
            .partiallyExpanded(partiallyExpandedVF, .down) : .collapsed
    }
}

private extension DrawerViewController {
    // dividerOriginY in the coordinate system of the content view
    static func partiallyExpandedVisibleFraction(contextH: CGFloat,
                                                 drawerH: CGFloat,
                                                 contentH: CGFloat,
                                                 dividerOriginY: CGFloat) -> VisibleFraction {
        let partialH = partiallyExpandedHeight(contextH: contextH,
                                               drawerH: drawerH,
                                               contentH: contentH,
                                               dividerOriginY: dividerOriginY)
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        return partialH / actualAvailableH
    }

    // dividerOriginY in the coordinate system of the content view
    static func partiallyExpandedHeight(contextH: CGFloat,
                                        drawerH: CGFloat,
                                        contentH: CGFloat,
                                        dividerOriginY: CGFloat) -> CGFloat {
        let actualAvailableH = actualAvailableHeight(contextH: contextH,
                                                     drawerH: drawerH,
                                                     contentH: contentH)
        return dividerY(dividerOriginY: dividerOriginY,
                        actualAvailableH: actualAvailableH)
    }

    // dividerOriginY in the coordinate system of the content view
    static func dividerY(dividerOriginY: CGFloat, actualAvailableH: CGFloat) -> CGFloat {
        guard actualAvailableH > 0 && dividerOriginY > 0 else { return 0 }
        return min(dividerOriginY, actualAvailableH)
    }

    static func actualAvailableHeight(contextH: CGFloat,
                                      drawerH: CGFloat,
                                      contentH: CGFloat) -> CGFloat {
        guard contextH > 0 else { return 0 }
        let availableH = (drawerH <= 0 ? contextH : min(drawerH, contextH))
        return contentH <= 0 ? availableH : min(contentH, availableH)
    }
}
