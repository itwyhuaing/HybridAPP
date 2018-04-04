//
//  GuidViewController.m
//  dada
//
//  Created by 余坚 on 15/4/1.
//  Copyright (c) 2015年 Dongxiang Cai. All rights reserved.
//

#import "GuidViewController.h"
#import "RDVTabBarController.h"
#import "RetrievePasswordViewController.h"
#import "IndividualViewController.h"
#import "HNBClick.h"


@interface GuidViewController ()
{
    UIScrollView * _scrollview;
    UIPageControl * _pgcontrol;
    NSMutableArray * _images;
    NSArray * _imageView;
    BOOL isFinished;
}
@end

@implementation GuidViewController

#define DISTANCE_FROME_IMAGE_BOTTOM  (15*SCREEN_SCALE)     /* UIPageControl控件离图片底部距离 */
//static const int PAGE_COUNT = 4;
static const int PAGE_COUNT = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏原生的NavigationBar
    //self.title = @"玩法介绍";
    isFinished = FALSE;
    self.navigationItem.hidesBackButton = YES;
    [self setNeedsStatusBarAppearanceUpdate];

    
    //背景色
    self.view.backgroundColor = [UIColor DDBackgroundLightGray];
    
    //init mainView
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    [self.mainView setBackgroundColor:[UIColor DDBackgroundLightGray]];
    [self.mainView setTag:10];
    [self.view addSubview:self.mainView];
    
    
     _imageView = [[NSMutableArray alloc] init];
     _images = [[NSMutableArray alloc] init];
//    if (SCREEN_HEIGHT <= SCREEN_HEIGHT_4) {
//        UIImage*i1 = [UIImage imageNamed:@"page1-4"];
//        UIImage*i2 = [UIImage imageNamed:@"page2-4"];
//        UIImage*i3 = [UIImage imageNamed:@"page3-4"];
//        UIImage*i4 = [UIImage imageNamed:@"page4-4"];
//
//        [_images addObject:i1];
//        [_images addObject:i2];
//        [_images addObject:i3];
//        [_images addObject:i4];
//    }else if (SCREEN_HEIGHT <= SCREEN_HEIGHT_5 && SCREEN_HEIGHT > SCREEN_HEIGHT_4)
    if (SCREEN_HEIGHT <= SCREEN_HEIGHT_5)
    {
        UIImage*i1 = [UIImage imageNamed:@"new_page1-5"];
        UIImage*i2 = [UIImage imageNamed:@"new_page2-5"];
        
        [_images addObject:i1];
        [_images addObject:i2];
    }else
    {
        UIImage*i1 = [UIImage imageNamed:@"new_page1"];
        UIImage*i2 = [UIImage imageNamed:@"new_page2"];

        [_images addObject:i1];
        [_images addObject:i2];
    }

    [self initLayerOut];
    
//    UIButton * skipButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 22)];
//    [skipButton setBackgroundImage:[UIImage imageNamed:@"skip_button.png"] forState:UIControlStateNormal];
//    [skipButton setTitle:@"跳过" forState:UIControlStateNormal];
//    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [skipButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
//    [skipButton setTitle:@"跳过123" forState:UIControlStateNormal];
//    skipButton.backgroundColor = [UIColor greenColor];
//    [skipButton setTitleColor:[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//    [skipButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI28PX]];
//    [skipButton addTarget:self action:@selector(skipButtonPressed:) forControlEvents:UIControlEventTouchDown];
    /*去掉跳过按钮*/
     //UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
     //self.navigationItem.rightBarButtonItem = barButton;
    
}

- (void)skipButtonPressed:(UIButton *) sender
{
    [self removeTopAndPushViewController];
}

- (void)removeTopAndPushViewController {
    NSMutableArray *viewControllers = self.navigationController.viewControllers.mutableCopy;
    if ([self.navigationController.topViewController isKindOfClass:[GuidViewController class]]) {
    }
//    // 如果用户有本地数据，直接进入首页
    if ([HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_NATION_LOCAL] == nil || [HNBUtils sandBoxGetInfo:[NSString class] forKey:IM_INTENTION_LOCAL] == nil || [HNBUtils sandBoxGetInfo:[NSString class] forKey:JUDGE_INDIVIDUAL] == nil) {
        IndividualViewController *vc = [[IndividualViewController alloc]init];
        [viewControllers replaceObjectAtIndex:viewControllers.count-1 withObject:vc];
    }else{
        // 直接进入首页
    [viewControllers removeObject:self.navigationController.topViewController];
    }

    [self.navigationController setViewControllers:viewControllers.copy animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:GUIDE_VIEW_COMPLETE_NOTIFICATION object:nil];
    
    isFinished = TRUE;
}

-(void) initLayerOut
{

    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollview.backgroundColor = [UIColor clearColor];
    _scrollview.contentSize = CGSizeMake(_scrollview.bounds.size.width * (PAGE_COUNT+1), 0);
    _scrollview.pagingEnabled = true;
    //_scrollview.bounces = false;
    _scrollview.delegate = (id)self;
    _scrollview.layer.borderWidth = 0.5f;
    _scrollview.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _scrollview.showsHorizontalScrollIndicator = false;
    //_scrollview.layer.cornerRadius = 2;
    [self.mainView addSubview:_scrollview];
    
    _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pgcontrol.pageIndicatorTintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:0.2];
    _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
     _pgcontrol.numberOfPages = PAGE_COUNT;
     _pgcontrol.currentPage = 0;
     [_pgcontrol sizeToFit];
     _pgcontrol.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - DISTANCE_FROME_IMAGE_BOTTOM);
    _pgcontrol.hidden = TRUE;
     [self.mainView addSubview:_pgcontrol];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    NSMutableArray *tmpArray = [NSMutableArray new];
    int index_ = 0;
    for (UIImage * image_ in _images) {
        NSAssert([image_ isKindOfClass:[UIImage class]],@".views are not only UIImage.");
        UIImageView * iv_ = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*index_, -rectNav.size.height-rectStatus.size.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
        iv_.contentMode = UIViewContentModeScaleAspectFit;
        iv_.clipsToBounds = true;
        iv_.image = image_;
        //[iv_ setAlpha:0.5];
        [tmpArray addObject:iv_];
        [_scrollview addSubview:iv_];
        index_++;
    }
    
    
    _imageView = [[tmpArray reverseObjectEnumerator] allObjects];
    
    [self addScrollView];
}

-(void)addScrollView
{
//    for (int pageIndex = 0; pageIndex < PAGE_COUNT; pageIndex++) {
//
//        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollview.bounds.size.width * pageIndex, 0, _scrollview.bounds.size.width, _scrollview.bounds.size.height)];
//        NSString * imageName = [NSString stringWithFormat:@"page%dzi",pageIndex+1];
//        tmpImageView.image = [UIImage imageNamed:imageName];
//        tmpImageView.backgroundColor = [UIColor clearColor];
//        [_scrollview addSubview: tmpImageView];
//    }
    /* 增加开始按钮 */
    UIButton * startButton = [[UIButton alloc] initWithFrame:CGRectMake(_scrollview.bounds.size.width * (PAGE_COUNT - 1), _scrollview.bounds.size.height - 300, _scrollview.bounds.size.width, 300)];
   startButton.backgroundColor = [UIColor clearColor];
    [startButton setTitleColor:[UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:223.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [startButton.layer setMasksToBounds:YES];
    startButton.layer.cornerRadius = 5.0f;
    [startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollview addSubview: startButton];
    
}
- (void)startButtonPressed:(UIButton *) sender
{
       //[UITabBarController hideTabBar:YES];
    [HNBClick event:@"155012" Content:nil];
    [self removeTopAndPushViewController];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    _pgcontrol.currentPage = page_;
    
//    NSInteger index = scrollView.contentOffset.x / self.view.frame.size.width;
//    CGFloat alpha = 1 - ((scrollView.contentOffset.x - index * self.view.frame.size.width) / self.view.frame.size.width);
//    
//    if ([_imageView count] > index) {
//        UIImageView *v = [_imageView objectAtIndex:index];
//        if (v) {
//            [v setAlpha:alpha];
//        }
//    }

    //[self pagingScrollViewDidChangePages:scrollView];
 
    CGPoint contentOffsetPoint = scrollView.contentOffset;
    
    CGRect frame = scrollView.frame;
    
    //NSLog(@"x = %lf   %lf",contentOffsetPoint.x, frame.size.width*PAGE_COUNT);
    if (contentOffsetPoint.x  >  frame.size.width*(PAGE_COUNT - 1) && !isFinished)
        
    {
        [self removeTopAndPushViewController];
    }
}

- (void)pagingScrollViewDidChangePages:(UIScrollView *)pagingScrollView
{
 
     if (_pgcontrol.alpha == 0) {
         [UIView animateWithDuration:0.4 animations:^{
             //self.enterButton.alpha = 0;
             _pgcontrol.alpha = 1;
         }];
     }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationItem hidesBackButton];
    [[self rdv_tabBarController] setTabBarHidden:TRUE animated:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}


@end
