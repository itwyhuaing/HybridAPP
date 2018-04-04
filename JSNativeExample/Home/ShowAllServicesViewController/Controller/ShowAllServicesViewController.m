//
//  ShowAllServicesViewController.m
//  ShowAllServicesViewController
//
//  Created by 何松泽 on 2018/3/26.
//  Copyright © 2018年 HSZ. All rights reserved.
//

#import "ShowAllServicesViewController.h"
#import "ShowAllServicesView.h"
#import "ShowAllServicesModel.h"
#import "DataFetcher.h"
#import "CardTableVC.h"

@interface ShowAllServicesViewController ()<ShowAllServicesViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ShowAllServicesView *companyServices;
@property (nonatomic, strong) ShowAllServicesView *thirdServices;
@property (nonatomic, strong) UIView *distanceView;

@end

@implementation ShowAllServicesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"全部";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT)];
    [self.view addSubview:_scrollView];
    
    self.companyServices = [[ShowAllServicesView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.companyServices.delegate = (id)self;
    
    _distanceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame), SCREEN_WIDTH, 15)];
    [_distanceView setBackgroundColor:[UIColor DDHomePageEdgeGray]];
    
    self.thirdServices = [[ShowAllServicesView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame) + 15, SCREEN_WIDTH, 0)];
    self.thirdServices.delegate = (id)self;
    
    if (_hnbServicesArr && _thirdPartArr) {
        
        CGFloat companyServicesHeight = 0.f;
        CGFloat thirdServicesHeight   = 0.f;
        
        NSInteger hnbLineCount = _hnbServicesArr.count%3 == 0 ? _hnbServicesArr.count/3 : _hnbServicesArr.count/3 + 1;
        
        companyServicesHeight = hnbLineCount*SCREEN_WIDTH/3 + kShowAllServicesViewLabelHeight;
        [self.companyServices setFrame:CGRectMake(0, 0, SCREEN_WIDTH, companyServicesHeight)];
        [self.companyServices setDataArr:_hnbServicesArr title:@"海那边服务"];
        
        _distanceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame), SCREEN_WIDTH, 15)];
        [_distanceView setBackgroundColor:[UIColor DDHomePageEdgeGray]];
        
        NSInteger thirdPartLineCount = _thirdPartArr.count%3 == 0 ? _thirdPartArr.count/3 : _thirdPartArr.count/3 + 1;
        thirdServicesHeight = thirdPartLineCount*SCREEN_WIDTH/3 + kShowAllServicesViewLabelHeight;
        [self.thirdServices setFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame) + 15, SCREEN_WIDTH, 0)];
        [self.thirdServices setDataArr:_thirdPartArr title:@"第三方服务"];
        
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, companyServicesHeight + 15 + thirdServicesHeight);
    }else {
        // 没有获取数据重新再拉取
        //[self getData];
    }
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [_scrollView addSubview:_companyServices];
    [_scrollView addSubview:_distanceView];
    [_scrollView addSubview:_thirdServices];
    
    /*超过一屏时可滑动*/
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, companyServicesHeight + 15 + thirdServicesHeight);
}

- (void)getData {
    [DataFetcher doGetAllShowServiceListWithSucceedHandler:^(id JSON) {
        if (JSON) {
            NSArray *hnbArr = [JSON valueForKey:showallservices_hnbservice];
            NSArray *thirdPartArr = [JSON valueForKey:showallservices_thirdpartyservice];
            
            NSString *hnbString = [JSON valueForKey:showallservices_hnbgroupname];
            NSString *thirdPartString = [JSON valueForKey:showallservices_thirdgroupname];
            
            CGFloat companyServicesHeight = 0.f;
            CGFloat thirdServicesHeight   = 0.f;
            if (hnbArr) {
                NSInteger lineCount = hnbArr.count%3 == 0 ? hnbArr.count/3 : hnbArr.count/3 + 1;
                companyServicesHeight = lineCount*SCREEN_WIDTH/3 + kShowAllServicesViewLabelHeight;
            }
            if (thirdPartArr) {
                NSInteger lineCount = thirdPartArr.count%3 == 0 ? thirdPartArr.count/3 : thirdPartArr.count/3 + 1;
                thirdServicesHeight = lineCount*SCREEN_WIDTH/3 + kShowAllServicesViewLabelHeight;
            }
            /*超过一屏时可滑动*/
            [_companyServices setFrame:CGRectMake(0, 0, SCREEN_WIDTH, companyServicesHeight)];
            [_distanceView setFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame), SCREEN_WIDTH, 15)];
            [_thirdServices setFrame:CGRectMake(0, CGRectGetMaxY(_companyServices.frame) + 15, SCREEN_WIDTH, 0)];
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, companyServicesHeight + 15 + thirdServicesHeight);
            
            [self.companyServices setDataArr:hnbArr title:hnbString];
            [self.thirdServices setDataArr:thirdPartArr title:thirdPartString];
        }
    } withFailHandler:^(id error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpNav];
    
}

- (void)setUpNav{
    [self addTabBarButton];
}

- (void)addTabBarButton{
    
    // 返回
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_fanhui"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(back_preVC)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)back_preVC{
    [self.navigationController popViewControllerAnimated:TRUE];
}

#pragma mark - ShowAllServicesViewDelegate
- (void)ShowAllServicesViewClickEvent:(ShowAllServicesModel *)model {
    NSLog(@"~~~~~");
    CardTableVC *vc = [[CardTableVC alloc] init];
    vc.linkString = @"";
    [self.navigationController pushViewController:vc animated:TRUE];
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
