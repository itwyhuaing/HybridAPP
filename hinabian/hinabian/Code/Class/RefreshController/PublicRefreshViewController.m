//
//  PublicRefreshViewController.m
//  hinabian
//
//  Created by 余坚 on 17/1/11.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

/*
 海那边 M 站 ，需要刷新
 */

#import "PublicRefreshViewController.h"
#import "RDVTabBarController.h"
#import "LoginViewController.h"
#import "DataFetcher.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "WXApi.h"
#import "IMAssessViewController.h"
//#import "SWKIMProjectShowController.h" // UIWeb + WKWeb
#import "RefreshControl.h"
#import "HNBNetRemindView.h"
#import "HNBLoadingMask.h"
#import "HNBTipMask.h"
#import "SWKConsultOnlineViewController.h"

@interface PublicRefreshViewController ()<RefreshControlDelegate,HNBNetRemindViewDelegate>
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * telNumb;
}

@property (nonatomic,strong) NSURL *localURL;
@property (nonatomic,readwrite) BOOL isback;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,strong) NSURLRequest *currentReq;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isAlloc;


@end

@implementation PublicRefreshViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    _isFinished = NO;
    _isAlloc = YES;
    // Do any additional setup after loading the view.
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - SCREEN_NAVHEIGHT;
    UIScrollView *scrolView = [[UIScrollView alloc] initWithFrame:rect];
    rect.size.height = SCREEN_HEIGHT - SCREEN_NAVHEIGHT + 0.3;
    scrolView.contentSize = rect.size;
    //scrolView.scrollEnabled = NO;
    [self.view addSubview:scrolView];
    
    NSURLRequest *req = nil;
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"project/type.html"];
        self.localURL = [[NSURL alloc] withOutNilString:tmpURLString];
        req = [NSURLRequest requestWithURL:self.localURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    else
    {
        req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    _currentReq = req;
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:rect
                                                delegate:self
                                               superView:scrolView
                                                     req:req
                                                  config:nil];
    
    // 下拉刷新
    _refreshControl=[[RefreshControl alloc] initWithScrollView:scrolView delegate:self];
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!_isFinished && !_isAlloc) {
        [self.wkWebView webLoadRequest:_currentReq];
    }
    
    self.isback = false;
    
    /* 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        //[self.webView reload];
        [self.wkWebView webReload];
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    [[HNBLoadingMask shareManager] dismiss];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    _isAlloc = NO;
    
}

#pragma mark ------ CONSULT_BUTTON_DELEGATE

- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton
{
    NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];
    self.isOverseasHouseConsult = [self.webManger isOverseasHouseConsultWithURLString:self.URL.absoluteString];
    if (self.isOverseasHouseConsult) {
        str = [NSString stringWithFormat:@"https://static.meiqia.com/dist/standalone.html?_=t&eid=1875&groupid=7ab95cefc1046cabbdb4628399c56f9a"];
    }
    
    SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
    vc.URL = [[NSURL alloc] withOutNilString:str];
    if ([self.title isEqualToString:@"移民项目"]) {
        vc.isIMAcess = TRUE;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton
{
    [self.wkWebView evaluateJavaScriptFromString:@"window.TEL_NUM" hanleComplete:^(NSString *resultString) {
        
        NSString * tmpTel = resultString;
        if ([tmpTel isEqualToString:@""] || Nil == tmpTel) {
            tmpTel = DEFAULT_TELNUM;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",tmpTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }];
}

/* 打电话 */
-(void) telToUs
{
    [HNBClick event:@"115011" Content:nil];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telNumb];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
/* 点击分享按钮 */
-(void) shareContent
{
    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
    {
        NSDictionary *dict = @{@"url" : shareURL};
        [HNBClick event:@"115012" Content:dict];
        
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
        //调用分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            
            if (platformType == UMSocialPlatformType_Sina) {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
                
                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
                sharedObj.thumbImage = [HNBUtils getImageFromURL:shareImageUrl];
                sharedObj.shareImage = [HNBUtils getImageFromURL:shareImageUrl];
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }else if (platformType == UMSocialPlatformType_WechatSession){
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareFriendTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            } else {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            }
        }];
    }
}

-(void) reloadRightNow
{
    [self.wkWebView webReload];
}
-(void) back
{
    if ([self.wkWebView webCanGoBack]) {
        
        self.isback = YES;
        [self.wkWebView webGoBack];
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void) webViewReload
{
    //NSLog(@"inside");
    NSURLRequest *req = nil;
    if (self.URL) {
        req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    else
    {
        req = [NSURLRequest requestWithURL:self.localURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    }
    
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    
    //[self.webView loadRequest:req];
    [self.wkWebView webLoadRequest:req];
}

#pragma mark ------ Base Publick

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //NSLog(@" %s ",__FUNCTION__);
    if (![self.wkWebView webCanGoBack] && nil == self.URL)
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    else
    {
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
        temporaryBarButtonItem.target = self;
        temporaryBarButtonItem.action = @selector(back);
        self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    }
    if (!self.isback) {
        [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view
                                                loadingMaskType:LoadingMaskTypeExtendTabBar
                                                        yoffset:0.0];
    }
    self.isback = false;
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    // 若为真
    _isFinished = YES;
    
    // 关闭刷新
    if (_refreshControl.refreshingDirection != RefreshingDirectionNone) {
        [_refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }

    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        
        self.title = resultString;
        
    }];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    [self.wkWebView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
    
    dispatch_group_t improjectFinishGroup = dispatch_group_create();
    dispatch_queue_t improjectFinishQueue = dispatch_queue_create("improjectFinishQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_TITLE" hanleComplete:^(NSString *resultString) {
        
        shareTitle = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_DESC" hanleComplete:^(NSString *resultString) {
        
        shareDesc = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_URL" hanleComplete:^(NSString *resultString) {
        
        shareURL = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_TITLE" hanleComplete:^(NSString *resultString) {
        
        shareFriendTitle = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_IMG" hanleComplete:^(NSString *resultString) {
        
        shareImageUrl = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];
    
    dispatch_group_enter(improjectFinishGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.TEL_NUM" hanleComplete:^(NSString *resultString) {
        
        telNumb = resultString;
        dispatch_group_leave(improjectFinishGroup);
    }];

    dispatch_group_notify(improjectFinishGroup, improjectFinishQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([shareTitle isEqualToString:@""] || shareTitle == Nil || [telNumb isEqualToString:@""] || telNumb == Nil)
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
            else
            {
                UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
                [sharebutton addTarget:self action:@selector(shareContent)
                      forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *telbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                [telbutton setBackgroundImage:[UIImage imageNamed:@"icon_bohao"]forState:UIControlStateNormal];
                [telbutton addTarget:self action:@selector(telToUs)
                    forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *tmp  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 8, 8)];
                
                UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:telbutton];
                UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
                UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
                [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo,ButtonCenter, ButtonOne,nil]];
                
            }
            
        });
        
    });
    
    
    //NSLog(@" %s ",__FUNCTION__);
    [[HNBLoadingMask shareManager] dismiss];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    //NSLog(@" %s ",__FUNCTION__);
    _isFinished = NO;
    
    if (_refreshControl.refreshingDirection != RefreshingDirectionNone) {
        // 刷新操作失败
        [_refreshControl finishRefreshingDirection:RefreshDirectionTop];
        
    }else if (101 != error.code && 102 != error.code && error.code != NSURLErrorCancelled){
        
        // 第一次进入时失败
        HNBNetRemindView *showPoorNetView = [[HNBNetRemindView alloc] init];
        [showPoorNetView loadWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                             superView:self.view
                              showType:HNBNetRemindViewShowPoorNet
                              delegate:self];
    }
    
    [[HNBLoadingMask shareManager] dismiss];
    //NSLog(@" %s ",__FUNCTION__);
    
}


#pragma mark ------ RefreshControlDelegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) { // 顶部下拉刷新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.wkWebView evaluateJavaScriptFromString:@"location.href" hanleComplete:^(NSString *resultString) {

                // 更新 URL 
                NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:resultString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
                [self.wkWebView webLoadRequest:req];
                _currentReq = req;
                [refreshControl finishRefreshingDirection:RefreshDirectionTop];
                
            }];
            
        });
        
        return;
    } else{
        
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
    
}

#pragma mark ------ 网络状态判断

- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{
    
    if (remindView.tag == HNBNetRemindViewShowPoorNet) {
        
        [remindView removeFromSuperview];
        if (self.URL) {
            NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            [self.wkWebView webLoadRequest:req];
            return;
        }
        else if(self.localURL)
        {
            NSURLRequest *req = [NSURLRequest requestWithURL:self.localURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            [self.wkWebView webLoadRequest:req];
            return;
        }
        
        
    }
    
}

@end
