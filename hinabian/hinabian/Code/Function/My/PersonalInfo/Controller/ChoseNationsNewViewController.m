//
//  ChoseNationsNewViewController.m
//  hinabian
//
//  Created by 余坚 on 17/4/14.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "ChoseNationsNewViewController.h"
#import "RDVTabBarController.h"
#import "NationCode.h"
#import "PersonalInfo.h"
#import "NationButtonView.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"

#define DistanceToBorder    15
#define BUTTON_WIDTH        (SCREEN_WIDTH - DistanceToBorder*(COUNT_IN_ONE_ROW+1))/COUNT_IN_ONE_ROW
#define TITLE_LABEL_DISTANCE_FROM_TOP  35
#define NATION_BUTTON_DISTANCE_FROM_TOP 96

@interface ChoseNationsNewViewController ()<NationButtonViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) NationButtonView *nationView;
@property (nonatomic, strong) UIView            *sureView;
@property (nonatomic, strong) UIButton          *sureButton;
@end

static const float kSureViewHeight   = 65.f;
static const float kCornerRadius     = 6.f;

@implementation ChoseNationsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"选择意向国家";
    [self setLayout];
}

- (void) setLayout
{
    CGRect frame = CGRectZero;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - kSureViewHeight - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    /*title*/
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    titleLabel.text = @"您最关注哪些国家?";
    [titleLabel setCenter:CGPointMake(SCREEN_WIDTH/2, 35+16)];
    
    UILabel *secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    [secondTitleLabel setTextColor:[UIColor DDCouponTextGray]];
    [secondTitleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [secondTitleLabel setTextAlignment:NSTextAlignmentCenter];
    secondTitleLabel.text = @"(可选择1-3个)";
    [secondTitleLabel setCenter:CGPointMake(SCREEN_WIDTH/2, 72)];
    
    [_scrollView addSubview:titleLabel];
    [_scrollView addSubview:secondTitleLabel];
    /*完成*/
    frame.origin.x = 0;
    frame.origin.y = SCREEN_HEIGHT - kSureViewHeight - SCREEN_NAVHEIGHT - SCREEN_STATUSHEIGHT - SUIT_IPHONE_X_HEIGHT;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = kSureViewHeight;
    _sureView = [[UIView alloc]initWithFrame:frame];
    _sureView.backgroundColor = [UIColor whiteColor];
    
    frame.origin.x = DistanceToBorder;
    frame.origin.y = 10;
    frame.size.width = SCREEN_WIDTH - DistanceToBorder * 2;
    frame.size.height = kSureViewHeight - 10 * 2;
    _sureButton = [[UIButton alloc]initWithFrame:frame];
    [_sureButton setTitle:@"保存" forState:UIControlStateNormal];
    [_sureView addSubview:_sureButton];
    [self setUnableBtn:_sureButton];
    
    frame.origin.x = 0;
    frame.origin.y = NATION_BUTTON_DISTANCE_FROM_TOP;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - kSureViewHeight - 10 - NATION_BUTTON_DISTANCE_FROM_TOP;
    if(_nationsArray != nil)
    {
       _nationView = [[NationButtonView alloc] initAllShowWithFrame:frame andSelectedNation:_nationsArray];
    }
    else
    {
        _nationView = [[NationButtonView alloc] initWithFrame:frame];
    }
    
    _nationView.delegate = (id)self;
    
    [_scrollView addSubview:_nationView];
    
    [self.view addSubview:_scrollView];
    [self.view addSubview:_sureView];
    
    [self observeUserInfo];
    
}

- (void)setableBtn:(UIButton *)sender
{
    [sender addTarget:self action:@selector(changeSubmitMakeSure) forControlEvents:UIControlEventTouchUpInside];
    [sender setEnabled:YES];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor DDNavBarBlue];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
}

- (void)setUnableBtn:(UIButton *)sender
{
    [sender addTarget:self action:@selector(changeSubmitMakeSure) forControlEvents:UIControlEventTouchUpInside];
    [sender setEnabled:NO];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.backgroundColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    sender.layer.borderColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

-(void)observeUserInfo
{
    if(_nationView.selectedNationsCode.count != 0){
        [self setableBtn:_sureButton];
    }else{
        [self setUnableBtn:_sureButton];
    }
}

-(void) back_main
{
    [HNBClick event:@"159011" Content:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/* 弹出alter确认 */
- (void)changeSubmitMakeSure
{
    NSMutableArray *oldArray = [NSMutableArray arrayWithArray:_nationsArray];
    NSMutableArray *newArray = _nationView.selectedNationsCode;
    if ([self compareStrInOldArray:oldArray newArray:newArray] && oldArray.count!=0) {
        [HNBClick event:@"159013" Content:nil];
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"修改意向国家后首页将会优先推送修改后的国家内容，确定要继续修改吗？"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterview show];
    }else{
        [self changeSubmit];
    }
    
}

- (void)changeSubmit
{

    NSMutableArray *tmpMutableArry = [[NSMutableArray alloc] initWithArray:_nationView.selectedNationsCode];
    NSMutableArray * tmpArry = [[NSMutableArray alloc] initWithArray:_nationView.selectedNationString];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    UserInfo = tmpPersonalInfoArry[0];
    [DataFetcher doUpdateUserInfo:Nil NickName:Nil Motto:Nil Indroduction:Nil Hobby:Nil Im_state:Nil Im_nation:tmpMutableArry withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        NSLog(@"errCode = %d",errCode);
        if (errCode == 0) {
            
            NSString * tmpNationCN = @"";
            NSString * tmNationID = @"";
            for (int index = 0; index < tmpArry.count; index++) {
                tmpNationCN = [tmpNationCN stringByAppendingString:tmpArry[index]];
                if (index != (tmpArry.count - 1)) {
                    tmpNationCN = [tmpNationCN stringByAppendingString:@","];
                }
                
            }
            for (int index = 0; index < tmpMutableArry.count; index++) {
                tmNationID = [tmNationID stringByAppendingString:tmpMutableArry[index]];
                if (index != (tmpMutableArry.count - 1)) {
                    tmNationID = [tmNationID stringByAppendingString:@","];
                }
                
            }
            
            UserInfo.im_nation_cn = tmpNationCN;
            UserInfo.im_nation = tmNationID;
            [HNBUtils sandBoxSaveInfo:tmNationID forKey:IM_NATION_LOCAL];
            //[UserInfo save];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withFailHandler:^(NSError* error) {
        NSLog(@"errCode = %ld",(long)error.code);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"确定"]) {
        [HNBClick event:@"159015" Content:nil];
        [self changeSubmit];
        
    }
    else if([buttonTitle isEqualToString:@"取消"])
    {
        [HNBClick event:@"159014" Content:nil];
    }
}


-(void)clickNationButton
{
    [self observeUserInfo];
}

-(void)clickMoreButton
{
    /*点击更多数据上报*/
    [HNBClick event:@"159012" Content:nil];
}


/*对比两个数组的字符串*/
-(BOOL)compareStrInOldArray:(NSMutableArray *)oldArray newArray:(NSMutableArray *)newArray
{
    BOOL isChange = YES;
    [newArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 > obj2;
    }];
    [oldArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return obj1 > obj2;
    }];
    if (oldArray.count == newArray.count) {
        isChange = NO;
        for (int index = 0; index < oldArray.count; index++) {
            NSString *oldStr = oldArray[index];
            NSString *newStr = newArray[index];
            if (![oldStr isEqualToString:newStr]) {
                isChange = YES;
                return isChange;
            }
        }
    }
    return isChange;
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
