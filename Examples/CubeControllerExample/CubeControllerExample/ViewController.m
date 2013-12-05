//
//  RedViewController.m
//  CubeControllerExample
//
//  Created by Nick Lockwood on 04/11/2013.
//  Copyright (c) 2013 Charcoal Design. All rights reserved.
//

#import "ViewController.h"
#import "CubeController.h"


@implementation ViewController

- (IBAction)goForward
{
    [self.cubeController scrollForwardAnimated:YES];
}

- (IBAction)goBack
{
    [self.cubeController scrollBackAnimated:YES];
}

@end
