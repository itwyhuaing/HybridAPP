//
//  HNBPreviewImageViewController.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/15.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBPreviewImageViewController.h"

@implementation HNBGalleryItem

@end

@interface HNBPreviewImageViewController ()

@property (nonatomic, strong)   UIImageView *galleryImageView;
@property (nonatomic, strong)   NIMSession *session;
@property (nonatomic,strong)    HNBGalleryItem *currentItem;

@end

@implementation HNBPreviewImageViewController

- (instancetype)initWithItem:(HNBGalleryItem *)item session:(NIMSession *)session
{
    if (self = [super init])
    {
        _currentItem = item;
        _session = session;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    _galleryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - rectNav.size.height - rectStatus.size.height)];
    [self.view addSubview:_galleryImageView];
    
    _galleryImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSURL *url = [NSURL URLWithString:_currentItem.imageURL];
    [_galleryImageView sd_setImageWithURL:url
                         placeholderImage:[UIImage imageWithContentsOfFile:_currentItem.thumbPath]
                                  options:SDWebImageRetryFailed];
    
    if ([_currentItem.name length])
    {
        self.navigationItem.title = _currentItem.name;
    } 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDR51_G51_B51ColorWithalph:1.0f]] forBarMetrics:UIBarMetricsDefault];
    //设置tint颜色值
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //设置导航栏字体大小
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationItem hidesBackButton];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
