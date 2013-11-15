//
//  CubeController.m
//
//  Version 1.0.1
//
//  Created by Nick Lockwood on 30/06/2013.
//  Copyright (c) 2013 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/CubeController
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import "CubeController.h"
#import <QuartzCore/QuartzCore.h>


@implementation NSObject (CubeControllerDelegate)

- (void)cubeControllerDidScroll:(__unused CubeController *)cc {}
- (void)cubeControllerCurrentViewControllerIndexDidChange:(__unused CubeController *)cc {}
- (void)cubeControllerWillBeginDragging:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndDragging:(__unused CubeController *)cc willDecelerate:(__unused BOOL)dc {}
- (void)cubeControllerWillBeginDecelerating:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndDecelerating:(__unused CubeController *)cc {}
- (void)cubeControllerDidEndScrollingAnimation:(__unused CubeController *)cc {}

@end


@interface CubeController () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger numberOfViewControllers;
@property (nonatomic, assign) NSInteger previousViewControllerIndex;

@end


@implementation CubeController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.autoresizesSubviews = NO;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _controllers = [NSMutableArray array];
    _numberOfViewControllers = [self.dataSource numberOfViewControllersInCubeController:self];
    for (int i = 0; i < _numberOfViewControllers; i++)
    {
        UIViewController *controller = [self.dataSource cubeController:self viewControllerAtIndex:i];
        [_controllers addObject:controller];
        [self addChildViewController:controller];
        controller.view.frame = self.view.bounds;
        controller.view.layer.doubleSided = NO;
        controller.view.userInteractionEnabled = (i == _currentViewControllerIndex);
        [_scrollView insertSubview:controller.view atIndex:0];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width * _numberOfViewControllers,
                                         self.view.bounds.size.height);
    
    [self scrollViewDidScroll:_scrollView];
}

- (void)setCurrentViewControllerIndex:(NSInteger)currentViewControllerIndex
{
    [self scrollToViewControllerAtIndex:currentViewControllerIndex animated:NO];
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
    [_scrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (CGFloat)index, 0) animated:animated];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL indexChanged = NO;
    CGFloat offset = scrollView.contentOffset.x / self.view.bounds.size.width;
    _currentViewControllerIndex = MAX(0, MIN(_numberOfViewControllers - 1, floorf(offset)));
    if (_currentViewControllerIndex != _previousViewControllerIndex)
    {
        UIViewController *previousController = _controllers[_previousViewControllerIndex];
        [previousController viewWillDisappear:YES];
        previousController.view.userInteractionEnabled = NO;
        
        UIViewController *currentViewController = _controllers[_currentViewControllerIndex];
        [currentViewController viewWillDisappear:YES];
        currentViewController.view.userInteractionEnabled = YES;
        
        indexChanged = YES;
    }

    [_controllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, __unused BOOL *stop) {

        UIView *view = controller.view;
        view.center = CGPointMake(self.view.bounds.size.width / 2.0f + scrollView.contentOffset.x, self.view.bounds.size.height / 2.0f);
        
        CGFloat angle = (offset - idx) * M_PI_2;
        while (angle < 0) angle += M_PI * 2;
        while (angle > M_PI * 2) angle = M_PI * 2;
        if (angle != 0.0f)
        {
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = -1.0/500;
            transform = CATransform3DTranslate(transform, 0, 0, -self.view.bounds.size.width / 2.0f);
            transform = CATransform3DRotate(transform, -angle, 0, 1, 0);
            transform = CATransform3DTranslate(transform, 0, 0, self.view.bounds.size.width / 2.0f);
            view.layer.transform = transform;
        }
        else
        {
            view.layer.transform = CATransform3DIdentity;
        }
    }];
    
    [_delegate cubeControllerDidScroll:self];
    if (indexChanged)
    {
        [_delegate cubeControllerCurrentViewControllerIndexDidChange:self];
        _previousViewControllerIndex = _currentViewControllerIndex;
    }
}

- (void)scrollViewWillBeginDragging:(__unused UIScrollView *)scrollView
{
    [_delegate cubeControllerWillBeginDragging:self];
}

- (void)scrollViewDidEndDragging:(__unused UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_delegate cubeControllerDidEndDragging:self willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(__unused UIScrollView *)scrollView
{
    [_delegate cubeControllerWillBeginDecelerating:self];
}

- (void)scrollViewDidEndDecelerating:(__unused UIScrollView *)scrollView
{
    [_delegate cubeControllerDidEndDecelerating:self];
}

- (void)scrollViewDidEndScrollingAnimation:(__unused UIScrollView *)scrollView
{
    [_delegate cubeControllerDidEndScrollingAnimation:self];
}

@end
