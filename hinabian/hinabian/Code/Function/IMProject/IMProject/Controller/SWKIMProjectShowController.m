//
//  SWKIMProjectShowController.m
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKIMProjectShowController.h"
#import "RDVTabBarController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface SWKIMProjectShowController () 
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * telNumb;
    //WKWebView *_wkweb;
}

@property (nonatomic,strong) NSURL *localURL;
@property (nonatomic,readwrite) BOOL isback;

@end

@implementation SWKIMProjectShowController


#pragma mark ------ init - dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"移民项目";
    }
    return self;
}

- (void)viewDidLoad {
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"project/type.html"];
        self.localURL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    else
    {
        NSString *tempURL = [self.URL absoluteString];
        if ([tempURL rangeOfString:@"detail"].location != NSNotFound)  //某jumpIntoCOD个项目页
        {
            if ([tempURL rangeOfString:@"?project_id="].location != NSNotFound) {
                NSString *tmpID = [[tempURL componentsSeparatedByString:@"?project_id="] lastObject];
                tempURL = [NSString stringWithFormat:@"%@/native/project/detail?project_id=%@",H5URL,tmpID];
                self.URL = [NSURL URLWithString:tempURL];
            }
        }
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    [self.wkWebView setWebFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.wkWebView.scrollView.scrollIndicatorInsets = self.wkWebView.scrollView.contentInset;
    } else {
        // Fallback on earlier versions
        self.edgesForExtendedLayout = -20.f;
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.isback = false;
    
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    /** 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:NO]; // 隐藏
    
//    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}

#pragma mark ------ UIGestureRecognizerDelegate

//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@" gestureRecognizerShouldBegin : %@ \n %@",gestureRecognizer,[gestureRecognizer class]);
//    BOOL isAllow = TRUE;
//    if ([self.wkWebView webCanGoBack] && [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
//        [self.wkWebView webGoBack];
//        isAllow = FALSE;
//    }
//    return isAllow;
//}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"IMProject"];
    
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------ delegate

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    // js 交互
    self.isback = false;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
}


@end
