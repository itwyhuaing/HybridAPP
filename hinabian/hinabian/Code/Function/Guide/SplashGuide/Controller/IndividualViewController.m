//
//  IndividualViewController.m
//  hinabian
//
//  Created by 何松泽 on 17/4/13.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IndividualViewController.h"
#import "RDVTabBarController.h"
#import "NationCode.h"
#import "PersonalInfo.h"
#import "NationButtonView.h"
#import "HNBClick.h"


#define DistanceToBorder    15
#define COUNT_IN_ONE_ROW    3
#define BUTTON_WIDTH        (SCREEN_WIDTH - DistanceToBorder*(COUNT_IN_ONE_ROW+1))/COUNT_IN_ONE_ROW

static const float kCornerRadius     = 6.f;
static const float kSureViewHeight   = 65.f;

@interface IndividualViewController ()<NationButtonViewDelegate>
{
    UILabel *imStatusLabel;
    UILabel *nationLabel;
    NationButtonView *nationView;
}

@property (nonatomic, strong) NSMutableArray    *selectedIMStatus;
@property (nonatomic, strong) NSMutableArray    *imButtonArray;
@property (nonatomic, strong) UIScrollView      *scrollView;
@property (nonatomic, strong) UIImageView       *headImageView;
@property (nonatomic, strong) UIButton          *sureButton;
@property (nonatomic, strong) UIView            *sureView;
@property (nonatomic, strong) NSArray           *imStatusArray;

@end

@implementation IndividualViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HNBUtils sandBoxSaveInfo:@"1" forKey:JUDGE_INDIVIDUAL];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"";
    _imStatusArray      = @[@"想移民",@"已移民"];
    _selectedIMStatus   = [[NSMutableArray alloc] init];
    _imButtonArray      = [[NSMutableArray alloc] init];
    
    [self setLayout];
}

- (void)setLayout{
    CGRect frame = CGRectZero;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - kSureViewHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:frame];
    _scrollView.backgroundColor = [UIColor clearColor];
    
    
    /*头部图片*/
    frame.size.height = (SCREEN_WIDTH/750)*439;
    _headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page-individual"]];
    [_headImageView setFrame:frame];
    
    /*返回*/
    frame.size.width  = 40;
    frame.size.height = 40;
    frame.origin.y    = 15;
    UIButton *backBtn = [[UIButton alloc]initWithFrame:frame];
    [backBtn setImage:[UIImage imageNamed:@"btn_fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back_main) forControlEvents:UIControlEventTouchUpInside];
    
    frame.origin.x    = DistanceToBorder;
    frame.origin.y    = CGRectGetMaxY(_headImageView.frame) + 15;
    frame.size.height = 36.f;
    frame.size.width  = 250.f;
    imStatusLabel = [[UILabel alloc] initWithFrame:frame];
    imStatusLabel.text = @"1.您想了解哪个移民阶段的内容?";
    imStatusLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    
    /*完成*/
    frame.origin.x = 0;
    frame.origin.y = SCREEN_HEIGHT - kSureViewHeight;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = kSureViewHeight;
    _sureView = [[UIView alloc]initWithFrame:frame];
    _sureView.backgroundColor = [UIColor whiteColor];
    _sureView.layer.borderColor = [UIColor DDEdgeGray].CGColor;
    _sureView.layer.borderWidth = 0.5f;
    
    frame.origin.x = DistanceToBorder;
    frame.origin.y = 10;
    frame.size.width = SCREEN_WIDTH - DistanceToBorder * 2;
    frame.size.height = kSureViewHeight - 10 * 2;
    _sureButton = [[UIButton alloc]initWithFrame:frame];
    [_sureButton setTitle:@"前往专属首页" forState:UIControlStateNormal];
    [self setUnableBtn:_sureButton];
    [self addIMButton];
    [self setNationLayout];
    
    [_sureView addSubview:_sureButton];
    [_scrollView addSubview:_headImageView];
    [_scrollView addSubview:imStatusLabel];
    [self.view addSubview:_scrollView];
    [self.view addSubview:_sureView];
    // v2.9.5 移除返回按钮
    //[self.view addSubview:backBtn];
}

- (void)addIMButton
{
    for (int index = 0; index < _imStatusArray.count; index++) {
        UIButton * tmpButton = [[UIButton alloc] init];
        tmpButton.frame = CGRectMake(
                                     ((index % COUNT_IN_ONE_ROW) + 1)*DistanceToBorder + (index % COUNT_IN_ONE_ROW)* BUTTON_WIDTH,
                                     CGRectGetMaxY(imStatusLabel.frame) + (index / COUNT_IN_ONE_ROW)*10 + 8 + (index / COUNT_IN_ONE_ROW)* 36,
                                     BUTTON_WIDTH,
                                     36
                                     );
        [tmpButton setTitle:_imStatusArray[index] forState:UIControlStateNormal];
        tmpButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
        tmpButton.titleLabel.numberOfLines = 2;
        [self setOriginalBtn:tmpButton];
        [tmpButton addTarget:self action:@selector(clickIMButton:) forControlEvents:UIControlEventTouchUpInside];
        [_imButtonArray addObject:tmpButton];
        [_scrollView addSubview:tmpButton];
    }
    
    NSString *tmpImIntention = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL];
    if(tmpImIntention != nil)
    {
        tmpImIntention = [self CodeForIMStateForString:tmpImIntention];
        for (UIButton *tmpButton in _imButtonArray) {
            if ([[tmpButton titleForState:UIControlStateNormal] isEqualToString:tmpImIntention]) {
                [self clickIMButton:tmpButton];
            }
        }
    }
    
    
}

- (void)setNationLayout
{
    CGRect frame = CGRectZero;
    frame.origin.x = DistanceToBorder;
    frame.origin.y = CGRectGetMaxY(imStatusLabel.frame) + 36 + 20;
    frame.size.width = 160;
    frame.size.height = 36;
    nationLabel = [[UILabel alloc]initWithFrame:frame];
    nationLabel.font = [UIFont systemFontOfSize:FONT_UI32PX];
    nationLabel.text = @"2.您最关注哪些国家?";
    nationLabel.textColor = [UIColor blackColor];
    
    frame.origin.x = CGRectGetMaxX(nationLabel.frame);
    frame.origin.y = frame.origin.y;
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:frame];
    alertLabel.font = [UIFont systemFontOfSize:FONT_UI24PX];
    alertLabel.text = @"(可选择1-3个)";
    alertLabel.textColor = [UIColor DDCouponTextGray];
    
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(nationLabel.frame);
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = SCREEN_HEIGHT - kSureViewHeight - CGRectGetMaxY(nationLabel.frame) - 10;
    /* 获取初始值 */
    NSString * tmpPersonalNation = [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_NATION_LOCAL];
    if (tmpPersonalNation != nil) {
        NSArray * tmpArray = Nil;
        tmpArray = [tmpPersonalNation componentsSeparatedByString: @","];
        nationView = [[NationButtonView alloc] initAllShowWithFrame:frame andSelectedNation:tmpArray];
        if (nationView.newHeight > nationView.size.height) {
            [nationView setHeight:nationView.newHeight];
            /*如果手机屏幕不够显示则支持滑动*/
            [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(nationLabel.frame) + nationView.newHeight)];
        }
    }
    else
    {
        nationView = [[NationButtonView alloc] initWithFrame:frame];
    }
    
    [self observeUserInfo];
    
    nationView.delegate = (id)self;
    
    [_scrollView addSubview:nationLabel];
    [_scrollView addSubview:alertLabel];
    [_scrollView addSubview:nationView];
}

- (void)setOriginalBtn:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
}

- (void)setSelectedBtn:(UIButton *)sender
{
    sender.backgroundColor = [UIColor DDNavBarBlue];
    sender.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setUnableBtn:(UIButton *)sender
{
    [sender setEnabled:NO];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(goToSpecialHome) forControlEvents:UIControlEventTouchUpInside];
    sender.backgroundColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f];
    sender.layer.borderColor = [UIColor colorWithRed:204/255.f green:204/255.f blue:204/255.f alpha:1.f].CGColor;
    sender.layer.borderWidth = 0.5;
    sender.layer.cornerRadius = kCornerRadius;
}

#pragma mark - Click Event

- (void)clickIMButton:(UIButton *)sender
{
    if (_selectedIMStatus.count == 1) {
        NSString *tmpTitle = (NSString *)[_selectedIMStatus firstObject];
        if ([sender.titleLabel.text isEqualToString:tmpTitle]) {
            return;
        }else{
            for (int index = 0; index < _imButtonArray.count; index++) {
                UIButton *btn = (UIButton *)_imButtonArray[index];
                if ([tmpTitle isEqualToString:btn.titleLabel.text]) {
                    [self setOriginalBtn:btn];
                }
            }
            [_selectedIMStatus replaceObjectAtIndex:0 withObject:sender.titleLabel.text];
            [self setSelectedBtn:sender];
        }
    }else{
        [_selectedIMStatus addObject:sender.titleLabel.text];
        [self setSelectedBtn:sender];
    }
    [self observeUserInfo];
}

- (void)goToSpecialHome
{
    [HNBClick event:@"155014" Content:nil];
    NSString * tmNationID = @"";
    NSMutableArray *tmpMutableArry = [[NSMutableArray alloc] initWithArray:nationView.selectedNationsCode];
    for (int index = 0; index < tmpMutableArry.count; index++) {
        tmNationID = [tmNationID stringByAppendingString:tmpMutableArry[index]];
        if (index != (tmpMutableArry.count - 1)) {
            tmNationID = [tmNationID stringByAppendingString:@","];
        }
        
    }
    
    NSString *tmpIntentionID = @"";
    NSMutableArray *tmpIMMutableArry = [[NSMutableArray alloc] initWithArray:_selectedIMStatus];
    for (int index = 0; index < tmpIMMutableArry.count; index++) {
        
        tmpIntentionID = [tmpIntentionID stringByAppendingString:[self CodeForIMStateForCode:tmpIMMutableArry[index]]];
        if (index != (tmpIMMutableArry.count - 1)) {
            tmpIntentionID = [tmpIntentionID stringByAppendingString:@","];
        }
        
    }

    [HNBUtils sandBoxSaveInfo:tmpIntentionID forKey:IM_INTENTION_LOCAL];
    [HNBUtils sandBoxSaveInfo:tmNationID forKey:IM_NATION_LOCAL];
    [[NSNotificationCenter defaultCenter] postNotificationName:HOME_PERSONALITY_SET_SUBMIT object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)observeUserInfo
{
    if( _selectedIMStatus.count != 0 && nationView.selectedNationsCode.count != 0){
        [self setSelectedBtn:_sureButton];
        [_sureButton setEnabled:YES];
    }else{
        [self setUnableBtn:_sureButton];
    }
}

-(NSString *) CodeForIMStateForCode : (NSString*)IMState
{
    NSString * tmpCodeString;

   
    if([IMState isEqualToString:@"想移民"]){
        tmpCodeString = @"WANT_IM";
    }else{
        tmpCodeString = @"IMED";
    }

    
    
    return tmpCodeString;
}

-(NSString *) CodeForIMStateForString : (NSString*)IMState
{
    NSString * tmpCodeString;
    
    if([IMState isEqualToString:@"WANT_IM"]){
        tmpCodeString = @"想移民";
    }else{
        tmpCodeString = @"已移民";
    }
    
    return tmpCodeString;
}


#pragma mark -- NationButtonViewDelegate

-(void)clickNationButton
{
    [self observeUserInfo];
}

- (void)clickMoreButton
{
    if (nationView.newHeight > nationView.size.height) {
        [nationView setHeight:nationView.newHeight];
        /*如果手机屏幕不够显示则支持滑动*/
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(nationLabel.frame) + nationView.newHeight)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{   
    [super viewWillAppear:animated];
    //设置导航栏颜色
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;//隐藏
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setScrollViewContensize) name:NEW_HEIGHT_NATION_VIEW object:nil];
}

- (void)setScrollViewContensize
{
    [self observeUserInfo];
    if (nationView.newHeight > nationView.size.height) {
        [nationView setHeight:nationView.newHeight];
        /*如果手机屏幕不够显示则支持滑动*/
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH,CGRectGetMaxY(nationLabel.frame) + nationView.newHeight)];
    }
}

-(void) back_main
{
    [HNBClick event:@"155013" Content:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //显示tabbar
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    [UIApplication sharedApplication].statusBarHidden = NO;//隐藏
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NEW_HEIGHT_NATION_VIEW object:nil];
}


@end




