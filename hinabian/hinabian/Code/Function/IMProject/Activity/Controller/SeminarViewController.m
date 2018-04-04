//
//  SeminarViewController.m
//  hinabian
//
//  Created by 何松泽 on 17/1/10.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "SeminarViewController.h"
#import "ActivityView.h"
#import "RDVTabBarController.h"

#define SegmentBarHeight    44

@interface SeminarViewController ()

@property (nonatomic, strong)ActivityView *seminarView;

@end

@implementation SeminarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SegmentBarHeight;
    _seminarView = [[ActivityView alloc] initWithFrame:rect type:@"seminar" superVC:self];
    [self.view addSubview:_seminarView];
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
    if (SYSTEM_VERSION >= 8.0)
    {
        self.navigationController.hidesBarsOnSwipe=FALSE;
    }
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)segmentTitle
{
    return @"专题";
}

@end
