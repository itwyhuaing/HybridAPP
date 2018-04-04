//
//  TribeDetailController.m
//  hinabian
//
//  Created by 何松泽 on 2018/4/3.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import "TribeDetailController.h"
#import "TribeDetailHeaderCell.h"
#import "TribeDetailWebCell.h"
#import "TribeDetailAdCell.h"
#import "TribeDetailNewsCell.h"
#import "TribeDetailCommonCell.h"
#import "TribeDetailTitle.h"

@interface TribeDetailController ()<UITableViewDataSource,UITableViewDelegate,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic , strong) UITableView *myTableView;

@property (nonatomic , strong) WKWebView *myWebView;

@property (nonatomic , assign) CGFloat webViewMaxHeight;

/**
 页面数据源
 */
@property (nonatomic , strong) NSMutableArray *data;

@end

@implementation TribeDetailController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _webViewMaxHeight = 0;
        _data = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    [self initialView];
}

- (void)initialView {
    _myWebView = [[WKWebView alloc]init];
    _myWebView.scrollView.scrollEnabled = NO;
    _myWebView.navigationDelegate = self;
    _myWebView.UIDelegate = self;
    [_myWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    
    _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    
    [_myTableView registerClass:[TribeDetailHeaderCell class] forCellReuseIdentifier:@"TribeDetailHeaderCell"];
    [_myTableView registerClass:[TribeDetailAdCell class] forCellReuseIdentifier:@"TribeDetailAdCell"];
    [_myTableView registerClass:[TribeDetailNewsCell class] forCellReuseIdentifier:@"TribeDetailNewsCell"];
    [_myTableView registerClass:[TribeDetailCommonCell class] forCellReuseIdentifier:@"TribeDetailCommonCell"];
    [_myTableView registerClass:[TribeDetailTitle class] forHeaderFooterViewReuseIdentifier:@"TribeDetailTitle"];
    
    _myTableView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view).
    rightEqualToView(self.view).
    bottomEqualToView(self.view);
    
    //KVO
    [_myWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - LoadDataFromServer

/**
 获取评论数据

 @param loadMore 是否为加载更多
 */
- (void)loadCommonDataFromServer:(BOOL)loadMore {
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == _myWebView.scrollView) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGFloat tpHeight = _myWebView.scrollView.contentSize.height;
            if (tpHeight != _webViewMaxHeight) {
                _webViewMaxHeight = tpHeight;
                [_myTableView reloadData];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 3;
    } else if (section == 4) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //圈子头
        TribeDetailHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDetailHeaderCell"];
        return cell;
    } else if (indexPath.section == 1) {
        //帖子详情
        TribeDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDetailWebCell"];
        if (cell == nil) {
            cell = [[TribeDetailWebCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TribeDetailWebCell"];
            [cell.contentView addSubview:_myWebView];
        }
        _myWebView.frame = CGRectMake(0, 0, tableView.width, _webViewMaxHeight);
        return cell;
    } else if (indexPath.section == 2) {
        //广告
        TribeDetailAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDetailAdCell"];
        return cell;
    } else if (indexPath.section == 3) {
        //相关内容（新闻）
        TribeDetailNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDetailNewsCell"];
        return cell;
    } else if (indexPath.section == 4) {
        //评论
        TribeDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TribeDetailCommonCell"];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //圈子头
        return 32;
    } else if (indexPath.section == 1) {
        //web
        return _webViewMaxHeight;
    } else if (indexPath.section == 2) {
        //广告
        return 210;
    } else if (indexPath.section == 3) {
        //相关内容（新闻）
        return 64;
    } else if (indexPath.section == 4) {
        //评论回复
        return 100;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        //相关内容（新闻）
        TribeDetailTitle *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TribeDetailTitle"];
        headerView.title = @"相关内容";
        return headerView;
    } else if (section == 4) {
        //评论
        TribeDetailTitle *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TribeDetailTitle"];
        headerView.title = @"评论 30";
        return headerView;
    } else {
        UIView *headerView = [[UIView alloc]init];
        return headerView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3 || section == 4) {
        //相关内容（新闻 -- 评论
        return 46;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *fotterView = [[UIView alloc]init];
    fotterView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    return fotterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        //广告 -- 相关内容
        return 8;
    } else {
        return 0;
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKUIDelegate

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return [[WKWebView alloc]init];
}

- (void)dealloc {
    [_myWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
