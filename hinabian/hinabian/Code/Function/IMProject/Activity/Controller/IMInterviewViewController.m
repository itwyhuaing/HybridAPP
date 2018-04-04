//
//  IMInterviewViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/11/25.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import "IMInterviewViewController.h"
#import "ActivityItemTableViewCell.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "CODActivityClassifyInfo.h"
#import "ActivityView.h"

#define SegmentBarHeight    44

@interface IMInterviewViewController ()
@property(nonatomic, strong) NSMutableArray * interViewArry;
@property (nonatomic, strong)ActivityView *interviewView;

@end

@implementation IMInterviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect rect = CGRectZero;
    rect.size.width = SCREEN_WIDTH;
    rect.size.height = SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - SegmentBarHeight;
    _interviewView = [[ActivityView alloc] initWithFrame:rect type:@"interview" superVC:self];
    [self.view addSubview:_interviewView];
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
    return @"华人说海外";
}

@end
