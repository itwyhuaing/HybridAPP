//
//  IdeaBackNewViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/9/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "IdeaBackNewViewController.h"
#import "IdeaBackMainView.h"
#import "IQKeyboardManager.h"

@interface IdeaBackNewViewController ()

@property (nonatomic, strong) IdeaBackMainView *mainView;

@end

@implementation IdeaBackNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height);
    _mainView = [[IdeaBackMainView alloc] initWithFrame:rect superController:self];
    [self.view addSubview:_mainView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //禁止→滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    //键盘出现ToolBar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    UIBarButtonItem *temporaryBarButtonItemL = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItemL.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItemL.target = self;
    temporaryBarButtonItemL.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItemL;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //允许→滑返回
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    //键盘出现ToolBar
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) back_main
{
    if ([_mainView.describeTextView.text length]>0) {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"是否放弃编辑"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
        alterview.delegate = (id)self;
        [alterview show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma ALERTVIEW DELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
