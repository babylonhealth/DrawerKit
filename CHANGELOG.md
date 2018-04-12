# DrawerKit

## v. 0.6.0

- DrawerKit now supports pull-to-dismiss driven by a `UIScrollView` inside the drawer content. (#58)

  You may specify the `UIScrollView` to DrawerKit through its presentation controller:
  ```swift
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Install `tableView` as the pull-to-dismiss participant.
    drawerPresentationController?.scrollViewForPullToDismiss = tableView
  }
  ```

- Drawer corners may now be configured in `DrawerConfiguration` to be always visible below the status bar. (#61)

## v. 0.5.0

- DrawerKit now supports `overCurrentContext` and `overFullScreen` modal presentations over the drawer. (#56)

- Fixed the issue of touches on the drawer being cancelled by the DrawerKit internal gesture recognizers. (#57)

- `UIControl`s within the drawer are now interactive when the drawer is partially expanded. (#57)

## v. 0.4.1

- Reverses the fix for the [issue](https://github.com/Babylonpartners/DrawerKit/issues/31) about safe areas. The fix broke other things and the issue will need to be re-opened.
- Changes the minimum deployment target to 10.2.

## v. 0.4.0

- Drawers can now have borders and shadows, all configurable.
- Fixed a bug by which dragging the drawer all the way to the top would not execute the animation completion block.
- Fixed a reported [issue](https://github.com/Babylonpartners/DrawerKit/issues/31) by which safe area insets were misbehaving.
- Removed the configuration parameter `hasHandleView` since it can be inferred from the value of `handleViewConfiguration`, which is now an optional.
- Fixed incorrect spelling in an enumeration case (`DrawerConfiguration.FullExpansionBehaviour.doesNotCoverStatusBar`)

## v. 0.3.4

- Adds a new configuration parameter for the handle view, namely, its vertical position with respect to the presented view's frame.

## v. 0.3.3

- Fixes an issue where the presented view controller's view might not be laid out properly by the time the drawer's height is requested from it.

## v. 0.3.2

- Fixes an issue with typed notifications.

## v. 0.3.1

- Better support for concurrent animations: in previous versions, the actual presenting view controller wasn't necessarily what you'd think is the presenting view controller, which caused problems when trying to animate its view concurrently with the drawer animation. Now, although it's still the case that the presenting view controller may not be the view controller you think it is, the view controller that you think is the presenting view controller and which you add conformance to `DrawerAnimationParticipant` is the view controller whose animation closures get invoked.

- Notifications: it's now possible to subscribe to notifications indicating when the drawer is tapped (both in its interior and in its exterior), when drawer transitions are about to start, and when they're completed.

## v. 0.3.0

Release 0.3.0 breaks backwards compatibility with the earlier releases. Specific changes and new features are as follows:

- Concurrent animations: it's now possible for either or both view controllers (presenting and presented) to participate in the drawer animation so that their views can be animated while the drawer is moving up and down.

- Automatic display of a "handle view": it's now possible to have the drawer add a "gray bar" near its top. This bar, referred to as the "handle view", can be customised in its size, background color, and corner radius, and can be automatically dimmed as the drawer moves towards its collapsed or fully-expanded states. Or you can turn that off and throw your own.

- Support for not expanding to cover the entire screen. It's now possible to select the behaviour of the drawer when it fully-expands itself. You may choose from covering the entire screen (the default), not covering the status bar, and leaving a gap at the top, of any desired size.

- Partial transitions (collapsed to partially-expanded and partially-expanded to fully-expanded, and vice-versa) can now have durations that are equal to, or fractions of, the duration for a full-size transition (collapsed to fully-expanded, and vice-versa). This allows for transitions to have the same speed, if desired.

## v. 0.2.0

Release 0.2.0 breaks backwards compatibility with the earlier release, since one of the protocols has disappeared and a new one has been added. Specific changes and new features are as follows:

- The presenting view controller is no longer required to conform to `DrawerPresenting`. In fact, `DrawerPresenting` no longer exists. Instead, a new protocol was created to take its place, `DrawerCoordinating`, so that *any* object can conform to it and be responsible for vending the drawer display controller. Of course, the presenting view controller can still fulfil that responsibility but it no longer must do so.

- Added **tap-to-expand**. Now, if the corresponding configuration boolean is turned on, tapping on the drawer when it's in its partially expanded state will trigger it to transition to its fully expanded state.

- Added some under-the-hood improvements in preparation for adding upcoming new features.

## v. 0.1.1

- Initial release
