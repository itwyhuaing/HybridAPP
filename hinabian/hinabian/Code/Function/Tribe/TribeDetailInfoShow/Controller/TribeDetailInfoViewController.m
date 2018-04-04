
#import "TribeDetailInfoViewController.h"
#import "CardView.h"
#import "RDVTabBarController.h"
#import "TribeDetailInfoShowManager.h"
#import "ReplyView.h"

#import "pageShowView.h"
#import "HNBTribeShowActionSheet.h"
#import "LoginViewController.h"
#import "DataFetcher.h"
#import "FloorCommentModel.h"
#import "UserInfoController2.h"
#import "SWKTribeShowViewController.h"
#import "TribeInfoByThemeIdModel.h"
#import "TribeShowNewController.h"
#import "DownSheet.h"
#import "DownSheetModel.h"
#import "IndependenceLoadingMask.h"
#import "PersonalInfo.h"
#import "TribeDetailInfoCellManager.h"
#import "UIButton+ClickEventTime.h"
#import "ReplyDetailInfoController.h"
#import "TribeDetailInfoCellManager.h"
 
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

// v2.6
#import "IndexFunctionStatus.h"
#import "IMAssessViewController.h"
#import "TribeThemeModel.h"
//--------------------------------------------------------------------------------------------------------------------------------
//#import "TribeMoreView.h"
#import "MoreActionSheetView.h"
#import "HNBRichTextPostingVC.h"
#import "IMAssessVC.h"

#define WEB_DEFAULT_HEIGHT 0.0 // 100.0

typedef enum
{
    POSITION_TOP = 1000,
    POSITION_FRONT,
    POSITION_BACK
} CardPosition;

typedef enum
{
    NO_VIEW_SLIDING,
    TOP_VIEW_SLIDE_DOWN,
    TOP_VIEW_SLIDE_UP,
    FRONT_VIEW_SLIDE_DOWN,
    FRONT_VIEW_SLIDE_UP
} SwipeViewSlideDirection;

typedef enum
{
    NO_SWIPE,
    SWIPE_UP,
    SWIPE_DOWN
} SwipeDirection;

typedef enum
{
    TABLEVIEW_TOP,
    TABLEVIEW_BOTTOM,
    TABLEVIEW_DEFAULT,
} SetPosition;


//--------------------------------------------------------------------------------------------------------------------------------
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define VELOCITY_LIMIT                          50
#define ANIMATION_DURATION                      0.3
#define CONST_SHOW                              -22
#define BORDER_PADDING                          0
#define BORDER_BOTTOM_PADDING                   44

//--------------------------------------------------------------------------------------------------------------------------------

@interface TribeDetailInfoViewController ()<CardViewDelegate,TribeDetailInfoShowManagerDelegate,WKNavigationDelegate,HNBReplyViewDelegate,HNBPageShowViewDelegate,HNBTribeShowActionSheetDelegate,DownSheetDelegate,UIAlertViewDelegate>
{
    BOOL isAnserFloor;
    BOOL isLZ;
    BOOL isZan;
    BOOL isJumpIntoSingleReply;
    NSString * LZId;
    NSString * shareURL;
    NSString * shareTitle;
    NSString * shareFriendTitle;
    NSString * shareDesc;
    NSString * shareImageUrl;
    NSString * isCollected;
    NSString * countryStr;
    NSString *theTribeName;
    NSString *theTribeID;
    float tmpHeight;
    BOOL isInReply;
    BOOL isReFresh;
    BOOL isInAnimation;
    BOOL enableLoading;
    BOOL isKeyboardShow;
    BOOL isReplyInOne;
    MoreActionSheetView *moreActionSheetView;
}

@property (nonatomic) CardView                  *firstView;

@property (nonatomic) CardView                  *viewTop;
@property (nonatomic) CardView                  *viewFront;
@property (nonatomic) CardView                  *viewBack;

/**
 底部工具栏
 */
@property (strong,nonatomic) ReplyView          *replyInputView;

/**
 登录挑战按钮 -- 覆盖在工具栏上
 */
@property (strong, nonatomic) UIButton * loginButton;

@property (strong,nonatomic) pageShowView       *pageShowView;
@property (nonatomic) NSMutableDictionary       *dictCardView;
@property (nonatomic) CGFloat                   startValue;
@property (nonatomic) NSArray                   *arrPageData;
@property (nonatomic) NSInteger                 pageIndex;
@property (nonatomic) NSInteger                 allPageNum;
@property (nonatomic) SwipeViewSlideDirection   currentSwipeDirection;
@property (nonatomic) SwipeDirection            initialSwipeDirection;


@property (nonatomic,strong)  TribeDetailInfoShowManager *manager;
@property (strong, nonatomic) TribeInfoByThemeIdModel *f;

@property (strong, nonatomic) WKWebView *wkWeb;
@property (strong, nonatomic) UIButton * topBarrightButton;
@property (strong, nonatomic) UIButton * moreButton;
@property (strong, nonatomic) UIView * maskView;
@property (nonatomic,copy) NSString *detailThemID;

@property (strong, nonatomic) UIButton *careBtn;
@property (assign, nonatomic) BOOL isCareAferLogin;

// 依次装载每一页的数据源
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
// 楼主回复数据
@property (nonatomic,strong) NSMutableArray *lzDataSourceArr;

// 举报相关参数
@property (nonatomic,strong) NSMutableArray *downSheetModelDataSources; // 举报类型数据模型
@property (nonatomic,copy) NSString *currentIDForReport; // 举报的楼层 id
@property (nonatomic,copy) NSString *curentTypeForReport; // 举报样式

@end

//--------------------------------------------------------------------------------------------------------------------------------

@implementation TribeDetailInfoViewController

#pragma mark ------ life

- (void)loadView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    self.view = contentView;
    
    _dictCardView = [NSMutableDictionary dictionaryWithCapacity:3];
    _viewTop = [self addCardViewForPosition:POSITION_TOP color:[UIColor DDNormalBackGround]];
    _viewBack = [self addCardViewForPosition:POSITION_BACK color:[UIColor DDNormalBackGround]];
    _viewFront = [self addCardViewForPosition:POSITION_FRONT color:[UIColor DDNormalBackGround]];
    _currentSwipeDirection = NO_VIEW_SLIDING;
    _initialSwipeDirection = NO_SWIPE;
}

- (CardView *)addCardViewForPosition:(CardPosition)position color:(UIColor *)color
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CardView"
                                                      owner:self
                                                    options:nil];
    
    CardView *cardView = [nibViews firstObject];
    cardView.tableView.backgroundColor = color;
    cardView.backGroundColor = color;
    [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
    cardView.backgroundColor = color;
    [cardView setTag:position];
    cardView.delegate = (id)self;
    [self.view addSubview:cardView];
    
    /*设置self.view、CardView、TableView约束的地方*/
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cardView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:-BORDER_PADDING]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cardView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:-BORDER_BOTTOM_PADDING]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cardView.tableView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:cardView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:-SUIT_IPHONE_X_HEIGHT]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:cardView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:cardView
                                                                          attribute:NSLayoutAttributeCenterY
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeCenterY
                                                                         multiplier:1.0
                                                                           constant:CONST_SHOW];
    [self.view addConstraint:verticalConstraint];
    [_dictCardView setObject:verticalConstraint forKey:[NSNumber numberWithInt:position]];
    cardView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cardView;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSourceArr = nil;
        _lzDataSourceArr = nil;
        isLZ = FALSE;
        _allPageNum = 1;
        _pageIndex = 0;
        tmpHeight = 0;
        isReFresh = FALSE;
        isInAnimation = FALSE;
        enableLoading = TRUE;
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    _wkWeb = [[WKWebView alloc] init];
    _wkWeb.navigationDelegate = self;
    _wkWeb.UIDelegate = self;
    [_wkWeb loadRequest:[NSURLRequest requestWithURL:self.URL]];
    _wkWeb.scrollView.scrollEnabled = NO;
    _viewFront.wkWebForTribe = _wkWeb;
    _viewFront.isFirstPage = TRUE;
    
    /**< manager 创建 请求数据 >*/
    _manager = [[TribeDetailInfoShowManager alloc] initWithThemId:_detailThemID superVC:self];
    _manager.delegate = self;
    
    /* pageshowview初始化 */
    _pageShowView = [[pageShowView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_WIDTH, PAGE_VIEW_HEIGHT)];
    _pageShowView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2];
    _pageShowView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height - PAGE_VIEW_HEIGHT/2);
    _pageShowView.delegate = (id)self;
    _pageShowView.hidden = TRUE;
    
    [self.view addSubview:_pageShowView];
    
    _replyInputView = [[ReplyView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44 - rectNav.size.height - rectStatus.size.height - SUIT_IPHONE_X_HEIGHT, SCREEN_WIDTH, 44)];
    _replyInputView.superViewController = self;
    _replyInputView.delegate = (id)self;
    _replyInputView.backgroundColor = [UIColor DDNormalBackGround];
    [_replyInputView replyViewEnable:TRUE];
    [self.view addSubview:_replyInputView];
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self.view loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [self.view addGestureRecognizer:swipeGesture];
    
    //监听tableView偏移量，刷新wkweb的渲染
    _firstView = _viewFront;
    [_firstView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    //监听wk的contentsize，获取是否有新高度
    [_wkWeb.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)keyboardShow:(NSNotification *)notification {
    isKeyboardShow = YES;
}

-(void)keyboardHide:(NSNotification *)notification {
    isKeyboardShow = NO;
}

-(BOOL)isKeyboardShow {
    if (isKeyboardShow) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

-(void)swipeGesture:(id)sender {
    UISwipeGestureRecognizer *swipe = sender;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)hideMaskView:(BOOL)isHide {
    self.maskView.hidden = isHide;
}

-(void)handleSingleTap {
    [self hideMaskView:YES];
    [_replyInputView fallAllView];
}

-(void)tapMaskView
{
    /*滑动过程中的重置蒙版层*/
    [self moveViewsForReset:YES];
}

-(void)textViewResign {
    [_replyInputView.inputTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"帖子详情";
    if ([HNBUtils isLogin] && _isCareAferLogin) {
        PersonInfoModel *f = _viewFront.lzInfo;
        [self toCare:f];
    }
    isReFresh = TRUE;
    enableLoading = FALSE;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc]init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    NSString * isLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:personal_is_login];
    if (isLogin == nil) {
        isLogin = @"0";
    }
    if ([isLogin isEqualToString:@"0"]) {
        if (!_loginButton) {
            _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _replyInputView.inputTextField.frame.size.width, _replyInputView.frame.size.height)];
            _loginButton.backgroundColor = [UIColor clearColor];
            [_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchDown];
            [_replyInputView addSubview:_loginButton];
        }
    } else {
        if (_loginButton) {
            [_loginButton removeFromSuperview];
        }
    }
    
    [self setDataInView:_viewFront forIndex:_pageIndex toToporBottom:TABLEVIEW_DEFAULT];
    
    /* 通过帖子id 更新帖子信息 */
    [DataFetcher doGetTribeInfoWithThemeId:_detailThemID withSucceedHandler:^(id info) {
        _f = (TribeInfoByThemeIdModel *)info;
        _viewFront.tribInfo = _f;
        countryStr = _f.country;
        theTribeID = _f.triebId;
        theTribeName = _f.tribeName;
    } withFailHandler:^(id error) {
    }];
    [self setCardScrollAssessRight];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCareBtn:) name:USERINFO_CAREBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickHeadBtn:) name:USERINFO_HEADBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFO_CAREBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USERINFO_HEADBUTTON object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    _wkWeb.navigationDelegate = nil;
    [_wkWeb loadHTMLString:@"" baseURL:nil];
    [_wkWeb stopLoading];
    [_wkWeb removeFromSuperview];
    [_firstView.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_wkWeb.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)loginButtonPressed {
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark CardView Animation

- (void)handlePanGestureTop:(UIPanGestureRecognizer *)recognizer {
    CGPoint loc = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startValue = loc.y;
        _initialSwipeDirection = NO_SWIPE;
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat diff = _startValue - loc.y;
        _startValue = loc.y;
        if (_initialSwipeDirection == NO_SWIPE) {
            _initialSwipeDirection = diff < 0 ? SWIPE_DOWN : SWIPE_UP;
        }
        if (_initialSwipeDirection == SWIPE_DOWN && _pageIndex > 0) {
            CGFloat constraint = [self constraintForView:(CardPosition)[_viewTop tag]].constant;
            [self constraintForView:(CardPosition)[_viewTop tag]].constant -= diff;
            _viewFront.maskView.hidden = FALSE;
            _viewFront.noticeTextField.text = [NSString stringWithFormat:@"下翻至第%ld页",(long)_pageIndex];
            CGFloat colorScal = (SCREEN_HEIGHT-ABS(constraint)) / SCREEN_HEIGHT;
            _viewFront.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:colorScal*0.6];
        } else if (_initialSwipeDirection == SWIPE_UP && _pageIndex < _allPageNum-1) {
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled)
    {
        CGFloat constraint = [self constraintForView:(CardPosition)[_viewTop tag]].constant;
        if (constraint > -(SCREEN_HEIGHT - 10) && _pageIndex > 0) {
            [self animateViewsForSlide:NO];
        }
        else
        {
            [self moveViewsForReset:YES];
        }
    }
}

- (void)handlePanGestureBottom:(UIPanGestureRecognizer *)recognizer
{
    CGPoint loc = [recognizer locationInView:self.view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _startValue = loc.y;
        _initialSwipeDirection = NO_SWIPE;
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat diff = _startValue - loc.y;
        _startValue = loc.y;
        if (_initialSwipeDirection == NO_SWIPE)
            _initialSwipeDirection = diff < 0 ? SWIPE_DOWN : SWIPE_UP;
        
        if (_initialSwipeDirection == SWIPE_DOWN && _pageIndex > 0) {
        }
        else if (_initialSwipeDirection == SWIPE_UP && _pageIndex < _allPageNum-1) {
            CGFloat constraint = [self constraintForView:(CardPosition)[_viewFront tag]].constant;
            constraint -= diff;
            if (constraint < 0) [self constraintForView:(CardPosition)[_viewFront tag]].constant -= diff;
            _viewBack.maskView.hidden = FALSE;
            _viewBack.noticeTextField.text = [NSString stringWithFormat:@"上翻至第%ld页",_pageIndex+2];
            CGFloat colorScal = (SCREEN_HEIGHT-ABS(constraint)) / SCREEN_HEIGHT;
            _viewBack.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:colorScal*0.6];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat constraint = [self constraintForView:(CardPosition)[_viewFront tag]].constant;
        if (constraint < -10 && _pageIndex < _allPageNum-1) {
            [self animateViewsForSlide:YES];
        } else {
            [self moveViewsForReset:YES];
        }
    }
}


- (void)animateViewsForSlide:(BOOL)slideUp
{
    if (isInAnimation) {
        return;
    }
    if (slideUp) {
        [self.view sendSubviewToBack:_viewTop];
        [_viewTop setHidden:YES];
        [self.view insertSubview:_viewFront belowSubview:_pageShowView];
        [self constraintForView:(CardPosition)[_viewBack tag]].constant = CONST_SHOW;
        [self constraintForView:(CardPosition)[_viewFront tag]].constant = -(_viewFront.frame.size.height + BORDER_BOTTOM_PADDING);
        [self constraintForView:(CardPosition)[_viewTop tag]].constant = CONST_SHOW;
    } else {
        [self.view insertSubview:_viewTop belowSubview:_pageShowView];
        [_viewBack setHidden:YES];
        [self.view sendSubviewToBack:_viewBack];
        [self constraintForView:(CardPosition)[_viewBack tag]].constant = -(_viewBack.frame.size.height + BORDER_BOTTOM_PADDING);
        [self constraintForView:(CardPosition)[_viewFront tag]].constant = CONST_SHOW;
        [self constraintForView:(CardPosition)[_viewTop tag]].constant = CONST_SHOW;
    }
    
    
    [UIView animateWithDuration:ANIMATION_DURATION
                     animations:^{
                         isInAnimation = TRUE;
                         [self.view layoutIfNeeded];
                         if (slideUp) {
                             _viewBack.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
                             //_viewBack.noticeTextField.alpha = 0.8f;
                         }
                         else
                         {
                             //_viewFront.noticeTextField.alpha = 1.0f;
                             _viewFront.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
                         }
                         
                     } completion:^(BOOL finished) {
                         isInAnimation = FALSE;
                         _viewBack.maskView.hidden = TRUE;
                         _viewFront.maskView.hidden = TRUE;
                         _viewTop.maskView.hidden = TRUE;
                         CardView *viewTop = _viewTop;
                         CardView *viewFront = _viewFront;
                         CardView *viewBack = _viewBack;
                         
                         if (slideUp)
                         {
                             [_viewTop setHidden:NO];
                             _pageIndex++;
                             _viewTop = viewFront;
                             _viewFront = viewBack;
                             _viewBack = viewTop;
                         }
                         else
                         {
                             [_viewBack setHidden:NO];
                             _pageIndex--;
                             _viewTop = viewBack;
                             _viewFront = viewTop;
                             _viewBack = viewFront;
                         }
                         [self.view insertSubview:_viewTop belowSubview:_pageShowView];
                         [self.view sendSubviewToBack:_viewBack];
                         [self setDataForCurrentIndex:slideUp];
                         [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
                         
                     }];
}

- (void)moveViewsForReset:(BOOL)animate
{
    if (isInAnimation) {
        return;
    }
    NSLog(@"moveViewsForReset");
    [self constraintForView:(CardPosition)[_viewBack tag]].constant = CONST_SHOW;
    [self constraintForView:(CardPosition)[_viewFront tag]].constant = CONST_SHOW;
    [self constraintForView:(CardPosition)[_viewTop tag]].constant = -(_viewFront.frame.size.height + BORDER_BOTTOM_PADDING);
    
    [UIView animateWithDuration:animate ? ANIMATION_DURATION : 0
                     animations:^{
                         isInAnimation = TRUE;
                         [self.view layoutIfNeeded];
                         _viewBack.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
                         _viewFront.maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];
                     }completion:^(BOOL finished) {
                         isInAnimation = FALSE;
                         _viewBack.maskView.hidden = TRUE;
                         _viewFront.maskView.hidden = TRUE;
                         _viewTop.maskView.hidden = TRUE;
                     }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [_viewTop setHidden:YES];
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self moveViewsForReset:NO];
         [_viewTop setHidden:NO];
     }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (NSLayoutConstraint *)constraintForView:(CardPosition)position
{
    return [_dictCardView objectForKey:[NSNumber numberWithInt:position]];
}


#pragma mark - HNBTribeShowActionSheetDelegate
-(void)done:(NSString *)chosePage{
    
    NSInteger pageIndex = [chosePage integerValue];
    NSInteger cardId = (((pageIndex % 3) + 1) %3) + POSITION_TOP;
    _viewFront = [self.view viewWithTag:cardId];
    _viewTop = [self.view viewWithTag:(cardId-1) >= POSITION_TOP?(cardId-1):POSITION_BACK];
    _viewBack = [self.view viewWithTag:(cardId+1) <= POSITION_BACK?(cardId+1):POSITION_TOP];
    [self.view insertSubview:_viewTop belowSubview:_pageShowView];
    [self.view insertSubview:_viewBack belowSubview:_pageShowView];
    [self.view insertSubview:_viewFront belowSubview:_pageShowView];
    if (pageIndex >=0 && pageIndex < _allPageNum ) {
        if (pageIndex == 0) {
            [self setDataInView:_viewFront forIndex:(int)pageIndex toToporBottom:TABLEVIEW_TOP];
            [self setDataInView:_viewBack forIndex:(int)pageIndex+1 toToporBottom:TABLEVIEW_TOP];
        }
        else if(pageIndex == _allPageNum-1)
        {
            [self setDataInView:_viewFront forIndex:(int)pageIndex toToporBottom:TABLEVIEW_TOP];
            [self setDataInView:_viewTop forIndex:(int)pageIndex-1 toToporBottom:TABLEVIEW_BOTTOM];
        }
        else
        {
            [self setDataInView:_viewTop forIndex:(int)pageIndex-1 toToporBottom:TABLEVIEW_BOTTOM];
            [self setDataInView:_viewFront forIndex:(int)pageIndex toToporBottom:TABLEVIEW_TOP];
            [self setDataInView:_viewBack forIndex:(int)pageIndex+1 toToporBottom:TABLEVIEW_TOP];
        }
        [self constraintForView:(CardPosition)[_viewBack tag]].constant = CONST_SHOW;
        [self constraintForView:(CardPosition)[_viewFront tag]].constant = CONST_SHOW;
        [self constraintForView:(CardPosition)[_viewTop tag]].constant = -(_viewFront.frame.size.height + BORDER_BOTTOM_PADDING);
        [self.view layoutIfNeeded];
        [self setCardScrollAssessRight];
    }
    _pageIndex = pageIndex;
    [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
}

-(void) jumpToFirstPage
{
    [self done:@"0"];
}

-(void) jumpToLastPage
{
    [self done:[NSString stringWithFormat:@"%ld",(_allPageNum-1)]];
    
}


#pragma mark HNBPageShowViewDelegate
-(void) HNBPageShowViewLeftButtonPressed
{
    //    [_viewTop tableViewToBottom];
    //    [_viewBack tableViewToTop];
    if (_pageIndex -1 >=0 && _pageIndex -1 < _allPageNum )
    {
        [self animateViewsForSlide:FALSE];
    }
    
}
-(void) HNBPageShowViewRightButtonPressed
{
    //    [_viewTop tableViewToBottom];
    //    [_viewBack tableViewToTop];
    if (_pageIndex +1 >=0 && _pageIndex + 1 < _allPageNum )
    {
        [self animateViewsForSlide:TRUE];
    }
    
}
-(void) HNBPageShowViewCenterButtonPressed
{
    [self HNBReplyViewJumpButtonPressed];
}

#pragma mark HNBReplyViewDelegate
-(void) HNBReplyViewSendButtonPressed:(ReplyView*)view TEXT:(NSString*)text IMAGE:(NSArray*)imageList
{
    NSLog(@"text to send:%@",text);
    [HNBClick event:@"107043" Content:nil];
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        
        //输入内容为空判断
        if(([text isEqualToString:@""] || nil == text) && imageList.count == 0)
        {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入内容" afterDelay:1.0 style:HNBToastHudOnlyText];
        }
        else
        {
            [DataFetcher doReplyPost:UserInfo.id TID:_detailThemID CID:@"" content:text ImageList:imageList withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                /* 跳回前向页面 */
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    /* 更新数据 */
                    if (!isLZ) {
                        [self setDataAfterSendMsg];
                    }
                    
                }
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
        }
        
    }
    isAnserFloor = FALSE;
    
}

-(void) HNBReplyViewJumpButtonPressed
{
    [HNBClick event:@"107033" Content:nil];
    //_pickerArray = [NSArray arrayWithObjects:@"第1页",@"第2页",@"第3页",@"第4页", nil];
    HNBTribeShowActionSheet *sheet = [[HNBTribeShowActionSheet alloc] initWithView:_allPageNum currentPage:_pageIndex+1  AndHeight:244];
    sheet.doneDelegate = (id)self;
    [sheet showInView:self.view];
}

-(void) HNBReplyViewZanButtonPressed
{
    NSString *curUrlStrForZan = [NSString stringWithFormat:@"%@",_detailThemID];
    NSDictionary *dic = @{@"idForThem":curUrlStrForZan};
    [MobClick event:@"clickZanButton" attributes:dic];
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
        
        if (isZan) {
            NSDictionary *dict = @{@"state" : @"1"};
            [HNBClick event:@"107022" Content:dict];
            [DataFetcher doCancelPraiseTheme:UserInfo.id TID:_detailThemID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    //                    [self.replyInputView.zanButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_zan"] forState:UIControlStateNormal];
                    [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan"]];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.3)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [self.replyInputView.zanButton.layer addAnimation:k forKey:@"SHOW"];
                    isZan = FALSE;
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
                [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
            }];
        }
        else
        {
            NSDictionary *dict = @{@"state" : @"0"};
            [HNBClick event:@"107022" Content:dict];
            [DataFetcher doPraiseTheme:UserInfo.id TID:_detailThemID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    //                    [self.replyInputView.zanButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_zan_pressed"] forState:UIControlStateNormal];
                    [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan_pressed"]];
                    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                    k.values = @[@(0.1),@(1.0),@(1.3)];
                    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                    k.calculationMode = kCAAnimationLinear;
                    [self.replyInputView.zanButton.layer addAnimation:k forKey:@"SHOW"];
                    isZan = TRUE;
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
            } withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
                [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
            }];
        }
    }
    
}

- (void)HNBReplyViewCollectButtonPressed
{
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([isCollected isEqualToString:@"1"]) {
        //取消收藏
        NSDictionary *dict = @{@"state" : @"0"};
        [HNBClick event:@"107049" Content:dict];
        [DataFetcher doGetCollectTheme:_detailThemID CanceleOrCollect:FALSE withSucceedHandler:^(id JSON) {
            //            [self.replyInputView.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"] forState:UIControlStateNormal];
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"]];
            isCollected = @"0";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.replyInputView.collectButton.layer addAnimation:k forKey:@"SHOW"];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"已取消收藏" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"取消收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }
    else
    {
        NSDictionary *dict = @{@"state" : @"1"};
        [HNBClick event:@"107049" Content:dict];
        //收藏
        [DataFetcher doGetCollectTheme:_detailThemID CanceleOrCollect:TRUE withSucceedHandler:^(id JSON) {
            //            [self.replyInputView.collectButton setBackgroundImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"] forState:UIControlStateNormal];
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"]];
            isCollected = @"1";
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.3)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            [self.replyInputView.collectButton.layer addAnimation:k forKey:@"SHOW"];
            [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏成功" afterDelay:DELAY_TIME style:HNBToastHudSuccession];
            
        } withFailHandler:^(id error) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"收藏失败,请稍后重试" afterDelay:DELAY_TIME style:HNBToastHudFailure];
        }];
    }
    
}

#pragma mark - Data Handling

- (void) setCardScrollAssessRight
{
    
}

- (void)setDataForCurrentIndex:(BOOL)slideUp
{
    [self setCardScrollAssessRight];
    if ( _pageIndex <= 0 || _pageIndex >= _allPageNum-1) return;
    
    if (slideUp)
    {
        [self setDataInView:_viewTop forIndex:_pageIndex-1 toToporBottom:TABLEVIEW_BOTTOM];
        [self setDataInView:_viewBack forIndex:_pageIndex+1 toToporBottom:TABLEVIEW_TOP];
    }
    else
    {
        [self setDataInView:_viewTop forIndex:_pageIndex-1 toToporBottom:TABLEVIEW_BOTTOM];
        [self setDataInView:_viewBack forIndex:_pageIndex+1 toToporBottom:TABLEVIEW_TOP];
    }
}

- (void)setDataInView:(CardView *)cardView forIndex:(NSInteger)index toToporBottom:(NSInteger)position {
    if (index < 0 || index > _allPageNum-1) {
        return;
    }
    if (isReplyInOne) {
        //在不是最后一页评论
        isReplyInOne = FALSE;
        if (index == _allPageNum-1) {
            cardView.isFirstPage = TRUE;
            cardView.isLastPage = TRUE;
        } else {
            cardView.isFirstPage = FALSE;
            cardView.isLastPage = FALSE;
        }
    } else {
        //如果不止一页
        if (index == 0) // 第一页
        {
            cardView.isFirstPage = TRUE;
            cardView.isLastPage = FALSE;
        }
        else if(index == _allPageNum-1)  //最后一页
        {
            cardView.isLastPage = TRUE;
            cardView.isFirstPage = FALSE;
        } else {
            cardView.isFirstPage = FALSE;
            cardView.isLastPage = FALSE;
        }
    }
    if (isLZ) {
        [self getLZCommentData:cardView forIndex:index toToporBottom:position];
    } else {
        [self getCommentData:cardView forIndex:index toToporBottom:position];
    }
}

- (void)getCommentData:(CardView *)cardView forIndex:(NSInteger)index toToporBottom:(NSInteger)position
{
    /**< manager 创建 请求数据 >*/
    _manager = [[TribeDetailInfoShowManager alloc] initWithThemId:_detailThemID superVC:self];
    if ((index == 0  && _dataSourceArr == nil) || isReFresh) {
        /* 请求第一页 */
        __weak typeof(self) weakSelf = self;
        __weak typeof(_viewBack) weakViewBack = _viewBack;
        __block CardView * tmpView = cardView;
        IndependenceLoadingMask * infoLoading = [[IndependenceLoadingMask alloc] init];
        if(enableLoading)
        {
            [infoLoading loadingMaskWithSuperView:cardView frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - CGRectGetHeight(_replyInputView.frame))];
        }
        [_manager reqNetDataPage:index+1 withSucceedHandler:^(NSArray *data) {
            NSLog(@"请求第%ld页数据",index+1);
            [infoLoading dismiss];
            NSMutableArray *dataSource = [NSMutableArray arrayWithArray:data];
            _allPageNum = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_detailThem_comments_totalPages] integerValue];
            if (_allPageNum == 0) /* 无评论处理 */
            {
                _allPageNum = 1;
            }
            if(index == _allPageNum-1)  //第一页也是最后一页
            {
                cardView.isLastPage = TRUE;
            }
            [tmpView reqSourceDataWithData:dataSource];
            _dataSourceArr = [NSMutableArray arrayWithCapacity:_allPageNum];
            for(NSInteger i = 0; i < _allPageNum; i++)
            {
                [_dataSourceArr insertObject:@"null" atIndex:i];
            }
            if(index < _dataSourceArr.count && index >= 0)
            {
                [_dataSourceArr replaceObjectAtIndex:index withObject:dataSource];
            }
            
            [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            if (_allPageNum > 1 && [_dataSourceArr[1] isKindOfClass:[NSString class]]) {
                // 有第二页才允许请求
                [weakSelf setDataInView:weakViewBack forIndex:1 toToporBottom:TABLEVIEW_TOP];
            }
            if (position == TABLEVIEW_TOP) {
                [tmpView tableViewToTop];
            }
            else if (position == TABLEVIEW_BOTTOM)
            {
                [tmpView tableViewToBottom];
            }
        }];
        isReFresh = FALSE;
        
    } else if ((index < _dataSourceArr.count && [_dataSourceArr[index] isKindOfClass:[NSString class]]) || isReFresh) {
        IndependenceLoadingMask * infoLoading = [[IndependenceLoadingMask alloc] init];
        if (enableLoading) {
            [infoLoading loadingMaskWithSuperView:cardView frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - CGRectGetHeight(_replyInputView.frame))];
        }
        __block CardView * tmpView = cardView;
        [_manager reqNetDataPage:index+1 withSucceedHandler:^(NSArray *data) {
            [infoLoading dismiss];
            NSLog(@"请求第%ld页数据",index+1);
            NSMutableArray *dataSource = [NSMutableArray arrayWithArray:data];
            if(index < _dataSourceArr.count && index >= 0)
            {
                [_dataSourceArr replaceObjectAtIndex:index withObject:dataSource];
            }
            [tmpView reqSourceDataWithData:dataSource];
            NSInteger tmpPageNum = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_detailThem_comments_totalPages] integerValue];
            /* 在阅读过程中页数变化 */
            if (tmpPageNum > _allPageNum) {
                for(NSInteger i = 0; i < (tmpPageNum - _allPageNum); i++)
                {
                    [_dataSourceArr addObject:@"null"];
                }
                _allPageNum = tmpPageNum;
                [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            } else if (tmpPageNum < _allPageNum) {
                for(NSInteger i = 0; i < (_allPageNum - tmpPageNum); i++) {
                    if(_allPageNum-i < _dataSourceArr.count && _allPageNum-i >= 0)
                    {
                        [_dataSourceArr removeObjectAtIndex:(_allPageNum-i)];
                    }
                }
                _allPageNum = tmpPageNum;
                [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            }
            if (position == TABLEVIEW_TOP) {
                [tmpView tableViewToTop];
            } else if (position == TABLEVIEW_BOTTOM) {
                [tmpView tableViewToBottom];
            }
        }];
        isReFresh = FALSE;
    } else if(index < _dataSourceArr.count) {
        [cardView reqSourceDataWithData:_dataSourceArr[index]];
        if (position == TABLEVIEW_TOP) {
            [cardView tableViewToTop];
        } else if (position == TABLEVIEW_BOTTOM) {
            [cardView tableViewToBottom];
        }
    }
    enableLoading = TRUE;
}

- (void) getLZCommentData:(CardView *)cardView forIndex:(NSInteger)index toToporBottom:(NSInteger)position
{
    /**< manager 创建 请求数据 >*/
    _manager = [[TribeDetailInfoShowManager alloc] initWithThemId:_detailThemID superVC:self];
    if (index == 0) {
        /* 请求第一页 */
        __weak typeof(self) weakSelf = self;
        __block CardView * tmpView = cardView;
        __weak typeof(_viewBack) weakViewBack = _viewBack;
        IndependenceLoadingMask * infoLoading = [[IndependenceLoadingMask alloc] init];
        if(enableLoading)
        {
            [infoLoading loadingMaskWithSuperView:cardView frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - CGRectGetHeight(_replyInputView.frame))];
        }
        [_manager reqLZNetDataPage:index+1 withSucceedHandler:^(NSArray *data) {
            [infoLoading dismiss];
            NSMutableArray *dataSource = [NSMutableArray arrayWithArray:data];
            _allPageNum = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_detailThem_comments_totalPages] integerValue];
            if (_allPageNum == 0) /* 无评论处理 */
            {
                _allPageNum = 1;
            }
            if(index == _allPageNum-1)  //第一页也是最后一页
            {
                tmpView.isLastPage = TRUE;
            }
            [tmpView reqSourceDataWithData:dataSource];
            _lzDataSourceArr = [NSMutableArray arrayWithCapacity:_allPageNum];
            for(NSInteger i = 0; i < _allPageNum; i++)
            {
                [_lzDataSourceArr insertObject:@"null" atIndex:i];
            }
            if(index < _lzDataSourceArr.count && index >= 0)
            {
                [_lzDataSourceArr replaceObjectAtIndex:index withObject:dataSource];
            }
            
            [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            
            
            if (_allPageNum > 1 && [_lzDataSourceArr[1] isKindOfClass:[NSString class]]) {
                // 有第二页才允许请求
                [weakSelf setDataInView:weakViewBack forIndex:index + 1 toToporBottom:TABLEVIEW_TOP];
            }
            if (position == TABLEVIEW_TOP) {
                [tmpView tableViewToTop];
            }
            else if (position == TABLEVIEW_BOTTOM)
            {
                [tmpView tableViewToBottom];
            }
        }];
        
    }
    else if ((index < _lzDataSourceArr.count && [_lzDataSourceArr[index] isKindOfClass:[NSString class]])  || isReFresh)
    {
        __weak typeof(_lzDataSourceArr) weakDataSourceArr = _lzDataSourceArr;
        __block CardView * tmpView = cardView;
        IndependenceLoadingMask * infoLoading = [[IndependenceLoadingMask alloc] init];
        if(enableLoading)
        {
            [infoLoading loadingMaskWithSuperView:cardView frame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SCREEN_STATUSHEIGHT - SCREEN_NAVHEIGHT - CGRectGetHeight(_replyInputView.frame))];
        }
        [_manager reqLZNetDataPage:index+1 withSucceedHandler:^(NSArray *data) {
            [infoLoading dismiss];
            NSMutableArray *dataSource = [NSMutableArray arrayWithArray:data];
            if(index < weakDataSourceArr.count && index >= 0)
            {
                [weakDataSourceArr replaceObjectAtIndex:index withObject:dataSource];
            }
            [tmpView reqSourceDataWithData:dataSource];
            NSInteger tmpPageNum = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_detailThem_comments_totalPages] integerValue];
            /* 在阅读过程中页数变化 */
            if (tmpPageNum > _allPageNum) {
                for(NSInteger i = 0; i < (tmpPageNum - _allPageNum); i++)
                {
                    [_lzDataSourceArr addObject:@"null"];
                }
                _allPageNum = tmpPageNum;
                [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            }
            else if (tmpPageNum < _allPageNum)
            {
                for(NSInteger i = 0; i < (_allPageNum - tmpPageNum); i++)
                {
                    if(_allPageNum-i < _lzDataSourceArr.count && _allPageNum-i >= 0)
                    {
                        [_lzDataSourceArr removeObjectAtIndex:(_allPageNum-i)];
                    }
                    
                    
                }
                _allPageNum = tmpPageNum;
                [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
            }
            if (position == TABLEVIEW_TOP) {
                [tmpView tableViewToTop];
            }
            else if (position == TABLEVIEW_BOTTOM)
            {
                [tmpView tableViewToBottom];
            }
            
        }];
    }
    else if(index < _lzDataSourceArr.count)
    {
        [cardView reqSourceDataWithData:_lzDataSourceArr[index]];
        if (position == TABLEVIEW_TOP) {
            [cardView tableViewToTop];
        }
        else if (position == TABLEVIEW_BOTTOM)
        {
            [cardView tableViewToBottom];
        }
    }
    enableLoading = TRUE;
}

/* 发送完消息后更新数据 */
- (void) setDataAfterSendMsg
{
    //__weak typeof(_dataSourceArr) weakDataSourceArr = _dataSourceArr;
    /* 请求最后一页数据 */
    [_manager reqNetDataPage:_allPageNum withSucceedHandler:^(NSArray *data) {
        NSMutableArray *dataSource = [NSMutableArray arrayWithArray:data];
        
        if(_allPageNum-1 < _dataSourceArr.count && _allPageNum-1 >= 0)
        {
            [_dataSourceArr replaceObjectAtIndex:_allPageNum-1 withObject:dataSource];
        }
        //[cardView reqSourceDataWithData:dataSource];
        NSInteger tmpPageNum = [[HNBUtils sandBoxGetInfo:[NSString class] forKey:tribe_detailThem_comments_totalPages] integerValue];
        /* 在阅读过程中页数变化 */
        if (tmpPageNum > _allPageNum) {
            for(NSInteger i = 0; i < (tmpPageNum - _allPageNum); i++)
            {
                [_dataSourceArr addObject:@"null"];
            }
            _allPageNum = tmpPageNum;
            [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
        }
        else if (tmpPageNum < _allPageNum)
        {
            for(NSInteger i = 0; i < (_allPageNum - tmpPageNum); i++)
            {
                [_dataSourceArr removeObjectAtIndex:(_allPageNum-i)];
                
            }
            _allPageNum = tmpPageNum;
            [_pageShowView setPageNum:[NSString stringWithFormat:@"%ld/%ld",(long)(_pageIndex+1),(long)_allPageNum]];
        }
        if (_pageIndex+1 == _allPageNum) {
            //[_viewFront reqSourceDataWithData:_dataSourceArr[_allPageNum-1]];
            isReplyInOne = TRUE;
            [self setDataInView:_viewFront forIndex:_allPageNum-1 toToporBottom:TABLEVIEW_DEFAULT];
        }
        else if(_pageIndex+2 == _allPageNum)
        {
            [self setDataInView:_viewFront forIndex:_allPageNum-2 toToporBottom:TABLEVIEW_DEFAULT];
            [self setDataInView:_viewBack forIndex:_allPageNum-1 toToporBottom:TABLEVIEW_DEFAULT];
            //[_viewBack reqSourceDataWithData:_dataSourceArr[_allPageNum-1]];
            
        }
    }];
    
}


#pragma mark ------ Base Publick
//我这里只是演示并没有添加UIScrollView，只是打印了UIWebView的内容高度变化的数值
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        __block NSString *heightString;
        [_viewFront.wkWebForTribe evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
            heightString = resultString;
            //在取到wkweb更大高度值时进行刷新
            if([heightString floatValue] > tmpHeight) {
                CardView * viewWithWeb = [self.view viewWithTag:POSITION_FRONT];
                viewWithWeb.heightForWeb = [heightString floatValue];
                tmpHeight = [heightString floatValue];
                [viewWithWeb refreshViewWithData];
            }
        }];
    } else if ([keyPath isEqualToString:@"contentOffset"]) {
        //实时渲染wkweb
        [_viewFront.wkWebForTribe setNeedsLayout];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [self setUpNav];
    NSLog(@" %s ",__FUNCTION__);
    
    __block NSString *heightString;
    __block NSString *relativeString;
    __block NSString *tmpZan;
    __block NSString *tmpCollect;
    
    //nslog(@" --- %s --- ",__FUNCTION__);
        
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        heightString = resultString;
        tmpHeight = [heightString floatValue];
//        NSLog(@"---heightString = %f",tmpHeight);
        CardView * viewWithWeb = [self.view viewWithTag:POSITION_FRONT];
        viewWithWeb.heightForWeb = tmpHeight;
        [viewWithWeb refreshViewWithData];
        [[HNBLoadingMask shareManager] dismiss];
    }];
    
    [webView evaluateJavaScript:@"window.APP_LZ_ID" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        LZId = resultString;
        /*判断是不是本人的帖子，如果是，显示可编辑*/
        NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
        PersonalInfo * UserInfo = nil;
        if (tmpPersonalInfoArry.count != 0) {
            UserInfo = tmpPersonalInfoArry[0];
            if ([UserInfo.id isEqualToString:LZId]) {
                [_moreButton setBackgroundImage:[UIImage imageNamed:@"Tribe_Editor_More"]forState:UIControlStateNormal];
                [_moreButton addTarget:self action:@selector(showMore)
                      forControlEvents:UIControlEventTouchUpInside];
            }else {
                [_moreButton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
                [_moreButton addTarget:self action:@selector(shareContent)
                      forControlEvents:UIControlEventTouchUpInside];
            }
        }else {
            [_moreButton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
            [_moreButton addTarget:self action:@selector(shareContent)
                  forControlEvents:UIControlEventTouchUpInside];
        }
        _moreButton.hidden = NO;
        
        
        [DataFetcher showPersonnalInfoWithPersonId:LZId withSucceedHandler:^(id JSON) {
            //获取楼主的个人信息
            _viewFront.lzInfo = JSON;
            [_viewFront.tableView reloadData];
        } withFailHandler:^(id error) {
            
        }];
    }];
    
    [webView evaluateJavaScript:@"window.APP_IS_PRAISE" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        tmpZan = [NSString stringWithFormat:@"%@",resultString];
        if ([tmpZan isEqualToString:@"1"]) {
            isZan = TRUE;
            [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan_pressed"]];
        }
        else
        {
            isZan = FALSE;
            [self.replyInputView.zanImageView setImage:[UIImage imageNamed:@"tribe_show_zan"]];
        }
    }];
    
    [webView evaluateJavaScript:@"window.APP_IS_FAVORITE" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        tmpCollect = [NSString stringWithFormat:@"%@",resultString];
        isCollected = tmpCollect;
        if ([isCollected isEqualToString:@"1"]) {
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default2"]];
        }
        else
        {
            [self.replyInputView.collectImageView setImage:[UIImage imageNamed:@"detial_toolbar_mark_btn_default"]];
        }
    }];
    
    
    [webView evaluateJavaScript:@"APP_THEME_RELATIVE" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        relativeString = resultString;
        NSDictionary *tmpDic = [self dicWithJsonString:relativeString];
        [self loadDataWithDic:tmpDic];
    }];
    
    [webView evaluateJavaScript:@"window.APP_SHARE_TITLE" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        shareTitle = resultString;
    }];
    
    [webView evaluateJavaScript:@"window.APP_SHARE_FRIEND_DESC" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        shareDesc = resultString;
    }];
    
    [webView evaluateJavaScript:@"window.APP_SHARE_URL" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        shareURL = resultString;
    }];
    
    [webView evaluateJavaScript:@"window.APP_SHARE_FRIEND_TITLE" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        shareFriendTitle = resultString;
    }];
    
    [webView evaluateJavaScript:@"window.APP_SHARE_IMG" completionHandler:^(id _Nullable resultString, NSError * _Nullable error) {
        shareImageUrl = resultString;
    }];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark ------  字符串转字典

- (NSDictionary *)dicWithJsonString:(NSString *)jsonStriing{
    
    if (jsonStriing == nil || jsonStriing.length <= 0) {
        return nil;
    }
    
    NSData *jsonData = [jsonStriing dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        return nil;
    }
    
    return dic;
    
}

- (void)loadDataWithDic:(NSDictionary *)info{
    
    NSDictionary *nationDic = [info objectForKey:@"nation"];
    NSArray *themes = [info objectForKey:@"themeList"];
    
    
    if (nationDic != nil && [nationDic isKindOfClass:[NSDictionary class]]) {
        
        NSString *nationName = [nationDic objectForKey:@"title"];
        if (nationName != nil && nationName.length > 0 && ![nationName isEqualToString:@"null"]) {
            
            _viewFront.funcDic = nationDic;
            
        }
        
    }
    
    if ([themes isKindOfClass:[NSArray class]] && themes != nil && themes.count > 0) {
        
        for (NSInteger cou = 0; cou < themes.count; cou ++) {
            
            NSDictionary *dict = themes[cou];
            TribeThemeModel *f = [TribeThemeModel new];
            f.title = [dict objectForKey:@"title"];
            f.id = [dict objectForKey:@"id"];
            [_viewFront.relContents addObject:f];
            
        }
        
    }
    
    [_viewFront refreshViewWithData];
    
}

#pragma mark ------ tool Methed

- (void)setURL:(NSURL *)URL{
    
    NSString *URLString = URL.absoluteString;
    
    // 处理URL
    if ([URLString rangeOfString:@"detailforapp"].location == NSNotFound &&
        [URLString rangeOfString:@"detail"].location != NSNotFound) {
        URLString = [URLString stringByReplacingOccurrencesOfString:@"detail" withString:@"detailforapp"];
    }
    URLString = [URLString stringByReplacingOccurrencesOfString:@"www." withString:@"m."];
    
    // 赋值
    [super setURL:[NSURL URLWithString:URLString]];
    
    // 提取 帖子 id
    NSArray *tmps0 = [URLString componentsSeparatedByString:@"/theme/detailforapp/"];
    NSArray *tmps1 = [[tmps0 lastObject] componentsSeparatedByString:@".ht"];
    NSString *resultString = [tmps1 firstObject];
    if ([resultString rangeOfString:@"/"].location != NSNotFound) {
        /*只取帖子ID*/
        resultString = [resultString substringToIndex:[resultString rangeOfString:@"/"].location];
    }
    _detailThemID = resultString;
}

- (void)setUpNav{

//    _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    _moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"share_button_normal"]forState:UIControlStateNormal];
    _moreButton.hidden = NO;
    
    _topBarrightButton  = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 43, 18)];
    [_topBarrightButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_lz"]forState:UIControlStateNormal];
    [_topBarrightButton addTarget:self action:@selector(lookLZ) forControlEvents:UIControlEventTouchUpInside];
    _topBarrightButton.custom_acceptEventInterval = 0.4f;
    
    UIView *tmp  = [[UIView alloc] initWithFrame:CGRectMake(0,0, 8, 8)];
    UIBarButtonItem *ButtonOne = [[UIBarButtonItem alloc] initWithCustomView:_topBarrightButton];
    UIBarButtonItem *ButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:_moreButton];
    UIBarButtonItem *ButtonCenter = [[UIBarButtonItem alloc] initWithCustomView:tmp];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: ButtonTwo, ButtonCenter, ButtonOne,nil]];
    
}

- (void)showMore {
    
    if (!moreActionSheetView) {
        
        void (^functionShare)(void) = ^{
            [self shareContent];
        };
        void (^functionEdit)(void) = ^{
            [self editorContent];
        };
        void (^functionDelete)(void) = ^{
            [self deleteContent];
        };
        
        NSDictionary *dic = @{
                              MoreActionSheet_Title  :@"分享",
                              MoreActionSheet_Image  :@"Tribe_Editor_Share",
                              MoreActionSheet_Func   :functionShare,
                              };
        NSDictionary *dic2 = @{
                               MoreActionSheet_Title  :@"编辑",
                               MoreActionSheet_Image  :@"Tribe_Editor_Write",
                               MoreActionSheet_Func   :functionEdit,
                               };
        NSDictionary *dic3 = @{
                               MoreActionSheet_Title  :@"删除",
                               MoreActionSheet_Image  :@"Tribe_Editor_Delete",
                               MoreActionSheet_Func   :functionDelete,
                               };

        NSArray *tempArr = [[NSArray alloc] initWithObjects:dic,dic2,dic3, nil];
        
        moreActionSheetView = [[MoreActionSheetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight)];
        [[UIApplication sharedApplication].keyWindow addSubview:moreActionSheetView];
        [moreActionSheetView setBtnArray:tempArr];
    }else {
        [[UIApplication sharedApplication].keyWindow addSubview:moreActionSheetView];
    }
    
//    if (!moreView) {
//         moreView = [[TribeMoreView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight) isShare:YES isEditor:YES isDelete:YES];
//        [[UIApplication sharedApplication].keyWindow addSubview:moreView];
//    }else {
//        [[UIApplication sharedApplication].keyWindow addSubview:moreView];
////        moreView.hidden = NO;
//    }
//    __weak typeof(self) weakSelf = self;
//    [moreView setShareContent:^{
//        [weakSelf shareContent];
//    }];
//    [moreView setEditorContent:^{
//        [weakSelf editorContent];
//    }];
//    [moreView setDeleteContent:^{
//        [weakSelf deleteContent];
//    }];
}

#pragma mark ------ editorContent deleteContent

- (void)editorContent {
    [DataFetcher getThemeInfoWithThemeID:_detailThemID withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        if (errCode == 0) {
            NSDictionary *dataDic = [JSON valueForKey:@"data"];
            NSString *contentHTML;
            NSString *titleHTML;
            if (dataDic) {
                titleHTML   = [dataDic valueForKey:@"title"];
//                contentHTML = [dataDic valueForKey:@"content"];
                contentHTML = [dataDic valueForKey:@"content_app"];
                NSLog(@" \n \n 后台 DOM 树 :%@ ",contentHTML);
                NSLog(@" \n \n ");
                HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
                [vc setHTML:contentHTML title:titleHTML];
                vc.choseTribeCode = theTribeID;
                vc.chosedTribeName = theTribeName;
                vc.tribeThemCode = _detailThemID;
                vc.entryOrigin = PostingEntryOriginEditingOldTribeThem;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
    } withFailHandler:^(id error) {
        
    }];
    
}

- (void)deleteContent {
//    NSString *deleteTitle = [NSString stringWithFormat:@"确定删除 %@ 该操作无法逆转",shareTitle];
//    if (!shareTitle || [shareTitle isEqualToString:@""]) {
//        deleteTitle = [NSString stringWithFormat:@"确定删除这篇文章 该操作无法逆转"];
//    }
    NSString *deleteTitle = [NSString stringWithFormat:@"确定删除吗?"];
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:deleteTitle
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [aler show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [DataFetcher deleteThemeWithThemeID:_detailThemID withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            if (errCode == 0) {
                //删除成功返回上一层
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withFailHandler:^(id error) {
            
        }];
        
    }
    
}

- (void)shareContent{
    if (![shareTitle isEqualToString:@""] && shareTitle != Nil)
    {
        NSDictionary *dict = @{@"url" : shareURL};
        [HNBClick event:@"107012" Content:dict];
        NSString *curUrlStrForShare = [NSString stringWithFormat:@"%@",[self.URL absoluteString]];
        NSDictionary *dic = @{@"idForThem":curUrlStrForShare};
        [MobClick event:@"clickShare" attributes:dic];
        
        [UMSocialShareUIConfig shareInstance].shareTitleViewConfig.isShow = NO;
        [UMSocialShareUIConfig shareInstance].shareCancelControlConfig.isShow = NO;
        //调用分享面板
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            
            
            if (platformType == UMSocialPlatformType_Sina) {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                msgObj.text = [NSString stringWithFormat:@"%@ %@",shareTitle,shareURL];
                
                UMShareImageObject *sharedObj = [[UMShareImageObject alloc] init];
                sharedObj.thumbImage = [HNBUtils getImageFromURL:shareImageUrl];
                sharedObj.shareImage = [HNBUtils getImageFromURL:shareImageUrl];
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }else if (platformType == UMSocialPlatformType_WechatSession){
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareFriendTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
            } else {
                
                UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
                
                UMShareWebpageObject *sharedObj = [UMShareWebpageObject shareObjectWithTitle:shareTitle
                                                                                       descr:shareDesc
                                                                                   thumImage:[HNBUtils getImageFromURL:shareImageUrl]];
                sharedObj.webpageUrl = shareURL;
                msgObj.shareObject = sharedObj;
                
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:msgObj
                                            currentViewController:self
                                                       completion:nil];
                
            }
            
        }];
        
        
        
    }
    
    
    
}

/* 查看楼主 */
-(void) lookLZ{
    
    if (!isLZ) {
        isLZ = TRUE;
        /* 跳到首页 */
        isReFresh = TRUE;
        [self jumpToFirstPage];
        [_topBarrightButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_all"]forState:UIControlStateNormal];
        NSDictionary *dict = @{@"state" : @"0"};
        [HNBClick event:@"107011" Content:dict];
    }
    else
    {
        isLZ = FALSE;
        /* 跳到首页 */
        isReFresh = TRUE;
        [self jumpToFirstPage];
        [_topBarrightButton setBackgroundImage:[UIImage imageNamed:@"tribe_show_lz"]forState:UIControlStateNormal];
        NSDictionary *dict = @{@"state" : @"1"};
        [HNBClick event:@"107011" Content:dict];
    }
    
}


/*网页举报按钮响应方法*/
- (void)jumpIntoReport:(NSArray *)infoArr{
    
    NSLog(@" %s ",__FUNCTION__);
    
    _curentTypeForReport = [NSString stringWithFormat:@"%@",[infoArr firstObject]];
    _currentIDForReport = [NSString stringWithFormat:@"%@",[infoArr lastObject]];
    
    DownSheet *sheet = [[DownSheet alloc]initWithlist:self.downSheetModelDataSources height:0];
    sheet.delegate = self;
    [sheet showInView:self.view];
    
}

- (void)back{
    
    NSLog(@" %s ",__FUNCTION__);
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ------ DownSheetDelegate

- (void)didSelectIndex:(NSInteger)index{
    
    DownSheetModel *f = self.downSheetModelDataSources[index];
    NSString *desc = f.title;
    [_manager reportWithType:_curentTypeForReport reportId:_currentIDForReport desc:desc];
    
}

#pragma mark ------ ReplyTableViewDelegate
/* 刷新加载最后一页 */
-(void) refreshLastPage
{
    isReFresh = TRUE;
    [self setDataInView:_viewFront forIndex:_allPageNum-1 toToporBottom:TABLEVIEW_DEFAULT];
}
-(void)replyTableView:(CardView *)view didClickEvent:(id)eventSource info:(id)info{
    
    PersonalInfo *f = [[PersonalInfo MR_findAll] firstObject];
    
    if ([info isKindOfClass:[TribeDetailInfoCellManager class]]) {
        
        TribeDetailInfoCellManager *manager = (TribeDetailInfoCellManager *)info;
        ReplyDetailInfoController *vc = [[ReplyDetailInfoController alloc] init];
        vc.manager = manager;
        vc.themeId = _detailThemID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([eventSource isKindOfClass:[NSString class]] && [eventSource isEqualToString:@"FuncAssessEntry"])
    {
        
        IndexFunctionStatus *imassessModel = [HNBUtils decodeCustomDataModelFromFilePath:homePage_func_imassess_fileName];
        if (imassessModel == nil) {
            IMAssessVC *vc = [[IMAssessVC alloc] init];           // 原生化
            [self.navigationController pushViewController:vc animated:YES];
            return ;
        }
        if([[HNBUtils sandBoxGetInfo:[NSString class] forKey:im_assess_type] isEqualToString:@"1"])    //原生
        {
            if (IOS_VERSION < 8.0) { // 版本低于 8.0 时调用 web页
                IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
                NSString *urlStr = [NSString stringWithFormat:@"%@?country=%@",imassessModel.url,countryStr];
                vc.URL = [NSURL URLWithString:urlStr];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                IMAssessVC *vc = [[IMAssessVC alloc] init];           // 原生化
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
        else
        {
            IMAssessViewController * vc = [[IMAssessViewController alloc] init]; // skiplow － web页
            NSString *urlStr = [NSString stringWithFormat:@"%@?country=%@",imassessModel.url,countryStr];
            vc.URL = [NSURL URLWithString:urlStr];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }
    else if([eventSource isKindOfClass:[NSString class]] && [eventSource isEqualToString:@"FuncThemeEntry"])
    {
        TribeDetailInfoViewController * vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:[NSString stringWithFormat:@"https://m.hinabian.com/theme/detail/%@",info]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if([eventSource isKindOfClass:[NSString class]] && [eventSource isEqualToString:@"FuncNationEntry"])
    {
 
        SWKCommonWebVC *vc = [[SWKCommonWebVC alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:info];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        NSString *infostring = (NSString *)info;
        if (infostring == nil || infostring .length <= 0) {
            return;
        }
        
        
        if ([eventSource isKindOfClass:[UITapGestureRecognizer class]]) {
            
            // icon - ReplyTableViewCellIconTag
            if ([infostring isEqualToString:f.id] || infostring == nil) {
                return;
            }
            UserInfoController2 *vc = [[UserInfoController2 alloc]init];
            vc.personid = infostring;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if ([eventSource isKindOfClass:[UIButton class]]) {
            
            
            UIButton *btn = (UIButton *)eventSource;
            switch (btn.tag) {
                case 103:
                { // ReplyTableViewCellSupportTag 点赞
                    
                    if (![HNBUtils isLogin]) {
                        LoginViewController *vc = [[LoginViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        return;
                    }
                    
                    NSArray *strs = [infostring componentsSeparatedByString:@"FlooId:"];
                    NSInteger isPraised = [[strs firstObject] integerValue];
                    NSString *floorId = [strs lastObject];
                    [self ZanComment:floorId Praise:isPraised];
                    
                }
                    break;
                case 104:
                { // ReplyTableViewCellReportTag
                    
                    _curentTypeForReport = @"tribe-comment";
                    _currentIDForReport = infostring;
                    DownSheet *sheet = [[DownSheet alloc]initWithlist:self.downSheetModelDataSources height:0];
                    sheet.delegate = self;
                    [sheet showInView:self.view];
                    
                }
                    break;
                    
                case 105:
                { // ReplyTableViewCellSeeMoreTag
                    // H5  https://m.hinabian.com/theme/commentDetail/6514061058433093959?floor=4
                    //                        NSString *urlString = [NSString stringWithFormat:@"%@/theme/commentDetail/%@",H5APIURL,infostring];
                    //                        NSURL * URL = [NSURL URLWithString:urlString];
                    //                        SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
                    //                        vc.URL = URL;
                    //                        [self.navigationController pushViewController:vc animated:YES];
                    
                    // 原生
                    //                        TribeDetailInfoCellManager *manager = (TribeDetailInfoCellManager *)info;
                    //                        ReplyDetailInfoController *vc = [[ReplyDetailInfoController alloc] init];
                    //                        vc.manager = manager;
                    //                        vc.themeId = _detailThemID;
                    //                        [self.navigationController pushViewController:vc animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
            
        }else if ([eventSource isKindOfClass:[NSString class]] && [infostring hasPrefix:@"CommentView_userName:"]){
            
            NSArray *strs = [infostring componentsSeparatedByString:@"CommentView_userName:"];
            NSString *personID = [strs lastObject];
            if ([personID isEqualToString:f.id] || personID == nil) {
                return;
            }
            UserInfoController2 *vc = [[UserInfoController2 alloc]init];
            vc.personid = personID;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if ([eventSource isKindOfClass:[NSString class]] && [infostring hasPrefix:@"hyper:"]){
            
            NSArray *strs = [infostring componentsSeparatedByString:@"hyper:"];
            NSString *hyper = [strs lastObject];
            hyper = [hyper stringByReplacingOccurrencesOfString:@"www" withString:@"m"];
            //hyper = [hyper stringByReplacingOccurrencesOfString:@"detail" withString:@"detailforapp"];
            [[HNBWebManager defaultInstance] jumpHandleWithURL:hyper nav:self.navigationController jumpIntoAPP:FALSE];
            
        }
        
        
        
    }
    
}

#pragma mark ------ clickEvent
- (void) ZanComment:(NSString *) commentId Praise:(NSInteger)isPraised
{
    if (isPraised) {
        //        NSDictionary *dict = @{@"state" : @"1"};
        //        [HNBClick event:@"107022" Content:dict];
        [DataFetcher doZanCommentWithId:commentId withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                NSLog(@"发送成功");
                
                //isReFresh = TRUE;
                //[self setDataInView:_viewFront forIndex:_pageIndex toToporBottom:TABLEVIEW_DEFAULT];
                if (_pageIndex >=0 && _pageIndex < _dataSourceArr.count)
                {
                    NSMutableArray *tmpArray = _dataSourceArr[_pageIndex];
                    for (TribeDetailInfoCellManager * f in tmpArray) {
                        if ([f.model.floorId isEqualToString:commentId]) {
                            f.model.praised = FALSE;
                            f.model.praise = [NSString stringWithFormat:@"%ld",([f.model.praise integerValue] - 1)];
                            f.model.praise = [f.model.praise integerValue] <= 0 ? @"" : f.model.praise;
                            break;
                        }
                    }
                    //[_viewFront.tableView reloadData];
                    [_viewFront reqSourceDataWithData:tmpArray];
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
            }
            
            
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
            [[HNBToast shareManager] toastWithOnView:nil msg:@"取消点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
        }];
    }
    else
    {
        //        NSDictionary *dict = @{@"state" : @"0"};
        //        [HNBClick event:@"107022" Content:dict];
        [DataFetcher doZanCommentWithId:commentId withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                NSLog(@"发送成功");
                
                //isReFresh = TRUE;
                //[self setDataInView:_viewFront forIndex:_pageIndex toToporBottom:TABLEVIEW_DEFAULT];
                if (_pageIndex >=0 && _pageIndex < _dataSourceArr.count) {
                    NSMutableArray *tmpArray = _dataSourceArr[_pageIndex];
                    for (TribeDetailInfoCellManager * f in tmpArray) {
                        if ([f.model.floorId isEqualToString:commentId]) {
                            f.model.praised = TRUE;
                            f.model.praise = [NSString stringWithFormat:@"%ld",([f.model.praise integerValue] + 1)];
                            break;
                        }
                    }
                    //[_viewFront.tableView reloadData];
                    [_viewFront reqSourceDataWithData:tmpArray];
                    [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞成功" afterDelay:1.0 style:HNBToastHudSuccession];
                }
                
            }
            
        } withFailHandler:^(NSError* error) {
            NSLog(@"errCode = %ld",(long)error.code);
            [[HNBToast shareManager] toastWithOnView:nil msg:@"点赞失败" afterDelay:1.0 style:HNBToastHudFailure];
        }];
    }
    
}
- (void) attentionButtonPress
{
    /* 是否登录  */
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (!_f.statue) {
        [DataFetcher addFollowTribeWithParameter:_f.triebId withSucceedHandler:^(id JSON) {
            _f.statue = TRUE;
            _viewFront.tribInfo = _f;
            countryStr = _f.country;
            [_viewFront.tableView reloadData];
            
        } withFailHandler:^(id error) {
            
            
        }];
    }
    else{
        [DataFetcher removeFollowTribeWithParameter:_f.triebId withSucceedHandler:^(id JSON) {
            _f.statue = FALSE;
            _viewFront.tribInfo = _f;
            countryStr = _f.country;
            [_viewFront.tableView reloadData];
            
        } withFailHandler:^(id error) {
            
            
        }];
    }
    
}
- (void)tribeButtonPress {
    TribeShowNewController * vc = [[TribeShowNewController alloc] init];
    vc.tribeId = _f.triebId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickCareBtn:(NSNotification *)nofy {
    NSDictionary *info = (NSDictionary *)[nofy object];
    PersonInfoModel *f = (PersonInfoModel *)[info valueForKey:@"model"];
    _careBtn = (UIButton *)[info valueForKey:@"btn"];
    if (![HNBUtils isLogin]) {
        _isCareAferLogin = YES;
        [self gotoLogin];
        return;
    }else {
        if ([f.personID isEqualToString:hainabian_xiaozuli_id]) {
            //海那边小助理不允许取关
            return;
        }
    }
    [self toCare:f];
    
}

- (void)clickHeadBtn:(NSNotification *)nofy{
    
    PersonInfoModel *f = (PersonInfoModel *)[nofy object];
    UserInfoController2 *vc = [[UserInfoController2 alloc] init];
    vc.personid = f.personID;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)toCare:(PersonInfoModel *)f {
    if ([f.isFollow isEqualToString:@"1"]) {
        [DataFetcher removeFollowWithParameter:f.personID withSucceedHandler:^(id JSON) {
            [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_careBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
            _careBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
            f.isFollow = @"0";
        } withFailHandler:^(id error) {
            [_careBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_careBtn setTitleColor:[UIColor DDR102_G102_B102ColorWithalph:1.0f] forState:UIControlStateNormal];
            _careBtn.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:1.0].CGColor;
        }];
        
    }else{ // 点击执行增加关注
        
        [DataFetcher addFollowWithParameter:f.personID withSucceedHandler:^(id JSON) {
            [_careBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [_careBtn setTitleColor:[UIColor DDR102_G102_B102ColorWithalph:1.0f] forState:UIControlStateNormal];
            _careBtn.layer.borderColor = [UIColor DDR102_G102_B102ColorWithalph:1.0].CGColor;
            f.isFollow = @"1";
        } withFailHandler:^(id error) {
            [_careBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_careBtn setTitleColor:[UIColor DDNavBarBlue] forState:UIControlStateNormal];
            _careBtn.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
        }];
        
    }
    
}


- (void)gotoLogin{
    
    LoginViewController *vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark -- 懒加载

-(UIView *)maskView
{
    if (!_maskView) {
        CGRect rectNav = self.navigationController.navigationBar.frame;
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT  - 44 - rectNav.size.height - rectStatus.size.height - 220)];
        _maskView.hidden = YES;
        [_maskView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:_maskView];
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [_maskView addGestureRecognizer:singleTap];
        singleTap.delegate = (id)self;
        singleTap.cancelsTouchesInView = NO;
        
    }
    return _maskView;
}


- (NSMutableArray *)downSheetModelDataSources{
    
    if (_downSheetModelDataSources == nil) {
        
        _downSheetModelDataSources = [[NSMutableArray alloc] init];
        NSArray *titles = @[@"垃圾内容",@"虚假广告",@"色情暴力",@"政治敏感",@"恶意仇恨"];
        for (NSInteger cou = 0; cou < titles.count; cou ++) {
            
            DownSheetModel *f = [[DownSheetModel alloc] init];
            f.title = titles[cou];
            [_downSheetModelDataSources addObject:f];
            
        }
        
    }
    
    return _downSheetModelDataSources;
    
}

@end
