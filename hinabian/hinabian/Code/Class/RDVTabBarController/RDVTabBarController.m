// RDVTabBarController.m
// RDVTabBarController
//
// Copyright (c) 2013 Robert Dimitrov
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController;

@end

@interface RDVTabBarController () {
    UIView *_contentView;
}

@property (nonatomic, readwrite) RDVTabBar *tabBar;

@end

@implementation RDVTabBarController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:[self contentView]];
    [self.view addSubview:[self tabBar]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:[self selectedIndex]];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
//    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
//    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    for (UIViewController *viewCotroller in [self viewControllers]) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Methods

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    if(selectedIndex == 0)
    {
//        [HNBClick event:@"100060" Content:nil];
        //由于要带上首页类型，在首页上报
    }
    else if(selectedIndex == 1)
    {
        [HNBClick event:@"201042" Content:nil];
    }
    else if(selectedIndex == 2)
    {
        [HNBClick event:@"201041" Content:nil];
    }
    else if (selectedIndex == 3)
    {
        [HNBClick event:@"201043" Content:nil];
    }
    else if (selectedIndex == 4)
    {
        [HNBClick event:@"201044" Content:nil];
//        NSString *isLogin =[NSString stringWithFormat:@"%d",[HNBUtils isLogin]];
//        NSDictionary *dict = @{@"is_login":isLogin};
//        [HNBClick event:@"100063" Content:dict];
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setFrame:[[self contentView] bounds]];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            RDVTabBarItem *tabBarItem = [[RDVTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController rdv_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController rdv_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    if ([searchedController navigationController]) {
        searchedController = [searchedController navigationController];
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (RDVTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[RDVTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                      UIViewAutoresizingFlexibleTopMargin|
                                      UIViewAutoresizingFlexibleLeftMargin|
                                      UIViewAutoresizingFlexibleRightMargin|
                                      UIViewAutoresizingFlexibleBottomMargin)];
        //[_tabBar setTranslucent:TRUE];
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    _tabBarHidden = hidden;
    
    __weak RDVTabBarController *weakSelf = self;
    
    void (^block)() = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
//            tabBarHeight = 49;
            tabBarHeight = SCREEN_TABHEIGHT;
            if (IS_IPHONE_X) {
                [weakSelf tabBar].contentEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
            }else {
                [weakSelf tabBar].contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
        
        if (!hidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (hidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

#pragma mark - RDVTabBarDelegate

- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if ([[self delegate] respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        if (![[self delegate] tabBarController:self shouldSelectViewController:[self viewControllers][index]]) {
            return NO;
        }
    }
    
    if ([self selectedViewController] == [self viewControllers][index]) {
        if ([[self selectedViewController] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)[self selectedViewController];
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (void)tabBar:(RDVTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
        [[self delegate] tabBarController:self didSelectViewController:[self viewControllers][index]];
    }
}

@end

#pragma mark - UIViewController+RDVTabBarControllerItem

@implementation UIViewController (RDVTabBarControllerItemInternal)

- (void)rdv_setTabBarController:(RDVTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(rdv_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation UIViewController (RDVTabBarControllerItem)

- (RDVTabBarController *)rdv_tabBarController {
    RDVTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(rdv_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController rdv_tabBarController];
    }
    
    return tabBarController;
}

- (RDVTabBarItem *)rdv_tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)rdv_setTabBarItem:(RDVTabBarItem *)tabBarItem {
    RDVTabBarController *tabBarController = [self rdv_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    RDVTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end


