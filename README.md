Purpose
--------------

CubeController is a UIViewController subclass that can be used to create a rotating 3D cube navigation. CubeController uses a familiar dataSource protocol pattern for loading its child view controllers, and is simple to set up and use.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 7.0 (Xcode 5.0, Apple LLVM compiler 5.0)
* Earliest supported deployment target - iOS 5.0
* Earliest compatible deployment target - iOS 4.3

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

CubeController requires ARC. If you wish to use CubeController in a non-ARC project, just add the -fobjc-arc compiler flag to the CubeController.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click CubeController.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in CubeController.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including CubeController.m) are checked.


Thread Safety
--------------

CubeController is derived from UIViewController and - as with all UIKit components - it should only be accessed from the main thread.


Installation
--------------

To use the CubeController class in an app, just drag the CubeController class files (demo files and assets are not needed) into your project.


Properties
--------------

CubeController has the following properties:

    @property (nonatomic, weak) id<CubeControllerDataSource> dataSource;

An object that supports the CubeControllerDataSource protocol and can provide view controllers to populate the CubeController.

    @property (nonatomic, weak_delegate) id<CubeControllerDelegate> delegate;

An object that supports the CubeControllerDelegate protocol and can respond to CubeController events.

    @property (nonatomic, readonly) NSInteger numberOfViewControllers;

The number of view controllers displayed in the CubeController (read only). To set this, implement the `numberOfViewControllersInCubeController:` dataSource method. Note that typically only one or at most two of these view controllers will be visible at a given point in time.

    @property (nonatomic, assign) NSInteger currentViewControllerIndex;
    
The index of the currently frontmost view controller. Setting this value is equivalent to calling `scrollToViewControllerAtIndex:animated:` with the animated argument set to NO.

    @property (nonatomic, assign) NSRange preloadedControllerRange;
    
This property is used to set a range of controllers to preload and keep loaded. Normally CubeController loads controllers as needed, an unloads them when they move offscreen. This property allows you to keep a collection of controllers loaded, which can be useful for performance reasons.
    
    @property (nonatomic, getter = isWrapEnabled) BOOL wrapEnabled;
    
This property enables wrapping. If set to YES, the SubeController can be rotated right around in a circle. If set to NO, the controller will stop when scrolled to the first or last index.


Methods
--------------

The CubeController class has the following methods:

    - (void)reloadData;
    
This method reloads all the view controllers in the CubeController.

    - (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;
    
This will rotate the CubeController to the specified view controller index, either immediately or with a smooth animation.


Protocols
---------------

The CubeController follows the Apple convention for data-driven views by providing two protocol interfaces, CubeControllerDataSource and CubeControllerDelegate. The CubeControllerDataSource protocol has the following required methods:

    - (NSInteger)numberOfViewControllersInCubeController:(CubeController *)cubeController;
    
Return the number of view controllers in the CubeController.
    
    - (UIViewController *)cubeController:(CubeController *)cubeController viewControllerAtIndex:(NSInteger)index;

Return a UIViewController to be displayed at the specified index in the CubeController.

The CubeControllerDelegate protocol has the following optional methods:

    - (void)cubeControllerDidScroll:(CubeController *)cubeController;
    
This method is called whenever the CubeController is scrolled. It is called regardless of whether the CubeController was scrolled programatically or through user interaction.
    
    - (void)cubeControllerCurrentViewControllerIndexDidChange:(CubeController *)cubeController;
    
This method is called whenever the CubeController scrolls far enough for the currentViewControllerIndex property to change. It is called regardless of whether the item index was updated programatically or through user interaction.
    
    - (void)cubeControllerWillBeginDragging:(CubeController *)cubeController;
    
This method is called when the CubeController is about to start moving as the result of the user dragging it.
    
    - (void)cubeControllerDidEndDragging:(CubeController *)cubeController willDecelerate:(BOOL)decelerate;
    
This method is called when the user stops dragging the CubeController. The willDecelerate parameter indicates whether the CubeController is travelling fast enough that it needs to decelerate before it stops (i.e. the current index is not necessarily the one it will stop at) or if it will stop where it is. Note that even if willDecelerate is NO, the CubeController will still scroll automatically until it aligns exactly on the current index.
    
    - (void)cubeControllerWillBeginDecelerating:(CubeController *)cubeController;
    
This method is called when the CubeController is about to start decelerating after the user has finished dragging it.
    
    - (void)cubeControllerDidEndDecelerating:(CubeController *)cubeController;
    
This method is called when the CubeController finishes decelerating and you can assume that the currentViewControllerIndex at this point is the final stopping value.

    - (void)cubeControllerDidEndScrollingAnimation:(CubeController *)cubeController;

This method is called when the CubeController finishes moving after being scrolled programmatically using the `scrollToViewControllerAtIndex:` method.