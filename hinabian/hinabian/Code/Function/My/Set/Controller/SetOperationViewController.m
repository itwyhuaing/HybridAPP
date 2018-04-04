

//
//  SetOperationViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/3.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "SetOperationViewController.h"
#import "RDVTabBarController.h"
#import "PersonalInfoItemTableViewCell.h"
#import "ThirdPartCompleteUserInfoViewController.h"
#import "WeSuperiorityViewController.h"
#import "SetPushViewController.h"
#import "LoginViewController.h"
#import "ChangePWDViewController.h"
#import "NewPwdViewController.h"
#import "IdeaBackViewController.h"
#import "PersonalInfo.h"
#import "DataFetcher.h"
#import <UShareUI/UShareUI.h>
#import "HNBToast.h"
#import "RDVTabBarItem.h"

#import "HNBFileManager.h"

@interface SetOperationViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSString * userInfTel;
    NSString * userInfMail;
    BOOL       isClearCaches;
    NSString *fileFolderSize;
}
@property (strong, nonatomic) UITableView * tableView;
@end

#define TABLEVIEW_DISTANCE_FROM_TOP 20
#define INPUT_ITEM_TO_EDGE 20

enum Cell_Item_Name
{
    ITEM_TEL = 1,
    ITEM_PWD = 2,
    ITEM_PUSH = 4,
    ITEM_EVALUATE = 6,
    ITEM_ABOUT = 7,
    ITEM_CACHE = 9,
    ITEM_QUIT = 11
};


@implementation SetOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    isClearCaches = NO;
    [self.view setBackgroundColor:[UIColor DDNormalBackGround]];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = (id)self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor];
    
    [self.view addSubview:self.tableView];
    
    [self registerCellPrototype];

}

-(void)registerCellPrototype
{
    [self.tableView registerNib:[UINib nibWithNibName:cellNibName_PersonalInfoItemTableViewCell bundle:nil] forCellReuseIdentifier:cellNibName_PersonalInfoItemTableViewCell];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchquitButton
{
    [HNBClick event:@"112017" Content:nil];
    
    NSString *alertMessage = [NSString stringWithFormat:@"退出海那边账号，将不能查看收藏、发布帖子、评论、问题等"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:(id)self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认退出", nil];
    [alertView show];
    
}

#pragma mark AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确认退出"]) {
        [HNBClick event:@"112018" Content:nil];
        
        [DataFetcher doLogOff:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withFailHandler:^(id error) {
            
        }];
    }else if([buttonTitle isEqualToString:@"取消"]) {
        [HNBClick event:@"112019" Content:nil];
        
        return;
    }
}


/* 跳入修改密码界面 */
-(void)jumpIntoChangePwd
{
    /* 判断电话是否绑定密码 */
    [DataFetcher doHasPWD:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0)
        {
            int pwdState= [[JSON valueForKey:@"data"] intValue];
            if (pwdState == 1) {
                ChangePWDViewController * vc = [[ChangePWDViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                NewPwdViewController * vc = [[NewPwdViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                NSLog(@"你没设置过密码");
            }
            
        }
    } withFailHandler:^(id error) {
        
    }];
}

#pragma mark ------ UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ITEM_QUIT + 1;
    
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat tmpH = 0.0;
    if (indexPath.row == 0) {
        
        tmpH = 12.0;
        
    } else if (indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 10){
        
        tmpH = 10.0;
        
    }else{
    
        tmpH = 44.0;
        
    }
    
    return tmpH;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *returnCellPtr;
    
    if (indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 10){
        returnCellPtr = [[UITableViewCell alloc] init];
        returnCellPtr.accessoryType = UITableViewCellAccessoryNone;
        returnCellPtr.backgroundColor = [UIColor clearColor];
    }
    else if (indexPath.row == ITEM_QUIT)
    {
        returnCellPtr = [[UITableViewCell alloc] init];
        returnCellPtr.accessoryType = UITableViewCellAccessoryNone;
        returnCellPtr.backgroundColor = [UIColor clearColor];
        
        if ([HNBUtils isLogin])
        {
            returnCellPtr.backgroundColor = [UIColor whiteColor];
            returnCellPtr.layer.borderWidth = 0.5;
            returnCellPtr.layer.borderColor = [[UIColor DDIMAssessQuestionnaireHeadBgViewColor] CGColor];
            
            UIButton * quitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
            [quitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [quitButton setTitleColor:[UIColor DDInputLightGray] forState:UIControlStateHighlighted];
            [quitButton addTarget:self action:@selector(touchquitButton) forControlEvents:UIControlEventTouchUpInside];
            [returnCellPtr addSubview:quitButton];
            
        }
    }
    else
    {
        PersonalInfoItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNibName_PersonalInfoItemTableViewCell];

        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo * UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
            userInfTel = UserInfo.mobile_num;
            userInfMail = UserInfo.email;
            
        }
        cell.layer.borderWidth = 0.3;
        cell.layer.borderColor = [[UIColor DDIMAssessQuestionnaireHeadBgViewColor] CGColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

        switch (indexPath.row) {
            case ITEM_TEL:
                if ([UserInfo.mobile_num isEqualToString:@""] || UserInfo.mobile_num == nil) {
                    [cell setTitleAndContent:@"绑定手机" content:@"绑定手机即可使用手机登录"];
                }
                else{
                    [cell setTitleAndContent:@"绑定手机" content:UserInfo.mobile_num];
                }
                break;
            case ITEM_PWD:
                [cell setTitleAndContent:@"修改密码" content:@"******"];
                break;
            case ITEM_PUSH:
                [cell setTitleAndContent:@"推送设置" content:@""];
                //NSLog(@"motto = %@",UserInfo.motto);
                break;
            case ITEM_EVALUATE:
                [cell setTitleAndContent:@"评价海那边" content:@""];
                break;
            case ITEM_ABOUT:
                [cell setTitleAndContent:@"关于海那边" content:[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
                break;
            case ITEM_CACHE:
                if (isClearCaches) {
                    [cell setTitleAndContent:@"清理缓存" content:@"0.00 MB"];
                }else{
                    //[cell setTitleAndContent:@"清理缓存" content:[HNBUtils sizeFormattedOfCache]];
                    [cell setTitleAndContent:@"清理缓存" content:@"0.00 MB"];
                    [HNBFileManager returnSizeAtFileFolder:HNBFileFoldersSet completeBlock:^(NSString *info) {
                        [cell setTitleAndContent:@"清理缓存" content:info];
                        fileFolderSize = info;
                    }];
                    
                }
                break;
                
            default:
                break;
                
        }
        returnCellPtr = cell;
        
        
    }
    returnCellPtr.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return returnCellPtr;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == ITEM_PWD)
    {
        [HNBClick event:@"112012" Content:nil];
        if (![HNBUtils isLogin])
        {
            LoginViewController * vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(![userInfTel isEqualToString:@""] || ![userInfMail isEqualToString:@""])
        {
            [self jumpIntoChangePwd];
        }
        else
        {
            /* 无绑定电话提示 */
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请先绑定手机" afterDelay:1.0 style:HNBToastHudFailure];
        }

    }
    else if(indexPath.row == ITEM_ABOUT)
    {
        [HNBClick event:@"112015" Content:nil];
        WeSuperiorityViewController * vc = [[WeSuperiorityViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_TEL)
    {
        [HNBClick event:@"112011" Content:nil];
        if (![HNBUtils isLogin])
        {
            LoginViewController * vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            //假如没有绑定手机
            ThirdPartCompleteUserInfoViewController * vc = [[ThirdPartCompleteUserInfoViewController alloc] init];
            //判断是否从找回密码界面进入
            vc.isFindPWD = FALSE;
            //判断是否第三方登录注册界面进入
            [vc isRegister:FALSE];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    else if (indexPath.row == ITEM_EVALUATE)
    {
        [HNBClick event:@"112014" Content:nil];
        [HNBUtils gotoAppStorePageRaisal];
    }
    else if(indexPath.row == ITEM_PUSH)
    {
        [HNBClick event:@"112013" Content:nil];
        SetPushViewController * vc = [[SetPushViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if(indexPath.row == ITEM_CACHE)
    {
        [HNBFileManager clearUpFileFolder:HNBFileFoldersSet];
        if (isClearCaches) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"成功为您清理0 MB缓存" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }else{
            [[HNBToast shareManager] toastWithOnView:nil msg:[NSString stringWithFormat:@"成功为您清理%@缓存",fileFolderSize] afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        }

        
//        NSString * cacheSize = [HNBUtils sizeFormattedOfCache];
//        [HNBUtils clearCachesDirectory];
//        if (isClearCaches) {
//            [[HNBToast shareManager] toastWithOnView:nil msg:@"成功为您清理0 MB缓存" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
//        }else{
//            [[HNBToast shareManager] toastWithOnView:nil msg:[NSString stringWithFormat:@"成功为您清理%@缓存",cacheSize] afterDelay:DELAY_TIME style:HNBToastHudSuccession];
//        }
        
        isClearCaches = YES;
        [_tableView reloadData];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
