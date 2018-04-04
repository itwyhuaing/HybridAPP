//
//  MyOnedayViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/9/29.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#define REFRESH_HEADER_WIDTH 55.0f

#import "MyOnedayViewController.h"


@interface MyOnedayViewController ()

@end


@implementation MyOnedayViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    rectNav     = self.navigationController.navigationBar.frame;
    rectStatus  = [[UIApplication sharedApplication] statusBarFrame];
    tabBarHight = CGRectGetHeight(self.rdv_tabBarController.tabBar.frame);
    insets      = UIEdgeInsetsMake(0, 0, 0, 0);
    
    layout = [[LineLayout alloc]init];
    
    self.myRefreshview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
    self.myRefreshview.delegate = (id)self;
    self.myRefreshview.dataSource = (id)self;
    self.myRefreshview.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0f];
    [self.myRefreshview registerClass:[SWKMyOneDayCollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    [self.view addSubview:self.myRefreshview];
    
    if(!self.URL)
    {
        NSDictionary * tmpInitDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"http://m.hinabian.com/cnd/detail.html", @"url",
                                     [HNBUtils getCruntTime], @"timestamp",nil];
        urlArr = [[NSMutableArray alloc]initWithObjects:tmpInitDic, nil];
        self.title = @"我的海那边一天";
    }
    else
    {
        NSDictionary * tmpInitDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [self.URL absoluteString], @"url",
                                     self.TimeStamp, @"timestamp",nil];
        urlArr = [[NSMutableArray alloc]initWithObjects:tmpInitDic, nil];
        self.title = @"海那边的一天";
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setUpNav];
//    [self.myRefreshview reloadData];
    
}

- (void)setUpNav
{
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //添加右上角相机功能
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"OneDay_icon_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(touchCamera)];
    NSArray *itemsArr = @[cameraItem];
    self.navigationItem.rightBarButtonItems = itemsArr;
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

- (void)back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - REFRESH DELEGATE

- (void)startLoading
{
    [super startLoading];
}

- (void)refresh {
    if (self.refreshLeft) {
        self.refreshLabelLeft.frame = CGRectMake(self.myRefreshview.contentSize.width + REFRESH_HEADER_WIDTH, floorf(SCREEN_HEIGHT - 100)/2,55, 15);
        self.refreshLabelLeft.hidden = FALSE;
        self.refreshSpinner.frame = CGRectMake(floorf(self.myRefreshview.contentSize.width + 50 +10), floorf((SCREEN_HEIGHT - 60) / 2), 30, 30);
        [self performSelector:@selector(addItemLeft) withObject:nil afterDelay:1.1];
    }else if (self.refreshRight){
        self.refreshSpinner.frame = CGRectMake(floorf(floorf(52 - 20) / 2), floorf((SCREEN_HEIGHT - 60) / 2), 30, 30);
        [self performSelector:@selector(addItemRight) withObject:nil afterDelay:1.1];
    }
    [super refresh];
}

- (void)addItemRight {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    SWKMyOneDayCollectionViewCell * tmpCell =  (SWKMyOneDayCollectionViewCell *)[self.myRefreshview cellForItemAtIndexPath:path];
    NSString * tmpTid = tmpCell.T_ID;
    
    if([[self.URL absoluteString] isEqualToString:@"http://m.hinabian.com/cnd/detail.html"])
    {
        tmpTid = @"0";
    }
    [DataFetcher doGetMoreCODPage:tmpTid Num:@"10" Direction:@"0" withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        NSLog(@"errCode = %d",errCode);
        if (errCode == 0) {
            id josnMain = [JSON valueForKey:@"data"];
            NSMutableArray * tmpArry = [josnMain valueForKey:@"theme"];
            if (tmpArry.count > 0) {
                NSUInteger count  = urlArr.count;
                [urlArr addObjectsFromArray:tmpArry];
                [urlArr sortUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2){
                    return [[p1 objectForKey:@"timestamp"] compare:[p2 objectForKey:@"timestamp"]];
                }];
                [self.myRefreshview reloadData];
                [self getCellLocation:TRUE Count:count];
            }
        }
        
    } withFailHandler:^(id error) {
        
    }];
}

- (void)addItemLeft {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:(urlArr.count - 1) inSection:0];
    SWKMyOneDayCollectionViewCell * tmpCell =  (SWKMyOneDayCollectionViewCell *)[self.myRefreshview cellForItemAtIndexPath:path];
    [DataFetcher doGetMoreCODPage:tmpCell.T_ID Num:@"10" Direction:@"1" withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        NSLog(@"errCode = %d",errCode);
        if (errCode == 0) {
            id josnMain = [JSON valueForKey:@"data"];
            NSMutableArray * tmpArry = [josnMain valueForKey:@"theme"];
            if (tmpArry.count > 0) {
                NSUInteger count  = urlArr.count;
                [urlArr addObjectsFromArray:tmpArry];
                [urlArr sortUsingComparator:^NSComparisonResult(NSDictionary *p1, NSDictionary *p2){
                    return [[p1 objectForKey:@"timestamp"] compare:[p2 objectForKey:@"timestamp"]];
                }];
                [self.myRefreshview reloadData];
                [self getCellLocation:FALSE Count:count];
            }
        }
        
    } withFailHandler:^(id error) {
        
    }];
}

-(void)getCellLocation:(BOOL)isLeft Count:(NSInteger)count
{
    NSInteger arrCountBefore = count;
    if (isLeft) {
        [self.myRefreshview setContentOffset:CGPointMake(layout.distanceContextX+CGRectGetWidth(self.myRefreshview.bounds)*(urlArr.count-arrCountBefore-1), self.myRefreshview.contentOffset.y) animated:NO];
        layout.distanceContextX +=CGRectGetWidth(self.myRefreshview.bounds)*(urlArr.count - arrCountBefore-1);
        
    }else if(!isLeft) {
        [self.myRefreshview setContentOffset:CGPointMake(CGRectGetWidth(self.myRefreshview.bounds)*(arrCountBefore), self.myRefreshview.contentOffset.y) animated:NO];
        layout.distanceContextX =CGRectGetWidth(self.myRefreshview.bounds)*arrCountBefore;
    }
}

#pragma mark - COLLECTION DELEGATE


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return urlArr.count;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize;
    cellSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-tabBarHight);
    return cellSize;
    
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets insects;
    insects = UIEdgeInsetsMake(0, 0, tabBarHight, 0);
    return insects; // top, left, bottom, right
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    SWKMyOneDayCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    cell.superController = self;

    for (int i = 0; i<urlArr.count; i++) {
        if (indexPath.item == i) {
            
            NSDictionary * tmpUrl = [urlArr objectAtIndex:i];
            NSLog(@"weburl = %@",[tmpUrl objectForKey:@"url"]);
            self.URL = [NSURL URLWithString:[tmpUrl objectForKey:@"url"]];
            
            NSURLRequest *req = [NSURLRequest requestWithURL:self.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            [cell.wkWebView webLoadRequest:req];
            
            break;
        }
    }
    
    UIButton *btnLeft = (UIButton *)[cell.buttonView viewWithTag:LEFT_BUTTON];
    [btnLeft addTarget:self action:@selector(starBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnRight = (UIButton *)[cell.buttonView viewWithTag:RIGHT_BUTTON];
    [btnRight addTarget:self action:@selector(starBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (urlArr.count == 1) {//如果没有帖子
//        cell.buttonView.hidden =TRUE;
//    }
    return cell;
}

#pragma mark - TOUCH EVENT

- (void)touchCamera
{
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    PostMyDayViewController *vc = [[PostMyDayViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  @author 小泽, 15-11-11 10:11:05
 *
 *  防止连击
 *
 *  @param sender 点击的按钮
 */
-(void)starBtnClicked:(id)sender
{
    UIButton *btn = sender;
    if (btn.tag == LEFT_BUTTON) {
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnTouchLeft:)object:sender];
        [self performSelector:@selector(btnTouchLeft:)withObject:sender afterDelay:0.3f];
    }else if (btn.tag == LEFT_BUTTON){
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnTouchRight:)object:sender];
        [self performSelector:@selector(btnTouchRight:)withObject:sender afterDelay:0.3f];
    }
}

-(void)btnTouchLeft:(id)sender
{
    if (layout.distanceContextX>0) {
        [self.myRefreshview setContentOffset:CGPointMake(self.myRefreshview.contentOffset.x-self.myRefreshview.bounds.size.width, self.myRefreshview.contentOffset.y) animated:YES];
        layout.distanceContextX -=CGRectGetWidth(self.myRefreshview.bounds);
    }else{
        self.refreshRight =TRUE;
        [self startLoading];
        [UIView animateWithDuration:0.3f animations:^{
            [self.myRefreshview setContentOffset:CGPointMake(-REFRESH_HEADER_WIDTH,self.myRefreshview.contentOffset.y) animated:NO];
        }];
    }
}

-(void)btnTouchRight:(id)sender
{
    if (layout.distanceContextX+CGRectGetWidth(self.myRefreshview.bounds)<self.myRefreshview.contentSize.width) {
        [self.myRefreshview setContentOffset:CGPointMake(self.myRefreshview.contentOffset.x+self.myRefreshview.bounds.size.width, self.myRefreshview.contentOffset.y) animated:YES];
        layout.distanceContextX +=CGRectGetWidth(self.myRefreshview.bounds);
    }else{
        self.refreshLeft = TRUE;
        [self startLoading];
    }
}



@end
