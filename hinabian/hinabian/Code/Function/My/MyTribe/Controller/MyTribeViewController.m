//
//  MyTribeViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/9.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "MyTribeViewController.h"
#import "RDVTabBarController.h"
#import "SWKSingleReplyViewController.h"
#import "MyOnedayViewController.h"
#import "HNBRichTextPostingVC.h"
#import "HNBFileManager.h"

@interface MyTribeViewController ()
@property (nonatomic,readwrite) BOOL isback;
@end

@implementation MyTribeViewController

- (void)viewDidLoad {
    
    if (!self.URL) {
        NSString* tmpURLString = [NSString  stringWithFormat:@"%@/%@",H5URL,@"personal_tribe.html"];
        self.URL = [[NSURL alloc] withOutNilString:tmpURLString];
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    self.title = @"我的圈子";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUpNav];
    self.isback = false;

}


- (void)setUpNav{
    UIButton *postBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_UI36PX];
    [postBtn setTitle:@"草稿" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn addTarget:self action:@selector(localDraft:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    self.navigationItem.rightBarButtonItem = barButton;
    
}

- (void)localDraft:(UIButton *)btn{

    NSDictionary *dict = [HNBFileManager readDicAPPNetInterfaceDataWithCacheKey:LOCAL_DRAFT_TRIBE_BASEINFO];
    if (dict == nil) {
        [[HNBToast shareManager] toastWithOnView:nil msg:@"暂无草稿" afterDelay:DELAY_TIME style:HNBToastHudFailure];
    }else{
        NSString *title = [dict objectForKey:@"title"];
        NSString *content = [dict objectForKey:@"content"];
        NSString *tribeID = [dict objectForKey:@"tribeID"];
        NSString *tribeName = [dict objectForKey:@"tribeName"];
        HNBRichTextPostingVC *vc = [[HNBRichTextPostingVC alloc] init];
        vc.entryOrigin = PostingEntryOriginLookOverDraft;
        [vc setHTML:content title:title];
        vc.choseTribeCode = tribeID;
        vc.chosedTribeName = tribeName;
        [vc queryAndExtractFailureModels];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache  sharedURLCache ]removeAllCachedResponses];
    NSLog(@"assess disappear");
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidStartLoad:webView navigation:navigation];
    
    self.isback = false;
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self baseToolMethodWithWebDidFinishLoad:webView navigation:navigation];
    
    [self.wkWebView evaluateJavaScriptFromString:@"document.title" hanleComplete:^(NSString *resultString) {
        self.title = resultString;
    }];

}

#pragma mark - 提供一个接口方法给JS调用
/**
 ios:jumpIntoFloor:/theme/commentDetail/7093913145367615662.html:0
 */
- (void)jumpIntoFloor:(NSArray *)inPutArry
{
    if (inPutArry.count < 2) {
        return;
    }
    NSString * urlstring = [NSString  stringWithFormat:@"%@/%@",H5URL,inPutArry[0]];
    NSURL * URL = [[NSURL alloc] withOutNilString:urlstring];
    
    SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
    vc.URL = URL;
    vc.isJumpFromTribe = inPutArry[1];
    //vc.T_ID = self.T_ID;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"jumpIntoFloor");
}

@end
