//
//  SWKCommonWebVC.m
//  hinabian
//
//  Created by hnbwyh on 2017/12/14.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SWKCommonWebVC.h"
#import "TalkingDataAppCpa.h"

@interface SWKCommonWebVC ()
/**
 * 该控制展示时标记是否属于 pop
 */
@property (nonatomic,assign) BOOL isPopBack;
@end

@implementation SWKCommonWebVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isPopBack = FALSE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSDictionary *rltDic = [self.webManger parserConfigDataURLString:self.URL.absoluteString];
    [self modifyIndividualUIWithConfigDic:rltDic];
    //NSLog(@"\n \n %s \n - \n %@ \n \n",__func__,self.navigationController.viewControllers);
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isPopBack = TRUE; // push 之后下次返回时该值为真
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------------------------------------ 配置个性化 UI

- (void)modifyIndividualUIWithConfigDic:(NSDictionary *)dic{
    
    NSString *rlt_navbar = [dic returnValueWithKey:IS_NATIVE_NAVBAR];
    NSString *rlt_nav_backBtn = [dic returnValueWithKey:IS_NATIVE_BACKBTN];
    NSString *rlt_nav_showTitle = [dic returnValueWithKey:IS_NATIVE_SHOWTITLE];
    NSString *rlt_nav_showSharedBtn = [dic returnValueWithKey:IS_NATIVE_SHOWSHAREDBTN];
    NSString *rlt_nav_ShowTelBtn = [dic returnValueWithKey:IS_NATIVE_SHOWTELBTN];
    NSString *rlt_nav_ShowConsult = [dic returnValueWithKey:IS_NATIVE_SHOWCONSULT];
    NSString *rlt_canRefresh_whenBack = [dic returnValueWithKey:IS_NATIVE_CANREFRESH_WHENBACK];
    
    
    // 原生导航栏是否显示
    if ([rlt_navbar isEqualToString:@"0"]) {
        self.isNativeNavBar = FALSE;
    }else{
        
        // 原生导航栏设置
        if ([rlt_nav_backBtn isEqualToString:@"0"]) {
            self.isNativeNavShowBackBtn = FALSE;
        }
        if ([rlt_nav_showTitle isEqualToString:@"0"]) {
            self.isNativeNavShowTitle = FALSE;
        }
        
        // only - share : 默认样式
        
        // only - tel
        if ([rlt_nav_showSharedBtn isEqualToString:@"0"] &&
            [rlt_nav_ShowTelBtn isEqualToString:@"1"]) {
            self.isNativeNavRightOnlyShowTelBtn = TRUE;
        }
        
        // tel - share
        if (![rlt_nav_showSharedBtn isEqualToString:@"0"] &&
            [rlt_nav_ShowTelBtn isEqualToString:@"1"]) {
            self.isNativeNavRightShowTelBtnAndSharedBtn = TRUE;
        }
        
        // 右侧无按钮
        if ([rlt_nav_showSharedBtn isEqualToString:@"0"] &&
            ![rlt_nav_ShowTelBtn isEqualToString:@"1"]) {
            self.isNativeNavRightOnlyShowSharedBtn = FALSE;
        }
    }
    
    if ([rlt_nav_ShowConsult isEqualToString:@"1"]) {
        self.isNativeNavShowConsultBtn = TRUE;
    }
    
    
    if (self.isPopBack) {
        NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
        if ([rlt_canRefresh_whenBack isEqualToString:@"1"] ||
            [isFromLogin isEqualToString:@"1"] ||
            self.manualRefreshWhenBack) {
            self.canRefreshWhenBack = TRUE;
            [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
        }
    }
    
    
}

@end
