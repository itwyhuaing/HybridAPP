//
//  PersonMainViewController.m
//  hinabian
//
//  Created by 余坚 on 15/6/11.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "PersonMainViewController.h"
#import "PersonalHeadTableViewCell.h"
#import "PersonalHeadWithNoLogin.h"
#import "PersionalItemTableViewCell.h"
#import "DataFetcher.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "PersonalInfoViewController.h"
#import "SetOperationViewController.h"
#import "MyQuestionViewController.h"
#import "MyTribeViewController.h"
#import "CouponViewController.h"
#import "TipMaskView.h"
#import "PersonalInfo.h"
#import "IdeaBackViewController.h"
#import "NewsCenterModel.h"
#import "FunctionTipView.h"
#import "PersonalityNoticeTableViewCell.h"
#import "ThirdPartCompleteUserInfoViewController.h"
#import "IdeaBackNewViewController.h"
#import "PostingViewController.h"

@interface PersonMainViewController ()<UITableViewDelegate,UITableViewDataSource,TipMaskViewDelegate,FunctionTipViewDelegate>
{
    NSNumber * qaNotice;
    NSNumber * tribeNotice;
    NSNumber * personMsg;
    NSNumber * follow;
    NSNumber * coupon;
    
    NSTimer *alertTimer;
}
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) PersonalInfo * UserInfo;
@property (strong, nonatomic) UIButton * loginButton;
@property (nonatomic,strong) TipMaskView *firstTipView;
@property (nonatomic,strong) TipMaskView *secondTipView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSArray *messagesData;
@property (nonatomic,strong) UILabel *flag;
@property (nonatomic) BOOL isFlag;
@property (nonatomic) BOOL isShowAlert;

@property (nonatomic,strong) UIImageView *feedBackImgView;

//@property (nonatomic,strong) HNBTipMask *enterMask;
@property (nonatomic,strong) FunctionTipView *enterMask;

@end

#define  LOGIN_BUTTON_SIZE 80

@implementation PersonMainViewController

enum Cell_Item_Name
{
    ITEM_SYSTEM_HEAD = 0,
    ITEM_BINDING_PHONE,
    ITEM_MATCH_PROJECT,
    ITEM_GOON_PROJECT,
    ITEM_GAP_ONE,
    ITEM_MY_TRIBE,
    ITEM_MY_QUESTION,
    ITEM_MY_CARE,
    ITEM_MY_COLLECT,
    ITEM_GAP_TWO,
    ITEM_MY_COUPON,
    ITEM_RECOMMEND_GIFT,
    ITEM_GAP_THREE,
    ITEM_USER_FEEDBACK = 13,
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        if ([HNBUtils isLogin]) {
//            self.title = @"我的";
//        }else{
//            self.title = @"未登录";
//        }
        self.title = @"我的";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor DDNormalBackGround]];
    // Do any additional setup after loading the view.
    self.title = @"";
    
    CGRect tableviewRect = [UIScreen mainScreen].bounds;
    tableviewRect.size.height -= SCREEN_TABHEIGHT;
    
    self.tableView = [[UITableView alloc]initWithFrame:tableviewRect];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake( -(SCREEN_NAVHEIGHT + SCREEN_STATUSHEIGHT), 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
    [self registerCellPrototype];
    
    self.loginButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - LOGIN_BUTTON_SIZE / 2,SCREEN_HEIGHT / 2, LOGIN_BUTTON_SIZE, LOGIN_BUTTON_SIZE)];
    
    self.loginButton.backgroundColor = [UIColor whiteColor];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.loginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(0,2, 0, 0);
    self.loginButton.layer.cornerRadius = self.loginButton.bounds.size.width / 2;
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(touchRegister) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.hidden = TRUE;
    self.loginButton.enabled = FALSE;
    [self.view addSubview:self.loginButton];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    //    // 新功能提醒
    //    _enterMask = [[HNBTipMask alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    _enterMask.delegate = self;
}

-(void)updateTime
{
    NSString *first_load = [HNBUtils sandBoxGetInfo:[NSString class] forKey:user_first_load_person];
    if ([first_load isEqualToString:@"1"]) {
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo *userInfo = nil;
        NSString *phoneNum;
        if (tmpPersonalInfoArry.count != 0) {
            userInfo = tmpPersonalInfoArry[0];
            phoneNum = userInfo.mobile_num;
            if ([phoneNum isEqualToString:@""]) {    //如果没有绑定手机
                _isShowAlert = YES;
                
            }else{
                _isShowAlert = NO;
            }
        }else {
            _isShowAlert = NO;
        }
        if (_isShowAlert) {
            [self.tableView beginUpdates];
            PersonalityNoticeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:ITEM_BINDING_PHONE inSection:0]];
            [cell setItemShow:TRUE];
            [self.tableView endUpdates];
        }else{
            PersonalityNoticeTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            [cell setItemShow:FALSE];
            [self.tableView reloadData];
        }
        
        if ([alertTimer isValid]) {
            [alertTimer invalidate];
        }
    }
    
}

-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalHeadTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalHeadTableViewCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalItemCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalItemCell];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalHeadWithNoLogin bundle:nil] forCellReuseIdentifier:cellNibName_PersonalHeadWithNoLogin];
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalityNoticeTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalityNoticeTableViewCell];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchLevel) name:USERINFO_LEVELBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchEnergy) name:USERINFO_ENERGYBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchV) name:USERINFO_VBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeBindingAlert:) name:BINDING_PHONENUM_CANCEL object:nil];
    
    _isFlag = NO;
//    // 消息中心,信封状态标记
//    if ([HNBUtils isLogin]) {
//        [self updateMesssagesCenterFlag];
//    }
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:FALSE animated:NO];
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor DDNavBarBlue]}];
    
    // 个人设置
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"person_setting"]forState:UIControlStateNormal];
    [button addTarget:self action:@selector(entrySetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButton;
    
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];

    // 登录状态下  数据刷新
    if ([HNBUtils isLogin]) {
        
        [HNBUtils uploadAssessRlt];
        
        // 确保用户登录状态下 个人信息不为空
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        if (tmpPersonalInfoArry.count <= 0) {
            [DataFetcher doVerifyUserInfo:^(id JSON) {
                
                int state = [[JSON valueForKey:@"state"] intValue];
                if (state != 0) {
                    //显示HUD
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"登录失效请重新登录" afterDelay:DELAY_TIME style:HNBToastHudFailure];
                }
                else
                {
                    //保存用户数据到本地
                    
                    id data = [JSON valueForKey:@"data"];
                    if (![[data objectForKey:@"im_nation"] isEqualToString:@""]) {
                        [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_nation"] forKey:IM_NATION_LOCAL];
                    }
                    if (![[data objectForKey:@"im_state"] isEqualToString:@""]) {
                        [HNBUtils sandBoxSaveInfo:[data objectForKey:@"im_state"] forKey:IM_INTENTION_LOCAL];
                        [HNBUtils sandBoxSaveInfo:[data objectForKey:@"is_assess"] forKey:USER_ASSESSED_IMMIGRANT];
                    }
                }
                
                [self.tableView reloadData];
                [self updateUserInfoMsgAboutProQACOU];

                
            } withFailHandler:^(id error) {
                [self updateUserInfoMsgAboutProQACOU];
            }];
            
        }else{
            
            // 如果有数据及时显示出用户信息
            [self updateUserInfoMsgAboutProQACOU];
            [self.tableView reloadData];
        }
        
    }else{
        
        qaNotice = [NSNumber numberWithInt:0];
        tribeNotice = [NSNumber numberWithInt:0];
        personMsg = [NSNumber numberWithInt:0];
        follow = [NSNumber numberWithInt:0];
        [[self rdv_tabBarItem] setBadgeValue:@""];
        [self.tableView reloadData];
        
    }
    [MobClick beginLogPageView:@"person"];
    
    if ([HNBUtils isBindingPhoneNumAlertShow]) {    //如果关闭提示超过了一天才开始判断是否再次显示
        alertTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    }
    
}

// 及时更新底部Tab信息数及cell消息数
- (void)updateUserInfoMsgAboutProQACOU{
    
    [DataFetcher doGetAllNotices:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            id jsonmain = [JSON valueForKey:@"data"];
            qaNotice = [jsonmain valueForKey:@"qa"];
            tribeNotice =  [jsonmain valueForKey:@"tribe"];
            personMsg = [jsonmain valueForKey:@"msg"];
            follow = [jsonmain valueForKey:@"follow"];
            coupon = [jsonmain valueForKey:@"coupon"];
            NSInteger count = [qaNotice integerValue];
            NSInteger tmpCount = [tribeNotice integerValue];
            NSInteger followInt = [follow integerValue];
            NSInteger couponInt = [coupon integerValue];
            count += tmpCount;
            //NSInteger personMsgInt = [personMsg integerValue];
            //count += personMsgInt;
            count += followInt;
            count += couponInt;
            [[self rdv_tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%ld",count]];
            
            [self.tableView reloadData];
        }
    } withFailHandler:^(id error) {
        
    }];
    
}

// 及时更新信封消息
- (void)updateMesssagesCenterFlag{
    
    
    [DataFetcher doGetNewsCenterData:^(id JSON) {
        
        _messagesData = (NSArray *)JSON;
        NSInteger coun = 0;
        for (NewsCenterModel *f in _messagesData) {
            NSInteger n = [f.noctice_num integerValue];
            coun += n;
        }
        if (coun > 0) {
            _isFlag = YES;
        }else{
            _isFlag = NO;
        }
        
        _flag.hidden = !_isFlag;
    } withFailHandler:^(id error) {
        
        _isFlag = NO;
        _flag.hidden = !_isFlag;
        
    }];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 新功能介绍
    NSString *first_load = [HNBUtils sandBoxGetInfo:[NSString class] forKey:user_first_load_person];
    if (![first_load isEqualToString:@"1"]) {

        //self.tableView.scrollEnabled = NO; 2016移民节版本新功能提醒
        //[self showFirstTipView];
        [self showNewFunctionFeedBack];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"person"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFO_LEVELBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFO_ENERGYBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFO_VBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BINDING_PHONENUM_CANCEL object:nil];
    
    // 离开前确保新功能提醒不在弹出
    //    if (_enterMask != nil) {
    //        [_enterMask removeFromSuperview];
    //        _enterMask = nil;
    //    }
    //    if (_feedBackImgView != nil) {
    //        [_feedBackImgView removeFromSuperview];
    //        _feedBackImgView = nil;
    //    }
    //    [HNBUtils sandBoxSaveInfo:@"1" forKey:user_first_load_person];
    
    if (_enterMask != nil) {
        [_enterMask removeFromSuperview];
    }
    [HNBUtils sandBoxSaveInfo:@"1" forKey:user_first_load_person];
    
    if ([alertTimer isValid]) {
        [alertTimer invalidate];
    }
    
}

#pragma mark ------ 点击事件

- (void)entrySetting{
    [HNBClick event:@"102012" Content:nil];
    SetOperationViewController* vc = [[SetOperationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void) editPersonalInfo
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void) touchEnergy
{
    [HNBClick event:@"102003" Content:nil];
    //我的能量页
    NSString *tmpString = [NSString stringWithFormat:@"%@/native/myenergy",H5URL];
 
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:tmpString ctle:@"1" csharedBtn:@"0" ctel:@"0" cfconsult:@"0"];
    vc.manualRefreshWhenBack = FALSE;
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) touchLevel
{
    [HNBClick event:@"102001" Content:nil];
    //我的等级页
 
    
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/native/mylevel",H5URL]
                                                   ctle:@"1"
                                             csharedBtn:@"0"
                                                   ctel:@"0"
                                              cfconsult:@"0"];
    vc.manualRefreshWhenBack = FALSE;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void) touchV
{
    [HNBClick event:@"102002" Content:nil];
    //官方认证页
 
    SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
    vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/native/official_cert",H5URL]
                                                   ctle:@"1"
                                             csharedBtn:@"0"
                                                   ctel:@"0"
                                              cfconsult:@"0"];
    vc.manualRefreshWhenBack = FALSE;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) touchRegister
{
    
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [DataFetcher doLogOff:^(id JSON) {
            
        } withFailHandler:^(id error) {
            
        }];
        [self.tableView reloadData];
        UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        v.backgroundColor = [UIColor clearColor];
        [v setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [v addTarget:self action:@selector(touchRegister) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:v];
        self.navigationItem.rightBarButtonItem = barButton;
        
    }
    
}

-(void)closeBindingAlert:(NSNotification *)notification
{
    _isShowAlert = NO;
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time=[dat timeIntervalSince1970];
    [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%f",time] forKey:BINDING_PHONENUM_CANCEL_TIME];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ITEM_USER_FEEDBACK + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCellPtr;
    
    if(indexPath.row == ITEM_SYSTEM_HEAD){
        /*未登录与已登录做两种样式处理*/
        if (![HNBUtils isLogin]) {
            /* 未登录的处理 */
            PersonalHeadWithNoLogin *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalHeadWithNoLogin];
            cell.superController = self;
            cell.editButton.hidden = TRUE;
            returnCellPtr = cell;
        }
        else
        {
            PersonalHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalHeadTableViewCell];
            cell.superController = self;
            NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
            
            if (tmpPersonalInfoArry.count != 0) {
                
                self.UserInfo = tmpPersonalInfoArry[0];
                [cell setUserinfo:self.UserInfo];
            }else{
                [cell setUserinfoWithoutNetWorking:[HNBUtils sandBoxGetInfo:[NSDictionary class] forKey:PERSONAL_LOCAL_INFO]];
            }
            
            returnCellPtr = cell;
        }
        
    }
    else if(indexPath.row == ITEM_BINDING_PHONE)
    {
        
        PersonalityNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalityNoticeTableViewCell];
        [cell setPersonalityNoticeItem:@"为提升账号的安全性，请尽快绑定手机号" stringColor:[UIColor colorWithRed:254/255.0f green:136/255.0f blue:40/255.0f alpha:1.0f] BackGroundColor:[UIColor colorWithRed:255/255.0f green:241/255.0f blue:186/255.0f alpha:1.0f] Type:nil];
        if (_isShowAlert) {
            [cell setItemShow:TRUE];
        }else{
            [cell setItemShow:FALSE];
        }
        returnCellPtr = cell;
    }
    else if(indexPath.row == ITEM_GAP_ONE || indexPath.row == ITEM_GAP_TWO || indexPath.row == ITEM_GAP_THREE || indexPath.row == ITEM_MY_QUESTION)
    { // 空
        returnCellPtr = [[UITableViewCell alloc] init];
        returnCellPtr.backgroundColor = [UIColor DDR245_G245_B245ColorWithalph:1.0];
    }
    else{
        
        PersionalItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalItemCell];
        
        switch (indexPath.row) {
            case ITEM_MATCH_PROJECT: // 1
                [cell setDataForItem:@"我的评估" IconImage:@"person_match_project" hideNotice:Nil];
                break;
            case ITEM_GOON_PROJECT: // 2
                [cell setDataForItem:@"在办项目" IconImage:@"person_goon_project" hideNotice:Nil];
                break;
            case ITEM_MY_TRIBE: // 4
                if ([tribeNotice isEqualToNumber:[[NSNumber alloc] initWithInt:0]] || tribeNotice == nil) {
                    [cell setDataForItem:@"我的圈子" IconImage:@"person_tribe" hideNotice:Nil];
                }
                else
                {
                    [cell setDataForItem:@"我的圈子" IconImage:@"person_tribe" hideNotice:[NSString stringWithFormat:@"%@",tribeNotice]];
                }
                
                break;
            /**
             case ITEM_MY_QUESTION: // 5
             if ([qaNotice isEqualToNumber:[[NSNumber alloc] initWithInt:0]] || qaNotice == nil) {
             [cell setDataForItem:@"我的问答" IconImage:@"person_qa" hideNotice:Nil];
             }
             else
             {
             [cell setDataForItem:@"我的问答" IconImage:@"person_qa" hideNotice:[NSString stringWithFormat:@"%@",qaNotice]];
             }
             break;
             */
            case ITEM_MY_CARE: // 6
                if ([follow isEqualToNumber:[[NSNumber alloc] initWithInt:0]] || follow == nil) {
                    [cell setDataForItem:@"我的关注" IconImage:@"person_care" hideNotice:Nil];
                }
                else
                {
                    [cell setDataForItem:@"我的关注" IconImage:@"person_care" hideNotice:[NSString stringWithFormat:@"%@",follow]];
                }
                break;
            case ITEM_MY_COLLECT: // 7
                [cell setDataForItem:@"我的收藏" IconImage:@"person_collect" hideNotice:Nil];
                break;
            case ITEM_MY_COUPON:  // 9
                if ([coupon isEqualToNumber:[[NSNumber alloc] initWithInt:0]] || coupon == nil) {
                    [cell setDataForItem:@"优惠券" IconImage:@"person_coupon" hideNotice:Nil];
                }
                else
                {
                    [cell setDataForItem:@"优惠券" IconImage:@"person_coupon" hideNotice:[NSString stringWithFormat:@"%@",coupon]];
                }
                
                break;
            case ITEM_RECOMMEND_GIFT:
                [cell setDataForItem:@"推荐有礼" IconImage:@"person_gift" hideNotice:nil];
                break;
            case ITEM_USER_FEEDBACK:  // 13
                [cell setDataForItem:@"用户反馈" IconImage:@"person_feedback" hideNotice:nil];
                break;
            default:
                break;
        }
        returnCellPtr = cell;
        returnCellPtr.layer.borderWidth = 0.5;
        //returnCellPtr.layer.borderColor = [[UIColor DDNormalBackGround] CGColor];
        returnCellPtr.layer.borderColor = [[UIColor DDIMAssessQuestionnaireHeadBgViewColor] CGColor];
        returnCellPtr.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    returnCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCellPtr;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == ITEM_SYSTEM_HEAD){
        if (![HNBUtils isLogin]) {
            return [PersonalHeadWithNoLogin getHeight];
        }else{
            return [PersonalHeadTableViewCell getHeight];
        }
        
    }else if(indexPath.row == ITEM_GAP_ONE || indexPath.row == ITEM_GAP_TWO || indexPath.row == ITEM_GAP_THREE){
        
        return 10;
        
    }
    if (indexPath.row == ITEM_BINDING_PHONE) {
        if (_isShowAlert) {
            return 35;
        }else{
            return 0;
        }
    }
    
    // v2.9.5 移除该模块
    if (indexPath.row == ITEM_MY_QUESTION) {
        return 0.0;
    }
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == ITEM_GAP_ONE || indexPath.row == ITEM_GAP_TWO || indexPath.row == ITEM_GAP_THREE){
        return;
    }
    
    // 友盟统计－点击事件
    if(indexPath.row == ITEM_MY_CARE)
    {
        [HNBClick event:@"102025" Content:nil];
        NSDictionary *dic = @{@"type":@"我的关注"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_MY_QUESTION)
    {
        [HNBClick event:@"102024" Content:nil];
        NSDictionary *dic = @{@"type":@"我的问答"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_MY_TRIBE)
    {
        [HNBClick event:@"102023" Content:nil];
        NSDictionary *dic = @{@"type":@"我的圈子"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_GOON_PROJECT)
    {
        [HNBClick event:@"102022" Content:nil];
        NSDictionary *dic = @{@"type":@"在办项目"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_MATCH_PROJECT)
    {
        [HNBClick event:@"102021" Content:nil];
        NSDictionary *dic = @{@"type":@"我的评估"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_MY_COUPON)
    {
        [HNBClick event:@"102026" Content:nil];
        NSDictionary *dic = @{@"type":@"优惠券"};
        [MobClick event:@"clickPersonMainCell" attributes:dic];
    }
    else if(indexPath.row == ITEM_RECOMMEND_GIFT)
    {
        [HNBClick event:@"102030" Content:nil];
    }
    else if(indexPath.row == ITEM_USER_FEEDBACK)
    {
        [HNBClick event:@"102027" Content:nil];
    }
    else if (indexPath.row == ITEM_MY_COLLECT)
    {
        [HNBClick event:@"102031" Content:nil];
    }
    else if(indexPath.row == ITEM_SYSTEM_HEAD)
    {
        [HNBClick event:@"102013" Content:nil];
    }
    else if (indexPath.row == ITEM_BINDING_PHONE)
    {
        [HNBClick event:@"102036" Content:nil];
    }
    
    
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if(indexPath.row == ITEM_SYSTEM_HEAD)
    {
        PersonalInfoViewController * vc = [[PersonalInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == ITEM_BINDING_PHONE)
    {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval time=[dat timeIntervalSince1970];
        [HNBUtils sandBoxSaveInfo:[NSString stringWithFormat:@"%f",time] forKey:BINDING_PHONENUM_CANCEL_TIME];
        _isShowAlert = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        //假如没有绑定手机
        ThirdPartCompleteUserInfoViewController * vc = [[ThirdPartCompleteUserInfoViewController alloc] init];
        //判断是否从找回密码界面进入
        [vc setIsFindPWD:FALSE];
        //判断是否第三方登录注册界面进入
        [vc isRegister:FALSE];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_MATCH_PROJECT)
    {
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForMyAssession]
                                                                ctle:@"1"
                                                          csharedBtn:@"0"
                                                                ctel:@"0"
                                                           cfconsult:@"0"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_GOON_PROJECT)
    {
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForProjectOnHandling]
                                                                ctle:@"1"
                                                          csharedBtn:@"0"
                                                                ctel:@"1"
                                                           cfconsult:@"0"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_MY_TRIBE)
    {
        MyTribeViewController* vc = [[MyTribeViewController alloc] init];
        vc.manualPushWhenLoading = FALSE;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_MY_QUESTION)
    {
        MyQuestionViewController* vc = [[MyQuestionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_MY_CARE)
    {
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForMyAttention]
                                                                ctle:@"1"
                                                          csharedBtn:@"0"
                                                                ctel:@"0"
                                                           cfconsult:@"0"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == ITEM_MY_COLLECT)
    {
        //
        //NSLog(@"--- 我的收藏 ---");
        
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForMyCollection]
                                                                ctle:@"1"
                                                          csharedBtn:@"0"
                                                                ctel:@"0"
                                                           cfconsult:@"0"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_MY_COUPON)
    {
        CouponViewController* vc = [[CouponViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == ITEM_RECOMMEND_GIFT){ // 推荐有礼
        
        NSArray *tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        NSString *phoneNum = nil;
        PersonalInfo *UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
            phoneNum = UserInfo.mobile_num;
        }
        if ([phoneNum isEqualToString:@""] || phoneNum == nil) {   //判断用户有无绑定手机号
            [[HNBToast shareManager] toastWithOnView:nil msg:@"绑定手机才能分享拿收益" afterDelay:1.5f style:HNBToastHudFailure];
            //假如没有绑定手机
            ThirdPartCompleteUserInfoViewController * vc = [[ThirdPartCompleteUserInfoViewController alloc] init];
            //判断是否从找回密码界面进入
            vc.isFindPWD = FALSE;
            //判断是否第三方登录注册界面进入
            [vc isRegister:FALSE];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            
            SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
            vc.URL = [vc.webManger configNativeNavWithURLString:[NSString stringWithFormat:@"%@/%@",H5URL,TheURLForgiftOfRecommand]
                                                                    ctle:@"1"
                                                              csharedBtn:@"1"
                                                                    ctel:@"0"
                                                               cfconsult:@"0"];
            
            if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:Personal_Recommend_URL] && ![[HNBUtils sandBoxGetInfo:[NSString class] forKey:Personal_Recommend_URL] isEqualToString:@""]) {
                NSString* tmpURLString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:Personal_Recommend_URL];
                vc.URL = [[NSURL alloc] withOutNilString:tmpURLString];
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    else if(indexPath.row == ITEM_USER_FEEDBACK)
    {

        IdeaBackNewViewController *vc = [[IdeaBackNewViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    NSArray *visibleCells = [self.tableView visibleCells];
    for (id cell in visibleCells) {
        if([cell isKindOfClass:[PersonalHeadTableViewCell class]]){
            PersonalHeadTableViewCell *personalHeadCell = (PersonalHeadTableViewCell *)cell;
            [personalHeadCell didScroll:scrollView.contentOffset.y];
        }else if([cell isKindOfClass:[PersonalHeadWithNoLogin class]]){
            PersonalHeadWithNoLogin *personalHeadCell = (PersonalHeadWithNoLogin *)cell;
            [personalHeadCell didScroll:scrollView.contentOffset.y];
        }
        //        else if([cell isKindOfClass:[PersonalHeadWithNoCerCell class]]){
        //            PersonalHeadWithNoCerCell *personalHeadCell = (PersonalHeadWithNoCerCell *)cell;
        //            [personalHeadCell didScroll:scrollView.contentOffset.y];
        //        }
    }
}

#pragma mark - TipMaskViewDelegate
-(void)tipMaskViewPressedButton:(TipMaskView *)tipMaskView{
    [self clickToShowNextTipView:tipMaskView];
}

- (void)tipMaskViewPressedBackground:(TipMaskView *)tipMaskView{
    [self clickToShowNextTipView:tipMaskView];
}

#pragma mark - toolMethod
- (void)showFirstTipView{
    NSIndexPath *index_care = [NSIndexPath indexPathForRow:ITEM_MY_CARE inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:index_care];
    CGFloat y_max = SCREEN_HEIGHT - CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)-cellRect.size.height;
    if (cellRect.origin.y > y_max) { // 不同尺寸的设备下，保证cell 完全显示出来
        [self.tableView scrollToRowAtIndexPath:index_care atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        cellRect.origin.y = y_max;
    }
    _firstTipView = [[TipMaskView alloc] initWithFrame:CGRectZero message:@"点击这里查看我的关注" andButtonRect:cellRect textColor:nil bubbleColor:nil isCustom:FALSE image:nil];
    [self modifyTipView:_firstTipView];
    [[UIApplication sharedApplication].keyWindow addSubview:_firstTipView];
    
    [UIView animateWithDuration:0.01 animations:^{
        _firstTipView.alpha = 0.01f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6f animations:^{
            _firstTipView.alpha = 1.0f;
            // 3 秒之后显示第二张
            _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(endTimerToShowNextTipView) userInfo:nil repeats:NO];
            [_timer invalidate];
            _timer = nil;
        }];
    }];
}

- (void)showSecondTipView{
    
    NSIndexPath *index_coupon = [NSIndexPath indexPathForRow:ITEM_MY_COUPON inSection:0];
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:index_coupon];
    CGFloat y_max = SCREEN_HEIGHT - CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)-cellRect.size.height;
    if (cellRect.origin.y > y_max) { // 不同尺寸的设备下，保证cell 完全显示出来
        [self.tableView scrollToRowAtIndexPath:index_coupon atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        cellRect.origin.y = y_max;
    }
    _secondTipView = [[TipMaskView alloc] initWithFrame:CGRectZero message:@"点这可查看领取到的优惠券哦" andButtonRect:cellRect textColor:nil bubbleColor:nil isCustom:FALSE image:nil];
    [self modifyTipView:_secondTipView];
    [[UIApplication sharedApplication].keyWindow addSubview:_secondTipView];
    [UIView animateWithDuration:0.001 animations:^{
        _secondTipView.alpha = 0.01f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            _secondTipView.alpha = 1.0f;
        }];
    }];
}

- (void)modifyTipView:(TipMaskView *)tipView{
    tipView.delegate = self;
    tipView.popTipView.backgroundColor = [UIColor clearColor];
    tipView.popTipView.textColor = [UIColor whiteColor];
    tipView.popTipView.borderColor = [UIColor clearColor];
    tipView.alpha = 0.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:tipView];
}

- (void)endTimerToShowNextTipView{
    [_firstTipView removeFromSuperview];
    [self showSecondTipView];
}

- (void)clickToShowNextTipView:(TipMaskView *)tipMaskView{
    
    if (tipMaskView == _firstTipView) {
        if (_timer.isValid) {
            [_timer invalidate];
            _timer = nil;
        }
        [tipMaskView removeFromSuperview];
        [self showSecondTipView];
    }else{
        [tipMaskView removeFromSuperview];
        self.tableView.scrollEnabled = YES;
    }
}

#pragma mark ------ 用户反馈 新功能展示

- (void)showNewFunctionFeedBack{
    
    //    if (_enterMask != nil) {
    //
    //        NSIndexPath *index_feedBack = [NSIndexPath indexPathForRow:ITEM_USER_FEEDBACK inSection:0];
    //        CGRect cellRect = [_tableView rectForRowAtIndexPath:index_feedBack];
    //        CGFloat y_max = SCREEN_HEIGHT - CGRectGetHeight(self.rdv_tabBarController.tabBar.frame)- cellRect.size.height;
    //        if (cellRect.origin.y > y_max) { // 是否滚动
    //            [_tableView scrollToRowAtIndexPath:index_feedBack atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //            cellRect.origin.y = y_max;
    //        }
    //
    //        //    HNBTipMask *mask = [[HNBTipMask alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //        //    mask.delegate = self;
    //
    //        CGRect locationRect = cellRect;
    //
    //        CGRect imgRect = CGRectZero;
    //        imgRect.size.width = (356.0 / 2.0) * SCREEN_WIDTHRATE_6;
    //        imgRect.size.height = (269.0 / 2.0) *SCREEN_WIDTHRATE_6;
    //        imgRect.origin.x = SCREEN_WIDTH/2.0 - imgRect.size.width / 2.0;
    //        imgRect.origin.y = locationRect.origin.y - 9.0 * SCREEN_WIDTHRATE_6 - imgRect.size.height;
    //        _feedBackImgView = [[UIImageView alloc] initWithFrame:imgRect];
    //        [_feedBackImgView setImage:[UIImage imageNamed:@"newFunction_tip_feedback"]];
    //
    //        _enterMask.maskType = HNBTipMaskSquarType;
    //        _enterMask.superViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //        _enterMask.holeRect = locationRect;
    //        _enterMask.opaque = NO;
    //        _enterMask.backgroundColor = [UIColor clearColor];
    //
    //        [[UIApplication sharedApplication].keyWindow addSubview:_enterMask];
    //        [[UIApplication sharedApplication].keyWindow addSubview:_feedBackImgView];
    //
    //    }
    
    
    NSIndexPath *index_collect = [NSIndexPath indexPathForRow:ITEM_MY_COLLECT inSection:0];
    //NSIndexPath *index_feedBack = [NSIndexPath indexPathForRow:ITEM_USER_FEEDBACK inSection:0];
    CGRect cellRect = [_tableView rectForRowAtIndexPath:index_collect];
//    if (IS_IPHONE_X) {
//        //适配iphonex高度问题
//        cellRect.origin.y += SCREEN_STATUSHEIGHT/2;
//    }
    CGFloat y_max = SCREEN_HEIGHT - SCREEN_TABHEIGHT- cellRect.size.height;
    if (cellRect.origin.y > y_max) { // 是否滚动
        [_tableView scrollToRowAtIndexPath:index_collect atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        cellRect.origin.y = y_max;
    }
    
    CGRect locationRect = cellRect;
    CGRect imgRect = CGRectZero;
    imgRect.size.width = (356.0 / 2.0) * SCREEN_WIDTHRATE_6;
    imgRect.size.height = (269.0 / 2.0) *SCREEN_HEIGHTRATE_6;
    imgRect.origin.x = SCREEN_WIDTH/2.0 - imgRect.size.width / 2.0;
    imgRect.origin.y = locationRect.origin.y - 9.0 * SCREEN_HEIGHTRATE_6 - imgRect.size.height;
    
    _enterMask = [[FunctionTipView alloc] initWithHollowRectA:cellRect tipRectB:imgRect];
    _enterMask.delegate = self;
    _enterMask.shapeType = SquareType;
    _enterMask.lineType = SolidLineType;
    _enterMask.tipImageName = @"person_guide_collect";//@"newFunction_tip_feedback";
    [[UIApplication sharedApplication].keyWindow addSubview:_enterMask];
    
}

//-(void)touchEventOnView:(HNBTipMask *)tipView{
//
//    tipView.hidden = YES;
//    _feedBackImgView.hidden = YES;
//
//}

-(void)functionTipView:(FunctionTipView *)tipView didTouchEvent:(UITouch *)touch{
    
    [HNBUtils sandBoxSaveInfo:@"1" forKey:user_first_load_person];
    
    [tipView removeFromSuperview];
    
}

@end




