# DrawerKit

## v. 0.3.0

Release 0.3.0 breaks backward compatibility with the earlier releases. Specific changes and new features are as follows:

- Concurrent animations: it's now possible for either or both view controllers (presenting and presented) to participate in the drawer animation so that their views can be animated while the drawer is moving up and down.

- Automatic display of a "handle view": it's now possible to have the drawer add a "gray bar" near its top. This bar, referred to as the "handle view", can be customised in its size, background color, and corner radius, and can be automatically dimmed as the drawer moves towards its collapsed or fully-expanded states. Or you can turn that off and throw your own.

- Support for not expanding to cover the entire screen. It's now possible to select the behaviour of the drawer when it fully-expands itself. You may choose from covering the entire screen (the default), not covering the status bar, and leaving a gap at the top, of any desired size.

- Partial transitions (collapsed to partially-expanded and partially-expanded to fully-expanded, and vice-versa) can now have durations that are equal to, or fractions of, the duration for a full-size transition (collapsed to fully-expanded, and vice-versa). This allows for transitions to have the same speed, if desired.

## v. 0.2.0

Release 0.2.0 breaks backward compatibility with the earlier release, since one of the protocols has disappeared and a new one has been added. Specific changes and new features are as follows:

- The presenting view controller is no longer required to conform to `DrawerPresenting`. In fact, `DrawerPresenting` no longer exists. Instead, a new protocol was created to take its place, `DrawerCoordinating`, so that *any* object can conform to it and be responsible for vending the drawer display controller. Of course, the presenting view controller can still fulfil that responsibility but it no longer must do so.

- Added **tap-to-expand**. Now, if the corresponding configuration boolean is turned on, tapping on the drawer when it's in its partially expanded state will trigger it to transition to its fully expanded state.

- Added some under-the-hood improvements in preparation for adding upcoming new features.

## v. 0.1.1

- Initial release
