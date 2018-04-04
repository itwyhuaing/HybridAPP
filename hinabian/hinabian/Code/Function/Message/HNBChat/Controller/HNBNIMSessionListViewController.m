//
//  HNBNIMSessionListViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/10.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBNIMSessionListViewController.h"
#import "NIMSessionViewController.h"
#import "NIMSessionListCell.h"
#import "UIView+NIM.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "NIMKit.h"
#import "NewsCenterCell.h"
#import "NewsCenterModel.h"

#import "DataFetcher.h"


@interface HNBNIMSessionListViewController ()



@end

@implementation HNBNIMSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_NewsCenterCell bundle:nil] forCellReuseIdentifier:cellNibName_NewsCenterCell];
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    if (!self.recentSessions.count) {
        _recentSessions = [NSMutableArray array];
    }
    
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    extern NSString *const NIMKitTeamInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:NIMKitTeamInfoHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitTeamMembersHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:NIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:NIMKitUserInfoHasUpdatedNotification object:nil];
}

- (void)refresh{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 1) {
        [HNBClick event:@"202002" Content:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NIMRecentSession *recentSession = self.recentSessions[indexPath.row - 1];
        [self onSelectedRecent:recentSession atIndexPath:indexPath];
    }else {
        //在办项目
        [HNBClick event:@"202001" Content:nil];
        for (NIMRecentSession *recSession in self.recentSessions) {
            //标记在办项目聊天全为已读
            if ([recSession.session.sessionId isEqualToString:goonproject_netease_id]) {
                [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:recSession.session];
                break;
            }
        }
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/personal_migrant/noticePage.html",H5URL]
                                                       ctle:@"1"
                                                 csharedBtn:@"0"
                                                       ctel:@"0"
                                                  cfconsult:@"0"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        NIMRecentSession *recent = self.recentSessions[indexPath.row - 1];//-1是由于第一个用于项目通知
        if ([recent.session.sessionId isEqualToString:goonproject_netease_id]) {
            //用于隐藏ID在办项目通知聊天框
            return 0;
        }
    }
    return 70.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 1) {
        NIMRecentSession *recentSession = self.recentSessions[indexPath.row - 1];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [self onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
        }
    }else {
        //在办项目不允许删除
        return;
    }
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentSessions.count + 1;//+1是由于第一个用于项目通知
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    static NSString * cellId = @"cellId";
    UITableViewCell *tableCell = [[UITableViewCell alloc] init];
    
    if (indexPath.row == 0) {
        NewsCenterCell *returnCell = [tableView dequeueReusableCellWithIdentifier:cellNibName_NewsCenterCell];
        if (!returnCell) {
            returnCell = [[NewsCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNibName_NewsCenterCell];
        }
        NewsCenterModel *f = [[NewsCenterModel alloc] init];
        f.title = @"在办项目通知";
        f.imgName = @"newsCenter_goonProject_notice";
        f.desc = @"办理的项目有进展及时通知您";
        //手动设置消息数
        for (NIMRecentSession *recSession in self.recentSessions) {
            if ([recSession.session.sessionId isEqualToString:goonproject_netease_id]) {
                f.noctice_num = [NSString stringWithFormat:@"%ld",recSession.unreadCount];
                break;
            }else {
                f.noctice_num = @"0";
            }
        }
        [returnCell setCellItemWithInfoModel:f];
        tableCell = returnCell;

        
    }else if (indexPath.row >= 1) {
        NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
        }
        NIMRecentSession *recent = self.recentSessions[indexPath.row - 1];//-1是由于第一个用于项目通知
        if ([recent.session.sessionId isEqualToString:goonproject_netease_id]) {
        //用于隐藏ID在办项目通知聊天框
            cell.hidden = YES;
        }
        cell.nameLabel.text = [self nameForRecentSession:recent];
        [cell.avatarImageView setAvatarBySession:recent.session];
        [cell.nameLabel sizeToFit];
        cell.messageLabel.attributedText  = [self contentForRecentSession:recent];
        [cell.messageLabel sizeToFit];
        cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];
        [cell.timeLabel sizeToFit];
        
        [cell refresh:recent];
        tableCell = cell;
    }
    tableCell.layer.borderWidth = 0.5;
    tableCell.layer.borderColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return tableCell;
}


#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self.recentSessions addObject:recentSession];
    [self sort];
    [self refresh];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    for (NIMRecentSession *recent in self.recentSessions) {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId]) {
            [self.recentSessions removeObject:recent];
            break;
        }
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    [self refresh];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    //清理本地数据
    NSInteger index = [self.recentSessions indexOfObject:recentSession];
    [self.recentSessions removeObjectAtIndex:index];
    
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession)
    {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                          completion:nil];
    }
    [self refresh];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self refresh];
}

- (void)allMessagesDeleted{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self refresh];
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        [self refresh];
    }
}

#pragma mark - Override
- (void)onSelectedAvatar:(NSString *)userId
             atIndexPath:(NSIndexPath *)indexPath{};

- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath{
    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recentSession.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    }else{
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    }
}

- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSString *content = [self messageContent:recent.lastMessage];
    return [[NSAttributedString alloc] initWithString:content ?: @""];
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
    return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
}

#pragma mark - Misc

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.recentSessions.count;
    }
}

- (void)sort{
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NIMRecentSession *recent = self.recentSessions[indexPath.row - 1];//有在办项目
    [self onSelectedAvatar:recent atIndexPath:indexPath];
}



#pragma mark - Private
- (NSString *)messageContent:(NIMMessage*)lastMessage{
    NSString *text = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
        case NIMMessageTypeNotification:{
            return [self notificationMessageContent:lastMessage];
        }
        case NIMMessageTypeFile:
            text = @"[文件]";
            break;
        case NIMMessageTypeTip:
            text = lastMessage.text;
            break;
        case NIMMessageTypeRobot:
            text = [self robotMessageContent:lastMessage];
            break;
        default:
            text = @"[未知消息]";
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip)
    {
        return text;
    }
    else
    {
        NSString *from = lastMessage.from;
        if (lastMessage.messageType == NIMMessageTypeRobot)
        {
            NIMRobotObject *object = (NIMRobotObject *)lastMessage.messageObject;
            if (object.isFromRobot)
            {
                from = object.robotId;
            }
        }
        NSString *nickName = [NIMKitUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage{
    NIMNotificationObject *object = lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            return @"[讨论组信息更新]";
        }else{
            return @"[群信息更新]";
        }
    }
    return @"[未知消息]";
}

- (NSString *)robotMessageContent:(NIMMessage *)lastMessage{
    NIMRobotObject *object = lastMessage.messageObject;
    if (object.isFromRobot)
    {
        return @"[机器人消息]";
    }
    else
    {
        return lastMessage.text;
    }
}


#pragma mark - Notification
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}

- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}

- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification{
    [self refresh];
}



@end

