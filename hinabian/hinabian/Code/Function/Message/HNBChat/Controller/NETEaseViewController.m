//
//  NETEaseViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/10/17.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

@import MobileCoreServices;
@import AVFoundation;
#import "NETEaseViewController.h"
#import "RDVTabBarController.h"
#import "PersonalInfo.h"
#import "UserInfoController2.h"
#import "NIMSessionConfig.h"
#import <NIMMessageMaker.h>
#import <NIMKitUtil.h>
#import "HNBPreviewImageViewController.h"
#import <NIMSessionMessageContentView.h>

#define IsBlockedByOtherCode        7101


#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface NETEaseViewController ()<NIMSystemNotificationManagerDelegate,NIMMessageCellDelegate,NIMUserManagerDelegate>
{
    NSTimer *timer;
}

@property (nonatomic, strong)NSDictionary *otherEXTDic;     //对方的附带字段（json）
@property (nonatomic, strong)NSString *userNETEaseID;       //自己的ID

@property (nonatomic, strong)UIButton *infoBtn;             //查看用户详情
@property (nonatomic, strong)UIButton *blockBtn;            //屏蔽
@property (nonatomic, strong)UIView *blockInputView;        //屏蔽对方后用于遮盖输入框
@property (nonatomic, strong)UIView *limitedChatInputView;  //超出今日限制聊天人数用于遮盖输入框

@property (nonatomic, weak) id<NIMSystemNotificationManager> systemNotification;
@property (nonatomic, weak) id<NIMUserManager> userManager;

@end

@implementation NETEaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userNETEaseID = [NIMSDK sharedSDK].loginManager.currentAccount;
    
    if (self.session.sessionId && ![self.session.sessionId isEqualToString:@""]) {
        NIMUser *otherUser = [[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId];
        self.otherEXTDic = [HNBUtils dictionaryWithJsonString:otherUser.userInfo.ext];
    }
    
    _userManager = [NIMSDK sharedSDK].userManager;
    
}

//-(void)sendCustomNotification:(NIMCustomSystemNotification *)notification toSession:(NIMSession *)session completion:(NIMSystemNotificationHandler)completion {
//    NSLog(@"sysyssadijoasidajsodsajodao");
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBar];
    [self checkEXTDic];
}

- (void)setNavigationBar{
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationItem setHidesBackButton:YES];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    
    _infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_infoBtn setBackgroundImage:[UIImage imageNamed:@"IMEase_userinfo_icon"]forState:UIControlStateNormal];
    [_infoBtn addTarget:self action:@selector(clickRightNavBtn) forControlEvents:UIControlEventTouchUpInside];
    _infoBtn.hidden = NO;
    
    _blockBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 43, 18)];
    [_blockBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI20PX]];
    [_blockBtn.layer setCornerRadius:2.f];
    [_blockBtn.layer setMasksToBounds:YES];
    [_blockBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_blockBtn.layer setBorderWidth:0.5f];
    [_blockBtn addTarget:self action:@selector(blockOtherChat) forControlEvents:UIControlEventTouchUpInside];
    _blockBtn.custom_acceptEventInterval = 0.4f;

    UIView *tmp  = [[UIView alloc] initWithFrame:CGRectMake(0,0, 2, 2)];
    UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:_blockBtn];
    UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:_infoBtn];
    UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo, ButtonCenter, ButtonOne,nil]];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    if ([_userManager isUserInBlackList:self.session.sessionId]) {
        [_blockBtn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
    }else {
        [_blockBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
    }
}

- (void)checkEXTDic{
    if (self.session.sessionId && ![self.session.sessionId isEqualToString:@""]) {
        NIMUser *otherUser = [[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId];
        self.otherEXTDic = [HNBUtils dictionaryWithJsonString:otherUser.userInfo.ext];
    }
    //等同于self.title
    self.titleLabel.textColor = [UIColor whiteColor];
    if (self.otherEXTDic) {
        self.titleLabel.text = self.sessionTitle;
        NSUInteger identifierType = [self.otherEXTDic[@"type"] integerValue];
        if (identifierType != SpecialistIDType) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [self.sessionInputView.toolBar setInputBarItemTypes:@[
                                                                      @(NIMInputBarItemTypeVoice),
                                                                      @(NIMInputBarItemTypeTextAndRecord),
                                                                      //                         @(NIMInputBarItemTypeEmoticon),
                                                                      //                                                          @(NIMInputBarItemTypeCall),
                                                                      @(NIMInputBarItemTypeMore),
                                                                      ]];
                self.sessionInputView.toolBar.callBtn.hidden = YES;
                [self.sessionInputView refreshStatus:NIMInputStatusText];
                //对方为普通用户允许被屏蔽
                self.blockBtn.hidden = NO;
                self.blockInputView.hidden = ![_userManager isUserInBlackList:self.session.sessionId];
                
                if ([_otherEXTDic[@"id"] isEqualToString:hainabian_xiaozuli_id]) {
                    //海那边小助理不允许被屏蔽
                    self.blockBtn.hidden = YES;
                }
                
                //超出了允许聊天数或者当前聊天对象不是专家
                self.limitedChatInputView.hidden = _isAllow_Chat;
            });
        }else {
            //对方为专家或者官方不允许被屏蔽
            self.blockBtn.hidden = YES;
        }
        [timer invalidate];
        timer = nil;
    }else {
        
        timer= [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(checkEXTDic) userInfo:nil repeats:NO];
    }
}

- (NSString *)sessionTitle {
    NSString *title = @"";
    NIMSessionType type = self.session.sessionType;
    switch (type) {
        case NIMSessionTypeTeam:{
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
            title = [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
        }
            break;
        case NIMSessionTypeP2P:{
            NSString *subTitle = self.otherEXTDic[@"title"];
            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
            if ([self.otherEXTDic[@"type"] integerValue] == SpecialistIDType && subTitle && ![subTitle isEqualToString:@""] ) {
                NSString *specialistTitle = [NSString stringWithFormat:@"(%@)",self.otherEXTDic[@"title"]];
                title = [title stringByAppendingString:specialistTitle];
            }
        }
            break;
        default:
            break;
    }
    return title;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.sessionInputView.toolBar.callBtn addTarget:self action:@selector(callSpecialist) forControlEvents:UIControlEventTouchUpInside];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:(id<NIMSystemNotificationManagerDelegate>)self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    NSLog(@"=====>点击后的最近对话框数%ld",recentSessions.count);
    
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:(id<NIMSystemNotificationManagerDelegate>)self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *recentArr = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    NSInteger nowWholeChatNum = recentArr.count;//现在聊天对话框数
    
    NSMutableArray *limitedDataArr = [HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY];
    NSMutableArray *tempDataArr = [limitedDataArr mutableCopy];
    if (limitedDataArr.count == 0 || !limitedDataArr) {
        [HNBUtils setIMLocalLimited];
    }else {
        for (int index = 0; index < limitedDataArr.count; index++) {
            NSMutableDictionary *tempDic = limitedDataArr[index];
            NSMutableDictionary *changeDic = tempDic.mutableCopy;
            NSString *tempID = tempDic[NETEASE_LIMITED_ID];
            if ([tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
                NSInteger beforeWholeChatNum = [tempDic[NETEASE_TODAY_WHOLE] integerValue]; //此前聊天对话框数
                NSInteger addNewChatNum = nowWholeChatNum - beforeWholeChatNum;
                if ((!tempDic[NETEASE_TODAY_CHATNUM] || [tempDic[NETEASE_TODAY_CHATNUM] integerValue] == 0) && addNewChatNum > 0) {
                    //如果第一次插入了对话框开始计时
                    NSDateFormatter *formtter = [[NSDateFormatter alloc] init];
                    [formtter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSDate *currentDate = [NSDate date];
                    NSString *curentDateString = [formtter stringFromDate:currentDate];
                    [changeDic setObject:curentDateString forKey:NETEASE_FIRST_CHATTIME];
                }
                [changeDic setObject:[NSString stringWithFormat:@"%ld",(long)addNewChatNum] forKey:NETEASE_TODAY_CHATNUM];
                //替换更新当前数据
                [tempDataArr replaceObjectAtIndex:index withObject:changeDic];
                [HNBUtils sandBoxSaveInfo:tempDataArr forKey:NETEASE_LIMITED_ARRAY];
                break;
            }
            //如果该账号并未保存过
            if (![tempID isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount] && index == limitedDataArr.count - 1) {
                [HNBUtils setIMLocalLimited];
            }
        }
    }
    NSLog(@"=====>离开聊天框 :%@",[HNBUtils sandBoxGetInfo:[NSMutableArray class] forKey:NETEASE_LIMITED_ARRAY]);
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - Cell事件
- (BOOL)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    
    return handled;
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}

#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = message.messageObject;
    HNBGalleryItem *item = [[HNBGalleryItem alloc] init];
    item.thumbPath      = [object thumbPath];
    item.imageURL       = [object url];
    item.name           = [object displayName];
    item.itemId         = [message messageId];

    NIMSession *session = [self isMemberOfClass:[NETEaseViewController class]]? self.session : nil;

    HNBPreviewImageViewController *vc = [[HNBPreviewImageViewController alloc] initWithItem:item session:session];
    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showVideo:(NIMMessage *)message
{
    //暂时不支持
}

- (void)showLocation:(NIMMessage *)message
{
    //暂时不支持
}

- (void)showFile:(NIMMessage *)message
{
    //暂时不支持
}

- (void)showCustom:(NIMMessage *)message
{
    //暂时不支持
}

#pragma mark - NIMMediaManagerDelegate
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if (!filePath || error) {
        self.sessionInputView.recording = NO;
        [self onRecordFailed:error];
    }
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error {
    if(!error) {
        if ([self recordFileCanBeSend:filePath]) {
            [self sendMessage:[NIMMessageMaker msgWithAudio:filePath]];
        }else{
            [self showRecordFileNotSendReason];
        }
    } else {
        [self onRecordFailed:error];
    }
    self.sessionInputView.recording = NO;
}

- (void)recordAudioDidCancelled {
    self.sessionInputView.recording = NO;
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime {
    [self.sessionInputView updateAudioRecordTime:currentTime];
}

- (void)recordAudioInterruptionBegin {
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
}

#pragma mark - 录音失败
- (void)onRecordFailed:(NSError *)error {
    [[HNBToast shareManager] toastWithOnView:self.view msg:@"录音失败" afterDelay:0.5f style:HNBToastHudFailure];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason {
    [[HNBToast shareManager] toastWithOnView:self.view msg:@"录音太短" afterDelay:0.5f style:HNBToastHudFailure];
}

- (void)callSpecialist {
    if (_otherEXTDic) {
        NSString *phoneNum =_otherEXTDic[@"phone"];
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    [super sendMessage:message didCompleteWithError:error];
    if (error.code == IsBlockedByOtherCode) {
        //本账号被当前用户加入黑名单
        [[HNBToast shareManager] toastWithOnView:self.view msg:@"你已被对方屏蔽了" afterDelay:1.f style:HNBToastHudOnlyText];
    }
}

#pragma mark - 接受自定义系统消息
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification {
    if (!notification) {
        NSLog(@"发了个nil");
    }else{
        NSLog(@"不是nil");
    }
}

//-(void)onReceiveSystemNotification:(NIMSystemNotification *)notification {
//    if (!notification) {
//        NSLog(@"发了个nil");
//    }
//}

//点击用户头像
- (BOOL)onTapAvatar:(NSString *)userId {
    
    NIMSession *otherSession = [NIMSession session:userId type:NIMSessionTypeP2P];
    
//    NIMCustomSystemNotificationSetting *setting = [[NIMCustomSystemNotificationSetting alloc] init];
//    setting.apnsWithPrefix = YES;
//    setting.apnsEnabled = YES;
//    setting.shouldBeCounted = YES;
//
//    NIMCustomSystemNotification *noti = [[NIMCustomSystemNotification alloc] initWithContent:@"这是nil"];
//    noti.setting = setting;
//    noti.sendToOnlineUsersOnly = YES;
//    noti.apnsContent = @"系统消息";
//    noti.apnsPayload = @{@"senderID":@"系统消息",
////                         @"nim":userId,
//                         };
//    [[NIMSDK sharedSDK].systemNotificationManager markAllNotificationsAsRead];
//    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:noti toSession:otherSession completion:^(NSError * _Nullable error) {
//        NSLog(@"自定义系统消息发送成功");
//    }];
    
    if ([_userNETEaseID isEqualToString:userId]) {
        //点击自己的头像
        return NO;
    }else {
        //获取历史消息
        NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
//        option.startTime = 0;
        option.startTime = self.messageForMenu.timestamp;
        option.limit = 100;
        option.endTime = 0;
        [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:otherSession option:option result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
            NSLog(@"%@",error.localizedDescription);
            [self uiInsertMessages:messages];
            [self.tableView reloadData];
        }];
        //点击对方的头像
//        [self jumpToUserInfo:userId];
    }
    return YES;
}

- (void)clickRightNavBtn {
    NSString *otherID = _otherEXTDic[@"id"];
    if (otherID && ![otherID isEqualToString:@""]) {
        UserInfoController2 *vc = [[UserInfoController2 alloc]init];
        vc.personid = otherID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)jumpToUserInfo:(NSString *)userId {
    NIMUser *otherUser = [[NIMSDK sharedSDK].userManager userInfo:userId];
    NSString *extJsonString = otherUser.userInfo.ext;
    if (extJsonString && ![extJsonString isEqualToString:@""]) {
        NSDictionary *userDic = [HNBUtils dictionaryWithJsonString:extJsonString];
        UserInfoController2 *vc = [[UserInfoController2 alloc]init];
        vc.personid = userDic[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
 ** 屏蔽对方发消息
 */
- (void)blockOtherChat
{
    if ([_userManager isUserInBlackList:self.session.sessionId]) {
        [_userManager removeFromBlackBlackList:self.session.sessionId completion:^(NSError * _Nullable error) {
            NSLog(@"你已将对方从黑名单中移除");
            [_blockBtn setTitle:@"屏蔽" forState:UIControlStateNormal];
            self.blockInputView.hidden = YES;
        }];
    }else {
        //加入黑名单（网易云）
        [[NIMSDK sharedSDK].userManager addToBlackList:self.session.sessionId completion:^(NSError * _Nullable error) {
            NSLog(@"你已将对方加入黑名单中");
            [_blockBtn setTitle:@"取消屏蔽" forState:UIControlStateNormal];
            self.blockInputView.hidden = NO;
            self.sessionInputView.toolBar.showsKeyboard = NO;
        }];
    }
}


- (UIView *)blockInputView
{
    if (!_blockInputView) {
        _blockInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _blockInputView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *blockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [blockImageView setImage:[UIImage imageNamed:@"IMEase_Block_InputView"]];
        [_blockInputView addSubview:blockImageView];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        alertLabel.text = @"你已将对方屏蔽";
        alertLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.f];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = [UIFont boldSystemFontOfSize:FONT_UI28PX];
        [_blockInputView addSubview:alertLabel];
        
        [self.sessionInputView addSubview:_blockInputView];
    }
    return _blockInputView;
}

- (UIView *)limitedChatInputView
{
    if (!_limitedChatInputView) {
        _limitedChatInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _limitedChatInputView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *blockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [blockImageView setImage:[UIImage imageNamed:@"IMEase_Block_InputView"]];
        [_limitedChatInputView addSubview:blockImageView];
        
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        alertLabel.text = @"你的热情值得夸奖，明天请继续加油！";
        alertLabel.textColor = [UIColor DDR153_G153_B153ColorWithalph:1.f];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.font = [UIFont boldSystemFontOfSize:FONT_UI28PX];
        [_limitedChatInputView addSubview:alertLabel];
        
        [self.sessionInputView addSubview:_limitedChatInputView];
    }
    return _limitedChatInputView;
}


@end
