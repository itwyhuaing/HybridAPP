//
//  ReplyDetailInfoController.m
//  hinabian
//
//  Created by hnbwyh on 16/11/14.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "ReplyDetailInfoController.h"
#import "RDVTabBarController.h"
#import "ReplyDetailInfoView.h"
#import "ReplyDetaiInfoDataManager.h"
#import "TribeDetailInfoCellManager.h"
#import "FloorCommentModel.h"
#import "FloorCommentReplyModel.h"
#import "FloorCommentUserInfoModel.h"
#import "UserInfoController2.h"
#import "LoginViewController.h"
#import "DownSheet.h"
#import "PersonalInfo.h"

#import "YYText.h"
#import "YYLabel.h"
#import "HTMLContentModel.h"

#import "DataFetcher.h"
#import "IQKeyboardManager.h"


@interface ReplyDetailInfoController () <ReplyDetailInfoViewDelegate,DownSheetDelegate>

@property (nonatomic,strong) ReplyDetailInfoView *replyDetailView;
@property (nonatomic,strong) ReplyDetaiInfoDataManager *dataManager;

@property (nonatomic,strong) NSMutableArray *downSheetModelDataSources;

@end

@implementation ReplyDetailInfoController

#pragma mark ------ life 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**<数据处理 与 视图>*/
    if (_manager != nil || _floorID != nil) {
        
        _dataManager = [[ReplyDetaiInfoDataManager alloc] init];
        /*适配Iphone_X*/
        _replyDetailView = [[ReplyDetailInfoView alloc] initWithFrame:CGRectMake(0,
                                                                                 0,
                                                                                 SCREEN_WIDTH,
                                                                                 SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SUIT_IPHONE_X_HEIGHT)];
        
        _replyDetailView.delegate = self;
        [self.view addSubview:_replyDetailView];
        
    }
    
    /**< 数据来源 >*/
    if (_manager != nil) {
        
        // push 进入该控制器时已经携带 manager
        [_replyDetailView reFreshViewWithData:_manager];
        
        
    } else if (_floorID != nil && _manager == nil){
        
        // push 进入该控制器时没有携带 manager , 此时需要做网络请求
        
        [_dataManager reqAllCommentsForTheFloorWithCommentId:_floorID successBlock:^(id data) {
            
            TribeDetailInfoCellManager *tmpManamger = (TribeDetailInfoCellManager *)data;
            _manager = tmpManamger;
            
            
            // 去除 点赞与评论的高度
            _manager.cellHeight -= (GAP_S + BUTTON_BIG_H);
            // 不显示 查看更多
            _manager.seeMoreHeight = 0;
            // 楼层回复数若多于5个，则重新计算cell高度
            if (_manager.model.reply_infoArr.count > DISPLAY_REPLY_MAXNUM) {
                
                for (NSInteger cou = DISPLAY_REPLY_MAXNUM; cou < _manager.model.reply_infoArr.count; cou ++) {
                    
                    NSValue *sizeValue = _manager.replyFloorCommentHeights[cou];
                    CGSize size = [sizeValue CGSizeValue];
                    _manager.cellHeight += size.height;
                    
                }
            }
            
            [_replyDetailView reFreshViewWithData:_manager];
            
            
        }];

        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    
    /**< 关闭IQKeyboardManager监听 >*/
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    if (_replyDetailView != nil) {
        
        /**< 增加监听，当键盘出现或改变时收出消息 >*/
        [[NSNotificationCenter defaultCenter] addObserver:_replyDetailView
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /**< 打开IQKeyboardManager监听 >*/
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    if (_replyDetailView != nil) {
    
        [[NSNotificationCenter defaultCenter] removeObserver:_replyDetailView
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
    
    }
    
}


#pragma mark ------ toolMethod 

- (void)setUpNav{
    
    self.title = @"回复详情";
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

- (void)back{

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ------ setter

-(void)setManager:(TribeDetailInfoCellManager *)manager{

    // 去除 点赞与评论的高度
    //manager.cellHeight -= (GAP_S + BUTTON_BIG_H);
    // 不显示 查看更多
    manager.seeMoreHeight = 0;
    // 楼层回复数若多于5个，则重新计算cell高度
    if (manager.model.reply_infoArr.count > DISPLAY_REPLY_MAXNUM) {
        
        for (NSInteger cou = DISPLAY_REPLY_MAXNUM; cou < manager.model.reply_infoArr.count; cou ++) {
            
            NSValue *sizeValue = manager.replyFloorCommentHeights[cou];
            CGSize size = [sizeValue CGSizeValue];
            manager.cellHeight += size.height;
            
        }
    }
    
    _floorID = manager.model.floorId;
    
    _manager = manager;
    
}

#pragma mark ------ ReplyDetailInfoViewDelegate

- (void)replyDetailInfoView:(ReplyDetailInfoView *)view didClickEvent:(id)eventSource info:(id)info{

        if ([eventSource isKindOfClass:[ReplyDetailInfoView class]]){
            
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
    
        NSString *infostring = (NSString *)info;
        if (infostring == nil || infostring .length <= 0) {
            return;
        }
    
        if ([eventSource isKindOfClass:[UITapGestureRecognizer class]]) {
            
            // icon - ReplyTableViewCellIconTag
            PersonalInfo *f = [PersonalInfo MR_findFirst];
            if ([infostring isEqualToString:f.id] || infostring == nil) {
                return;
            }
            UserInfoController2 *vc = [[UserInfoController2 alloc]init];
            vc.personid = infostring;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([eventSource isKindOfClass:[UIButton class]]) {
            
            
            _floorID = infostring;
            DownSheet *sheet = [[DownSheet alloc]initWithlist:self.downSheetModelDataSources height:0];
            sheet.delegate = self;
            [sheet showInView:self.view];
            
        }else if ([eventSource isKindOfClass:[NSString class]] && [infostring hasPrefix:@"CommentView_userName:"]){
            
            NSArray *strs = [infostring componentsSeparatedByString:@"CommentView_userName:"];
            NSString *personID = [strs lastObject];
            
            NSArray *personInfoArr = [PersonalInfo MR_findAll];
            PersonalInfo *f = [personInfoArr firstObject];
            if ([personID isEqualToString:f.id] || personID == nil) {
                return;
            }
            UserInfoController2 *vc = [[UserInfoController2 alloc]init];
            vc.personid = personID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([eventSource isKindOfClass:[NSString class]] && [infostring hasPrefix:@"hyper:"]){
            
            NSArray *strs = [infostring componentsSeparatedByString:@"hyper:"];
            NSString *hyper = [strs lastObject];
            hyper = [hyper stringByReplacingOccurrencesOfString:@"www" withString:@"m"];
            //hyper = [hyper stringByReplacingOccurrencesOfString:@"detail" withString:@"detailforapp"];
            [[HNBWebManager defaultInstance] jumpHandleWithURL:hyper nav:self.navigationController jumpIntoAPP:FALSE];
            
        }else if ([eventSource isKindOfClass:[UITextView class]]){
        
            
            NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
            PersonalInfo * UserInfo = nil;
            if (tmpPersonalInfoArry.count != 0) {
                
                UserInfo = [tmpPersonalInfoArry firstObject];
                //输入内容为空判断
                if([infostring isEqualToString:@""] || nil == infostring)
                {
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"对TA说点什么吧" afterDelay:1.0 style:HNBToastHudFailure];
                }
                else
                {
                    [DataFetcher doReplyPost:UserInfo.id TID:_themeId CID:_floorID content:infostring ImageList:nil withSucceedHandler:^(id JSON) {
                        int errCode = [[JSON valueForKey:@"state"] intValue];
                        NSLog(@"errCode = %d",errCode);
                        /* 跳回前向页面 */
                        if (errCode == 0) {
                            NSLog(@"发送成功");
                            
                            //本地 数据添加
                            FloorCommentReplyModel *tmpF = [[FloorCommentReplyModel alloc] init];
                            tmpF.u_info.name = UserInfo.name;
                            tmpF.u_info.id = UserInfo.id;
                            tmpF.show_time = @"刚刚";
                            tmpF.comment_id = _floorID;
                            tmpF.replyModel_id = @""; // 该条回复的 id 暂无
                            HTMLContentModel *f = [[HTMLContentModel alloc] init];
                            f.tagType = HTMLContentModelTagPText;
                            f.textString = infostring;
                            [tmpF.replyContentArr  addObject:f];
                            
                            [_manager.model.reply_infoArr addObject:tmpF];
                            NSInteger tmpCount = [_manager.model.replyTotal_UnderFloor integerValue];
                            _manager.model.replyTotal_UnderFloor = [NSString stringWithFormat:@"%ld",(long)tmpCount];
                            
                            CGSize size = [self caculateHeightForFloorContent:infostring font:REPLY_FLOOR_TEXT_FONT size:CGSizeMake(SCREEN_WIDTH - GAP_S * 4.0, 30)];
                            size.height += 50.f;
                            [_manager.replyFloorCommentHeights addObject:[NSValue valueWithCGSize:size]];
                            
                            _manager.cellHeight += size.height;
                            
                            // 回调界面处理
                            [_replyDetailView SuccessedSendInfo];
                            [_replyDetailView reFreshViewWithData:_manager];
                            
                        }
                        
                    } withFailHandler:^(NSError* error) {
                        
                        NSLog(@"errCode = %ld",(long)error.code);
                        [_replyDetailView failedSendInfo];
                        
                    }];
                }
                
            }

            
            
        }

}


#pragma mark ------ DownSheetDelegate

- (void)didSelectIndex:(NSInteger)index{

    DownSheetModel *f = self.downSheetModelDataSources[index];
    NSString *desc = f.title;
    [_dataManager reportWithType:@"tribe-comment" reportId:_floorID desc:desc];
    
}

#pragma mark ------ 懒加载

- (NSMutableArray *)downSheetModelDataSources{
    
    if (_downSheetModelDataSources == nil) {
        
        _downSheetModelDataSources = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"垃圾内容",@"虚假广告",@"色情暴力",@"政治敏感",@"恶意仇恨"];
        for (NSInteger cou = 0; cou < titles.count; cou ++) {
            
            DownSheetModel *f = [[DownSheetModel alloc] init];
            f.title = titles[cou];
            [_downSheetModelDataSources addObject:f];
            
        }
        
    }
    
    return _downSheetModelDataSources;
    
}

#pragma mark ------ 计算 YYLabel 高度

- (CGSize)caculateHeightForFloorContent:(NSString *)content font:(UIFont *)font size:(CGSize)size{
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    /**< 楼层评论高度计算 - 文本或图片 >*/
    
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:content];
    one.yy_font = font;
    one.yy_color = [UIColor DDR51_G51_B51ColorWithalph:1.0];
    one.yy_kern = [NSNumber numberWithFloat:KERN_SPACE];
    one.yy_lineSpacing = LINE_SPACE;
    [text appendAttributedString:one];
    
    YYLabel *label = [YYLabel new];
    label.userInteractionEnabled = YES;
    label.numberOfLines = 0;
    label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    label.size = size;
    label.attributedText = text;
    [label sizeToFit];
    //NSLog(@"label.size h : %f - w : %f",label.size.height,label.size.width);
    return label.size;
    
}

@end
