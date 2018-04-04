//
//  UserInfoController2.m
//  hinabian
//
//  Created by hnbwyh on 16/7/25.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "UserInfoController2.h"
#import "RDVTabBarController.h"
#import "UserInfoMainView.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "PersonInfoModel.h"

@interface UserInfoController2 ()

@property (nonatomic,strong) UserInfoMainView *userinfoView;
@property (nonatomic,strong) PersonInfoModel *personModel;
@property (nonatomic) BOOL isAlloc;

@end

@implementation UserInfoController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_personid == nil) {
        return;
    }
    //_personid = @"2001193";
    _isAlloc = YES;
    
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT;
    _userinfoView = [[UserInfoMainView alloc] initWithFrame:rect personid:_personid superVC:self];
    [self.view addSubview:_userinfoView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self setUpNav];
    [[self rdv_tabBarController] setTabBarHidden:YES];
    
    // 及时更新个人信息
//    if (!_isAlloc) {
//        [_userinfoView.mainMnager reqPersonalOrSpecialInfoWithID:_personid];
//        //NSLog(@" WillAppear 发出请求 ");
//    }else{
//        _isAlloc = NO;
//        //NSLog(@" WillAppear 不发请求 ");
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickCareBtn:) name:USERINFO_CAREBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickVBtn:) name:USERINFO_VBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickLevelBtn:) name:USERINFO_LEVELBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickMsgBtn:) name:USERINFO_MSGBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickBriefInfoBtn:) name:USERINFO_BRIEFINFOBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickAskQuestion:) name:USERINFO_SPECIALIST_ASKBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(hisTribeTableViewSelected:) name:USERINFO_HISTRIBE_TABLECELL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(hisQATableViewSelected:) name:USERINFO_HISQA_TABLECELL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:_userinfoView.mainMnager selector:@selector(clickHeadBtn:) name:USERINFO_HEADBUTTON object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //NSLog(@" %s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_CAREBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_MSGBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_VBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_LEVELBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_BRIEFINFOBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_SPECIALIST_ASKBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_HISTRIBE_TABLECELL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_HISQA_TABLECELL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_userinfoView.mainMnager name:USERINFO_HEADBUTTON object:nil];
}

- (void)setUpNav{

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *sharebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
    [sharebutton addTarget:self action:@selector(shareContent)
          forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sharebutton];
    sharebutton.hidden = YES;
    
    /*移民专家允许分享，以及显示提问按钮*/
    _userinfoView.modifyShareBtn = ^(BOOL isShow , PersonInfoModel *model){
        sharebutton.hidden = !isShow;
        _personModel = model;
    };
}

- (void)shareContent{

    NSString *shareURL = [NSString stringWithFormat:@"%@/personal_userinfo/user/%@",H5URL,_personid];
    NSString *shareTitle = [NSString stringWithFormat:@"%@-%@",_personModel.name,_personModel.leftText];
    
//    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//    
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UMKEY
//                                      shareText:_personModel.introduce
//                                     shareImage:[HNBUtils getImageFromURL:_personModel.head_url]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
//                                       delegate:(id)self];
    
    
    [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
    [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
    //调用分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        
        if (platformType == UMSocialPlatformType_Sina) {
            
            UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
            msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
            
            UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
            sharedObj.thumbImage = [HNBUtils getImageFromURL:_personModel.head_url];
            sharedObj.shareImage = [HNBUtils getImageFromURL:_personModel.head_url];
            msgObj.shareObject = sharedObj;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                messageObject:msgObj
                                        currentViewController:self
                                                   completion:nil];
            
        } else {
            
            UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
            
            UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                                   descr:_personModel.introduce
                                                                               thumImage:[HNBUtils getImageFromURL:_personModel.head_url]];
            sharedObj.webpageUrl = shareURL;
            msgObj.shareObject = sharedObj;
            
            [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                messageObject:msgObj
                                        currentViewController:self
                                                   completion:nil];
            
        }
        
    }];
    
    
    
    // 统计代码
    NSDictionary *dict = @{@"url":shareURL};
    [HNBClick event:@"126002" Content:dict];

}

- (void)back_preVC{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
