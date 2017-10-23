# DrawerKit

## v. 0.2.0

Release 0.2.0 breaks backward compatibility with the earlier release, since one of the protocols has disappeared and a new one has been added. Specific changes and new features are as follows:

- The presenting view controller is no longer required to conform to `DrawerPresenting`. In fact, `DrawerPresenting` no longer exists. Instead, a new protocol was created to take its place, `DrawerCoordinating`, so that *any* object can conform to it and be responsible for vending the drawer display controller. Of course, the presenting view controller can still fulfil that responsibility but it no longer must do so.

- Added **tap-to-expand**. Now, if the corresponding configuration boolean is turned on, tapping on the drawer when it's in its partially expanded state will trigger it to transition to its fully expanded state.

## v. 0.1.1

- Initial release
