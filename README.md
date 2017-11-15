# DrawerKit

[![circleci](https://circleci.com/gh/Babylonpartners/DrawerKit/tree/master.svg?style=svg)](https://circleci.com)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/DrawerKit.svg?style=flat)](http://cocoapods.org/pods/DrawerKit)
[![Platform](https://img.shields.io/cocoapods/p/DrawerKit.svg?style=flat)](http://cocoapods.org/pods/DrawerKit)
[![Swift 4.0.x](https://img.shields.io/badge/Swift-4.0.x-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-9.x-blue.svg)](https://developer.apple.com/xcode)
[![License](https://img.shields.io/cocoapods/l/DrawerKit.svg?style=flat)](http://cocoapods.org/pods/DrawerKit)

## What is DrawerKit?
__DrawerKit__ is a custom view controller presentation mimicking the kind of behaviour you see in the Apple Maps app.
It lets any view controller modally present another arbitrary view controller in such a way that the presented content
is only partially shown at first, then allowing the user to interact with it by showing more or less of that content
until it's fully presented or fully dismissed. It's *not* (yet) a complete implementation of the behaviour you see in
the Maps app simply because our specific needs dictated something else. We intend to continue working on it to address
that limitation.

Please do play with the demo app and try different configuration options because there are so many ways to configure
`DrawerKit` that the gif below is at most a pathetic representation of everything that the library can do.

<p align="center">
	<table>
		<tr>
			<td>
				<a href="https://github.com/Babylonpartners/DrawerKit/">
					<img src="drawers2.gif" alt="DrawerKit" width="288" height="514" />
				</a>
			</td>
			<td>
				<a href="https://github.com/Babylonpartners/DrawerKit/">
					<img src="drawers3.gif" alt="DrawerKit" width="288" height="514" />
				</a>
			</td>
		</tr>
	</table>
</p>

## What's new in version 0.3.4?

- Adds a new configuration parameter for the handle view, namely, its vertical position with
respect to the presented view's frame.

## What's new in version 0.3.3?

- Better support for concurrent animations: in previous versions, the actual presenting view
controller wasn't necessarily what you'd think is the presenting view controller, which caused
problems when trying to animate its view concurrently with the drawer animation. Now, although
it's still the case that the presenting view controller may not be the view controller you think
it is, the view controller that you think is the presenting view controller and which you add
conformance to `DrawerAnimationParticipant` is the view controller whose animation closures get invoked.

- Notifications: it's now possible to subscribe to notifications indicating when the drawer is
tapped (both in its interior and in its exterior), when drawer transitions are about to start,
and when they're completed.

- A couple of small but important bug fixes.

## What's new in version 0.3.0?

Please note that v. `0.3.0` is not backwards-compatible with v. 0.2.

- *Concurrent animations*: it's now possible for either or both view controllers (presenting and
presented) to participate in the drawer animation so that their views can be animated while the
drawer is moving up and down.

- *Automatic display of a "handle view"*: it's now possible to have the drawer add a "gray bar" near
its top. This bar, referred to as the "handle view", can be customised in its size, background color,
and corner radius, and can be automatically dimmed as the drawer moves towards its collapsed or
fully-expanded states. Or you can turn that off and throw your own.

- *Support for not expanding to cover the entire screen*. It's now possible to select the behaviour of
the drawer when it fully-expands itself. You may choose from covering the entire screen (the default),
not covering the status bar, and leaving a gap at the top, of any desired size.

- Partial transitions (collapsed to partially-expanded and partially-expanded to fully-expanded, and
vice-versa) can now have durations that are equal to, or fractions of, the duration for a full-size
transition (collapsed to fully-expanded, and vice-versa). This allows for transitions to have the same
speed, if desired.

## What's new in version 0.2.0?

Please note that v. `0.2.0` is not backwards-compatible with v. 0.1.1.

- The presenting view controller is no longer required to conform to `DrawerPresenting`. In fact,
`DrawerPresenting` no longer exists. Instead, a new protocol was created to take its place,
`DrawerCoordinating`, so that *any* object can conform to it and be responsible for vending the
drawer display controller. Of course, the presenting view controller can still fulfil that
responsibility but it no longer must do so.

- Added **tap-to-expand**. Now, if the corresponding configuration boolean is turned on, tapping
on the drawer when it's in its partially expanded state will trigger it to transition to its
fully expanded state.

- Added some under-the-hood improvements in preparation for adding upcoming new features.

## What version of iOS does it require or support?

__DrawerKit__ is compatible with iOS 10 and above.

## How to use it?

In order for the _presenting_ view controller to present another view controller (the _presented_ view controller)
as a drawer, some object needs to conform to the `DrawerCoordinating` protocol and the _presented_ view controller
needs to conform to the `DrawerPresentable` protocol. The _presenting_ view controller _may_ be the object conforming
to `DrawerCoordinating` but it need not be.

```swift
public protocol DrawerCoordinating: class {
    /// An object vended by the conforming object, whose responsibility is to control
    /// the presentation, animation, and interactivity of/with the drawer.
    var drawerDisplayController: DrawerDisplayController? { get }
}

public protocol DrawerPresentable: class {
    /// The height at which the drawer must be presented when it's in its
    /// partially expanded state. If negative, its value is clamped to zero.
    var heightOfPartiallyExpandedDrawer: CGFloat { get }
}
```

After that, it's essentially business as usual in regards to presenting a view controller modally. Here's the basic
code to get a view controller to present another as a drawer, where the presenting view controller itself conforms to
`DrawerCoordinating`,

```swift
extension PresenterViewController {
    func doModalPresentation() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "presented")
            as? PresentedViewController else { return }

        // you can provide the configuration values in the initialiser...
        var configuration = DrawerConfiguration(/* ..., ..., ..., */)

        // ... or after initialisation. All of these have default values so change only
        // what you need to configure differently. They're all listed here just so you
        // can see what can be configured. The values listed are the default ones,
        // except where indicated otherwise.
        configuration.totalDurationInSeconds = 3 // default is 0.4
        configuration.durationIsProportionalToDistanceTraveled = false
        // default is UISpringTimingParameters()
        configuration.timingCurveProvider = UISpringTimingParameters(dampingRatio: 0.8)
        configuration.fullExpansionBehaviour = .leavesCustomGap(gap: 100) // default is .coversFullScreen
        configuration.supportsPartialExpansion = true
        configuration.dismissesInStages = true
        configuration.isDrawerDraggable = true
        configuration.isFullyPresentableByDrawerTaps = true
        configuration.numberOfTapsForFullDrawerPresentation = 1
        configuration.isDismissableByOutsideDrawerTaps = true
        configuration.numberOfTapsForOutsideDrawerDismissal = 1
        configuration.flickSpeedThreshold = 3
        configuration.upperMarkGap = 100 // default is 40
        configuration.lowerMarkGap =  80 // default is 40
        configuration.maximumCornerRadius = 15
        configuration.hasHandleView = true
        var handleViewConfiguration = HandleViewConfiguration()
        handleViewConfiguration.autoAnimatesDimming = true
        handleViewConfiguration.backgroundColor = .gray
        handleViewConfiguration.size = CGSize(width: 40, height: 6)
        handleViewConfiguration.cornerRadius = .automatic
        configuration.handleViewConfiguration = handleViewConfiguration

        drawerDisplayController = DrawerDisplayController(presentingViewController: self,
                                                          presentedViewController: vc,
                                                          configuration: configuration,
                                                          inDebugMode: true)

        present(vc, animated: true)
    }
}
```

and here's one way to implement the corresponding presented view controller:

```swift
extension PresentedViewController: DrawerPresentable {
    var heightOfPartiallyExpandedDrawer: CGFloat {
        guard let view = self.view as? PresentedView else { return 0 }
        return view.dividerView.frame.origin.y
    }
}
```

Naturally, the presented view controller can dismiss itself at any time, following the usual approach:

```swift
extension PresentedViewController {
    @IBAction func dismissButtonTapped() {
        dismiss(animated: true)
    }
}
```

## How configurable is it?

__DrawerKit__ has a number of configurable properties, conveniently collected together into a struct,
`DrawerConfiguration`. Here's a list of all the currently supported configuration options:

```swift
    /// The total duration, in seconds, for the drawer to transition from its
    /// collapsed state to its fully-expanded state, or vice-versa. The default
    /// value is 0.4 seconds.
    public var totalDurationInSeconds: TimeInterval

    /// When the drawer transitions between its collapsed and partially-expanded
    /// states, or between its partially-expanded and its fully-expanded states, in
    /// either direction, the distance traveled by the drawer is some fraction of
    /// the total distance traveled between the collapsed and fully-expanded states.
    /// You have a choice between having those fractional transitions take the same
    /// amount of time as the full transition, and having them take a time that is
    /// a fraction of the total time, where the fraction used is the fraction of
    /// space those partial transitions travel. In the first case, all transitions
    /// have the same duration (`totalDurationInSeconds`) but different speeds, while
    /// in the second case different transitions have different durations but the same
    /// speed. The default is `false`, that is, all transitions last the same amount
    /// of time.
    public var durationIsProportionalToDistanceTraveled: Bool

    /// The type of timing curve to use for the animations. The full set of cubic
    /// Bezier curves and spring-based curves is supported. Note that selecting a
    /// spring-based timing curve may cause the `totalDurationInSeconds` parameter
    /// to be ignored because the duration, for a fully general spring-based timing
    /// curve provider, is computed based on the specifics of the spring-based curve.
    /// The default is `UISpringTimingParameters()`, which is the system's global
    /// spring-based timing curve.
    public var timingCurveProvider: UITimingCurveProvider

    /// Whether the drawer expands to cover the entire screen, the entire screen minus
    /// the status bar, or the entire screen minus a custom gap. The default is to cover
    /// the full screen.
    public var fullExpansionBehaviour: FullExpansionBehaviour

    /// When `true`, the drawer is presented first in its partially expanded state.
    /// When `false`, the presentation is always to full screen and there is no
    /// partially expanded state. The default value is `true`.
    public var supportsPartialExpansion: Bool

    /// When `true`, dismissing the drawer from its fully expanded state can result
    /// in the drawer stopping at its partially expanded state. When `false`, the
    /// dismissal is always straight to the collapsed state. Note that
    /// `supportsPartialExpansion` being `false` implies `dismissesInStages` being
    /// `false` as well but you can have `supportsPartialExpansion == true` and
    /// `dismissesInStages == false`, which would result in presentations to the
    /// partially expanded state but all dismissals would be straight to the collapsed
    /// state. The default value is `true`.
    public var dismissesInStages: Bool

    /// Whether or not the drawer can be dragged up and down. The default value is `true`.
    public var isDrawerDraggable: Bool

    /// Whether or not the drawer can be fully presentable by tapping on it.
    /// The default value is `true`.
    public var isFullyPresentableByDrawerTaps: Bool

    /// How many taps are required for fully presenting the drawer by tapping on it.
    /// The default value is 1.
    public var numberOfTapsForFullDrawerPresentation: Int

    /// Whether or not the drawer can be dismissed by tapping anywhere outside of it.
    /// The default value is `true`.
    public var isDismissableByOutsideDrawerTaps: Bool

    /// How many taps are required for dismissing the drawer by tapping outside of it.
    /// The default value is 1.
    public var numberOfTapsForOutsideDrawerDismissal: Int

    /// How fast one needs to "flick" the drawer up or down to make it ignore the
    /// partially expanded state. Flicking fast enough up always presents to full screen
    /// and flicking fast enough down always collapses the drawer. A typically good value
    /// is around 3 points per screen height per second, and that is also the default
    /// value of this property.
    public var flickSpeedThreshold: CGFloat

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *above* the partially
    /// expanded position. The default value is 40 points.
    public var upperMarkGap: CGFloat

    /// There is a band around the partially expanded position of the drawer where
    /// ending a drag inside will cause the drawer to move back to the partially
    /// expanded position (subjected to the conditions set by `supportsPartialExpansion`
    /// and `dismissesInStages`, of course). Set `inDebugMode` to `true` to see lines
    /// drawn at those positions. This value represents the gap *below* the partially
    /// expanded position. The default value is 40 points.
    public var lowerMarkGap: CGFloat

    /// The animating drawer also animates the radius of its top left and top right
    /// corners, from 0 to the value of this property. Setting this to 0 prevents any
    /// corner animations from taking place. The default value is 15 points.
    public var maximumCornerRadius: CGFloat

    /// Whether or not to automatically add a handle view to the presented content.
    /// The default is `true`.
    public var hasHandleView: Bool

    /// The configuration options for the handle view, should it be shown.
    public var handleViewConfiguration: HandleViewConfiguration
```

```swift
    public enum FullExpansionBehaviour: Equatable {
        case coversFullScreen
        case dosNotCoverStatusBar
        case leavesCustomGap(gap: CGFloat)
    }
```

```swift
public struct HandleViewConfiguration {
    /// Whether or not to automatically dim the handle view as the drawer approaches
    /// its collapsed or fully expanded states. The default is `true`. Set it to `false`
    /// when configuring the drawer not to cover the full screen so that the handle view
    /// is always visible in that case.
    public var autoAnimatesDimming: Bool

    /// The handle view's background color. The default value is `UIColor.gray`.
    public var backgroundColor: UIColor

    /// The handle view's bounding rectangle's size. The default value is
    /// `CGSize(width: 40, height: 6)`.
    public var size: CGSize

    /// The handle view's corner radius. The default is `CornerRadius.automatic`, which
    /// results in a corner radius equal to half the handle view's height.
    public var cornerRadius: CornerRadius
}
```

## What's the actual drawer behaviour logic?

The behaviour of how and under what situations the drawer gets fully presented, partially presented, or
collapsed (dismissed) is summarised by the pseudo-code below:

```swift
    if isMovingUpQuickly { show fully expanded }
    if isMovingDownQuickly { collapse all the way (ie, dismiss) }

    if isAboveUpperMark {
        if isMovingUp || isNotMoving {
            show fully expanded
        } else { // is moving down
            collapse to the partially expanded state or all the way (ie, dismiss),
            depending on the values of `supportsPartialExpansion` and `dismissesInStages`
        }
    }

    if isAboveLowerMark { // ie, in the band surrounding the partially expanded state
        if isMovingDown {
            collapse all the way (ie, dismiss)
        } else { // not moving or moving up
            expand to the partially expanded state or all the way (ie, full-screen),
            depending on the value of `supportsPartialExpansion`
        }
    }

    // below the band surrounding the partially expanded state
    collapse all the way (ie, dismiss)
```

#### Carthage

If you use [Carthage][] to manage your dependencies, simply add
DrawerKit to your `Cartfile`:

```
github "Babylonpartners/DrawerKit" ~> 1.0
```

If you use Carthage to build your dependencies, make sure you have added `DrawerKit.framework`
to the "_Linked Frameworks and Libraries_" section of your target, and have included them in
your Carthage framework copying build phase.

#### CocoaPods

If you use [CocoaPods][] to manage your dependencies, simply add DrawerKit to your `Podfile`:

```
pod 'DrawerKit', '~> 1.0'
```

[CocoaPods]: https://cocoapods.org/
[Carthage]: https://github.com/Carthage/Carthage
