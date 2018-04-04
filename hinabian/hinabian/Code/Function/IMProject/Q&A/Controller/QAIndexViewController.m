//
//  QAIndexViewController.m
//  hinabian
//  新版问答首页
//  Created by 余坚 on 16/7/22.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "QAIndexViewController.h"
#import "QAMainView.h"
#import "RDVTabBarController.h"
#import "QAIndexManager.h"
#import "SWKConsultOnlineViewController.h"
#import "AppointmentButton.h"

@interface QAIndexViewController ()<AppointmentButtonDelegate>
@property (strong, nonatomic) QAIndexManager * indexManager;
@property (strong, nonatomic) AppointmentButton *appointmentBtn;
@end

@implementation QAIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"移民问答";
    _indexManager = [[QAIndexManager alloc] init];
    _indexManager.superController = self;
    [_indexManager initMainView];
    [self.view setBackgroundColor:[UIColor beigeColor]];
    
    float scale = SCREEN_WIDTH/SCREEN_WIDTH_6;
    float btnWidth = 53.0f*scale;
    float btnHeight = 53.0f*scale;
    
    _appointmentBtn = [[AppointmentButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - btnWidth - 15*scale, SCREEN_HEIGHT - btnHeight - 128, btnWidth, btnHeight)];
    _appointmentBtn.delegate = (id)self;
    [self.view addSubview:_appointmentBtn];
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    //电话咨询按钮
//    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [searchButton setBackgroundImage:[UIImage imageNamed:@"icon_bohao"]forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(telToUs) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightbarButton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
//    self.navigationItem.rightBarButtonItem = rightbarButton;
    
}

/* 打电话 */
-(void) telToUs
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",DEFAULT_TELNUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma mark CONSULT_BUTTON_DELEGATE

- (void)consultOnlineEvent:(AppointmentButton *)appointmentButton
{
    [HNBClick event:@"110041" Content:nil];
    NSString *str = [NSString stringWithFormat:@"https://eco-api.meiqia.com/dist/standalone.html?eid=1875"];
    
    SWKConsultOnlineViewController *vc = [[SWKConsultOnlineViewController alloc]init];
    vc.URL = [[NSURL alloc] withOutNilString:str];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)consultPhoneEvent:(AppointmentButton *)appointmentButton
{
    [HNBClick event:@"110042" Content:nil];
    
    NSString *urlStrig = [NSString stringWithFormat:@"telprompt://%@",DEFAULT_TELNUM];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrig]];
}

-(void)touchConsultEvent:(AppointmentButton *)appointmentButton
{
    //问答首页快速咨询上报事件
    [HNBClick event:@"108021" Content:nil];
}

@end
