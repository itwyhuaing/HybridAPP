//
//  SpecialActivityViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/11/25.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import "SpecialActivityViewController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

//void *CusomHeaderInsetObserver = &CusomHeaderInsetObserver;
@interface SpecialActivityViewController ()
{
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * telNumb;
}

@end

@implementation SpecialActivityViewController


-(instancetype)init
{
    SeminarViewController * seminarVc = [[SeminarViewController alloc]init];
    IMClassroomViewController *classroomVc = [[IMClassroomViewController alloc]init];
    IMInterviewViewController *interviewVc = [[IMInterviewViewController alloc]init];
    IMActivityViewController *actiVc = [[IMActivityViewController alloc] init];
    if (self) {
//        [self setViewControllers:@[vc]];
        self = [super initWithControllers:seminarVc,classroomVc,interviewVc, actiVc,nil];
        self.title = @"移民攻略";
        self.headerHeight = 0;
//        shareURL = @"https://m.hinabian.com/cnd/activity/seminar.html";
//        shareTitle = @"【移民必看】海那边教你如何在移民路上顺风顺水";
//        shareFriendTitle = @"【移民必看】海那边教你如何在移民路上顺风顺水";
//        shareDesc = @"移民前中后的事情，这里居然全都有";
//        shareImageUrl = @"https://cache.hinabian.com/images/share/logo.jpg";
//        telNumb = @"4009933922";
    }
    return self;
}

-(instancetype)initWithIndex:(NSInteger) index
{
    SeminarViewController * seminarVc = [[SeminarViewController alloc]init];
    IMClassroomViewController *classroomC = [[IMClassroomViewController alloc]init];
    IMInterviewViewController *interviewC = [[IMInterviewViewController alloc]init];
    IMActivityViewController *actiVc = [[IMActivityViewController alloc] init];
    if (self) {
        //        [self setViewControllers:@[vc]];
        self = [super initWithControllers:seminarVc,classroomC,interviewC, actiVc,nil];
        self.title = @"移民攻略";
        // your code
        self.headerHeight = 0;
        [self setSegmentIndex:index];
//        switch (index) {
//            case 0:
//                shareURL = @"https://m.hinabian.com/cnd/activity/seminar.html";
//                break;
//            case 1:
//                shareURL = @"https://m.hinabian.com/cnd/activity/class.html";
//                break;
//            case 2:
//                shareURL = @"https://m.hinabian.com/cnd/activity/interview.html";
//                break;
//            case 3:
//                shareURL = @"https://m.hinabian.com/cnd/activity/activity.html";
//                break;
//
//            default:
//                break;
//        }
//        shareTitle = @"【移民必看】海那边教你如何在移民路上顺风顺水";
//        shareFriendTitle = @"【移民必看】海那边教你如何在移民路上顺风顺水";
//        shareDesc = @"移民前中后的事情，这里居然全都有";
//        shareImageUrl = @"https://cache.hinabian.com/images/share/logo.jpg";
//        telNumb = @"4009933922";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor beigeColor]];
//    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUpNav];
    

    
//    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
//    [sharebutton addTarget:self action:@selector(shareContent)
//          forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *telbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [telbutton setBackgroundImage:[UIImage imageNamed:@"icon_bohao"]forState:UIControlStateNormal];
//    [telbutton addTarget:self action:@selector(telToUs)
//        forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *tmp  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 8, 8)];
//
//    UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:telbutton];
//    UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
//    UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo,ButtonCenter, ButtonOne,nil]];
}

- (void)setUpNav{

    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem hidesBackButton];
    
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///* 打电话 */
//-(void) telToUs
//{
//    [HNBClick event:@"115011" Content:nil];
//    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",telNumb];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//}
///* 点击分享按钮 */
//-(void) shareContent
//{
//    switch (self.pageindex) {
//        case 0:
//            shareURL = @"https://m.hinabian.com/cnd/activity/seminar.html";
//            break;
//        case 1:
//            shareURL = @"https://m.hinabian.com/cnd/activity/class.html";
//            break;
//        case 2:
//            shareURL = @"https://m.hinabian.com/cnd/activity/interview.html";
//            break;
//        case 3:
//            shareURL = @"https://m.hinabian.com/cnd/activity/activity.html";
//            break;
//
//        default:
//            break;
//    }
//
//    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
//    {
//        NSDictionary *dict = @{@"url" : shareURL};
//        [HNBClick event:@"115012" Content:dict];
//
//        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
//        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
//        //调用分享面板
//        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//
//
//            if (platformType == UMSocialPlatformType_Sina) {
//
//                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
//                msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
//
//                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
//                sharedObj.thumbImage = [HNBUtils getImageFromURL:shareImageUrl];
//                sharedObj.shareImage = [HNBUtils getImageFromURL:shareImageUrl];
//                msgObj.shareObject = sharedObj;
//
//                [[UMSocialManager defaultManager] shareToPlatform:platformType
//                                                    messageObject:msgObj
//                                            currentViewController:self
//                                                       completion:nil];
//
//            } else {
//
//                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
//
//                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
//                                                                                       descr:shareDesc
//                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
//                sharedObj.webpageUrl = shareURL;
//                msgObj.shareObject = sharedObj;
//
//                [[UMSocialManager defaultManager] shareToPlatform:platformType
//                                                    messageObject:msgObj
//                                            currentViewController:self
//                                                       completion:nil];
//
//            }
//
//        }];
//
//
//    }
//}


@end
