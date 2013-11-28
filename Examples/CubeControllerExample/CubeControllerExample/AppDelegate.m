//
//  AppDelegate.m
//  CubeControllerExample
//
//  Created by Nick Lockwood on 04/11/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "AppDelegate.h"
#import "CubeController.h"
#import "RedViewController.h"
#import "GreenViewController.h"
#import "BlueViewController.h"


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
    switch (index)
    {
        case 0:
            return [[RedViewController alloc] init];
        case 1:
            return [[GreenViewController alloc] init];
        case 2:
            return [[BlueViewController alloc] init];
    }
    return nil;
}

@end
