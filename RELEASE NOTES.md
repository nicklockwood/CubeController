Version 1.2

- Improved scrollToViewControllerAtIndex:animated: method behaviour
- Improved handling of screen rotation
- removed preloadedControllerRange feature (if you wish to keep controllers loaded, just store them in an array)
- Added reloadViewControllerAtIndex:animated method for reloading individual controllers
- Added scrollForwardAnimated: and scrollBackAnimated: methods
- Added cubeController property to UIViewController for convenient access to containing CubeController
- Exposed scrollView property (readonly)

Version 1.1

- Added wrapEnabled property to allow for circular navigation
- Controllers are now loaded dynamically as needed instead of all in advance
- Added preloadedControllerRange to preload controllers when needed
- Now compliant with -Weverything warning level

Version 1.0.1

- Fixed issue where rear-facing controller could interfere with touches on the frontmost one

Version 1.0

- First release