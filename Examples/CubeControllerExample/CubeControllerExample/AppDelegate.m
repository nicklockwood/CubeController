//
//  AppDelegate.m
//  CubeControllerExample
//
//  Created by Nick Lockwood on 04/11/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "AppDelegate.h"
#import "CubeController.h"
#import "ViewController.h"


@interface AppDelegate () <CubeControllerDataSource>

@end


@implementation AppDelegate

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CubeController *controller = [[CubeController alloc] init];
    controller.dataSource = self;
    controller.wrapEnabled = YES;
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];

    return YES;
}

- (NSInteger)numberOfViewControllersInCubeController:(__unused CubeController *)cubeController
{
    return 3;
}

- (UIViewController *)cubeController:(__unused CubeController *)cubeController viewControllerAtIndex:(NSInteger)index
{
    switch (index % 3)
    {
        case 0:
        {
            return [[ViewController alloc] initWithNibName:@"RedViewController" bundle:nil];
        }
        case 1:
        {
            return [[ViewController alloc] initWithNibName:@"GreenViewController" bundle:nil];
        }
        case 2:
        {
            return [[ViewController alloc] initWithNibName:@"BlueViewController" bundle:nil];
        }
    }
    return nil;
}

@end
