//
//  IMActivityViewController.m
//  hinabianBBS
//
//  Created by 何松泽 on 16/11/29.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "IMActivityViewController.h"
#import "ActivityItemTableViewCell.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "CODActivityClassifyInfo.h"
#import "ActivityView.h"

#define SegmentBarHeight    44

@interface IMActivityViewController ()
@property(nonatomic, strong) NSMutableArray * topicArry;
@property (nonatomic, strong)ActivityView *IMActivityView;

@end

@implementation IMActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SegmentBarHeight;
    _IMActivityView = [[ActivityView alloc] initWithFrame:rect type:@"activity" superVC:self];
    [self.view addSubview:_IMActivityView];
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
    return @"活动";
}

@end
