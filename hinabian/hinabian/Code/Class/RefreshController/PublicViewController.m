//
//  PublicViewController.m
//  hinabian
//
//  Created by 余坚 on 15/8/14.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

/*
 海那边 M 站 - 普通样式
 */


#import "PublicViewController.h"
#import "RDVTabBarController.h"
#import "SWKConsultOnlineViewController.h"
#import "LoginViewController.h"
#import "DataFetcher.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface PublicViewController ()
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * telNumb;
    BOOL showAppointmentBtn;
    BOOL shoudApperaReload;

}
@property (nonatomic,readwrite) BOOL isback;
@end

#define RELOAD_BUTTON_SIZE 150

@implementation PublicViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        showAppointmentBtn = TRUE;
        shoudApperaReload = TRUE;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"";
    // Do any additional setup after loading the view.
    //浏览器窗口
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)
                                                delegate:self
                                               superView:self.view
                                                     req:req
                                                  config:nil];
    
    /*
     hd.hinabian.com域名的全部为底部有咨询的活动页
     故将咨询按钮全部手动隐藏
    */
    if ([[self.URL absoluteString] rangeOfString:@"hd.hinabian.com"].location != NSNotFound) {
        [self setshowAppointmentBtn:FALSE];
        [self setshoudApperaReload:FALSE];
    }
    /*
     m.hinabian.com域名的全部活动页均不需要刷新页面
     故将自动刷新关闭
     */
    if ([[self.URL absoluteString] rangeOfString:@"m.hinabian.com/Activity_"].location != NSNotFound) {
        [self setshowAppointmentBtn:TRUE];
        [self setshoudApperaReload:FALSE];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    self.isback = false;
    
    if(shoudApperaReload)
    {
        [self.wkWebView webReload];
    }
}

/* 打电话 */
-(void) telToUs
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telNumb];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(void) back_main
{
    if (!_appointmentBtn.appointmentView.hidden && _appointmentBtn) {
        _appointmentBtn.alpha = 1.0f;
        _appointmentBtn.appointmentView.hidden = TRUE;
    }else{
        if ([self.wkWebView webCanGoBack]) {
            self.isback = true;
            [self.wkWebView webGoBack];
            //返回时重新获取当前的title
            [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
                if (resultString != nil || [self.title isEqualToString:@""]) {
                    self.title = resultString;
                }
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }
}
-(void) back
{
    if (!_appointmentBtn.appointmentView.hidden && _appointmentBtn) {
        _appointmentBtn.alpha = 1.0f;
        _appointmentBtn.appointmentView.hidden = TRUE;
    }else{
        if ([self.wkWebView webCanGoBack]) {
            self.isback = true;
            [self.wkWebView webGoBack];
            //返回时重新获取当前的title
            [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
                if (resultString != nil || [self.title isEqualToString:@""]) {
                    self.title = resultString;
                }
            }];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    }
}

- (void)hideShareBtn
{
    [self.navigationItem setRightBarButtonItem:nil];
}

- (void) setshowAppointmentBtn:(BOOL)isTure
{
    showAppointmentBtn = isTure;
}

- (void) setshoudApperaReload:(BOOL)isTure
{
    shoudApperaReload = isTure;
}

/* 点击分享按钮 */
-(void) shareContent
{
    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
    {
        //统计分享的URL
        NSDictionary *dict = @{@"url":shareURL};
        [HNBClick event:@"155081" Content:dict];
        
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
            }else{
                
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ] removeAllCachedResponses];
    NSLog(@"assess disappear");
}


-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    
    if (![self.wkWebView webCanGoBack])
    {
        temporaryBarButtonItem.action = @selector(back_main);
    }
    else
    {
        temporaryBarButtonItem.action = @selector(back);
    }
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    self.isback = false;

}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    
    if (![self.wkWebView webCanGoBack])
    {
        temporaryBarButtonItem.action = @selector(back_main);
    }
    else
    {
        temporaryBarButtonItem.action = @selector(back);
    }
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        if (resultString != nil || [self.title isEqualToString:@""]) {
            self.title = resultString;
        }
        
    }];
    
    [self getUrl];
    
    
    dispatch_group_t publickGroup = dispatch_group_create();
    dispatch_queue_t publickQueue = dispatch_queue_create("piblickQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_group_enter(publickGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.TEL_NUM" hanleComplete:^(NSString *resultString) {
        
        if ([resultString isEqualToString:@""] || resultString == Nil || resultString == nil || !resultString || resultString.length == 0 || [resultString isKindOfClass:[NSNull class]] || [resultString isEqualToString:@"(null)"]) {
            telNumb = DEFAULT_TELNUM;
        }else{
            telNumb = resultString;
        }
        
        dispatch_group_leave(publickGroup);
        
    }];
    
    dispatch_group_enter(publickGroup);
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_TITLE" hanleComplete:^(NSString *resultString) {
        
        shareTitle = resultString;
        dispatch_group_leave(publickGroup);
        
    }];
    
    dispatch_group_notify(publickGroup, publickQueue, ^{
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([shareTitle isEqualToString:@""] || shareTitle == Nil /*|| [telNumb isEqualToString:@""] || telNumb == Nil || !showAppointmentBtn*/)
            {
                self.navigationItem.rightBarButtonItem = nil;
            }
            else
            {
                UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
                [sharebutton addTarget:self action:@selector(shareContent)
                      forControlEvents:UIControlEventTouchUpInside];

                UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
                [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo,nil]];
                
            }
            
        });
        
    });
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_DESC" hanleComplete:^(NSString *resultString) {
        shareDesc = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_URL" hanleComplete:^(NSString *resultString) {
        shareURL = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_TITLE" hanleComplete:^(NSString *resultString) {
        shareFriendTitle = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_IMG" hanleComplete:^(NSString *resultString) {
        shareImageUrl = resultString;
    }];
    
    if (!_appointmentBtn && showAppointmentBtn) {
        //预约按钮
        float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
        float btnWidth = 53.0f*scale;
        float btnHeight = 53.0f*scale;
        
        _appointmentBtn = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - btnHeight - 128, btnWidth, btnHeight)];
        _appointmentBtn.delegate = (id)self;
        [self.wkWebView addSubview:_appointmentBtn];
    }

}

- (void)getUrl
{
    [self.wkWebView evaluateJavaScriptFromString:@"location.href" hanleComplete:^(NSString *resultString) {
        if (resultString)
        {
            self.URL = [NSURL URLWithString:resultString];
        }
        else
        {
            self.URL = nil;
        }

    }];
}


@end
