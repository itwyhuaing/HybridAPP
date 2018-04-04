//
//  TribeIndexNewViewController.m
//  hinabian
//
//  Created by 余坚 on 16/6/6.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "TribeIndexNewViewController.h"
#import "RDVTabBarController.h"
#import "TribeIndexMainView.h"
#import "DataFetcher.h"
#import "RDVTabBarItem.h"
#import <WebKit/WebKit.h>

@interface TribeIndexNewViewController ()

@property (strong, nonatomic) TribeIndexMainView *tribeMainview;


@end

@implementation TribeIndexNewViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"圈子";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tribeMainview = [[TribeIndexMainView alloc] init];
    _tribeMainview.superController = self;
    _tribeMainview.tribeManager.superController = self;
    self.view = _tribeMainview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIColor createImageWithColor:[UIColor DDNavBarBlue]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //[[self rdv_tabBarController] setTabBarHidden:TRUE animated:YES];
    
    //显示原生的NavigationBar
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.translucent = NO;
    
    /* 如果从login界面跳转需要重新加载 */
    NSString * isFromLogin = [HNBUtils sandBoxGetInfo:[NSString class] forKey:login_change_to_assess];
    if ([isFromLogin isEqualToString:@"1"]) {
        [HNBUtils sandBoxSaveInfo:@"0" forKey:login_change_to_assess];
    }
    
    [[self rdv_tabBarController] setTabBarHidden:FALSE animated:YES];
    
    if ([HNBUtils isLogin]) {
        [HNBUtils uploadAssessRlt];
    }
    
    [HNBClick event:@"201041" Content:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 离开之后不允许再展示新功能
//    if (_tribeMainview.postMask != nil) {
//        [_tribeMainview.postMask removeFromSuperview];
//        _tribeMainview.postMask = nil;
//    }
//    if (_tribeMainview.writingImgV != nil) {
//        [_tribeMainview.writingImgV removeFromSuperview];
//        _tribeMainview.writingImgV = nil;
//    }
//    [HNBUtils sandBoxSaveInfo:@"1" forKey:tribeView_newFunction_writingpost];
    
    if (_tribeMainview.postMask != nil) {
        [_tribeMainview.postMask removeFromSuperview];
    }
    [HNBUtils sandBoxSaveInfo:@"1" forKey:tribeView_newFunction_writingpost];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



/**
 * 富文本发帖预加载js ,此处可关闭
 */
- (void)preLoadRichTextWeb{
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSBundle *bundle = [NSBundle mainBundle];
//        NSString *filePath = [bundle pathForResource:@"editor" ofType:@"html"];
//        NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
//        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
//        
//        //Add jQuery.js to the html file
//        NSString *jquery = [bundle pathForResource:@"jQuery" ofType:@"js"];
//        NSString *jqueryString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jquery] encoding:NSUTF8StringEncoding];
//        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jQuery -->" withString:jqueryString];
//        
//        //Add JSBeautifier.js to the html file
//        NSString *beautifier = [bundle pathForResource:@"JSBeautifier" ofType:@"js"];
//        NSString *beautifierString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:beautifier] encoding:NSUTF8StringEncoding];
//        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jsbeautifier -->" withString:beautifierString];
//        
//        //Add ZSSRichTextEditor.js to the html file
//        NSString *source = [bundle pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
//        NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
//        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
//        
//        WKWebView *wkweb = [[WKWebView alloc] init];
//        [wkweb loadHTMLString:htmlString baseURL:nil];
//    });
    
}

@end
