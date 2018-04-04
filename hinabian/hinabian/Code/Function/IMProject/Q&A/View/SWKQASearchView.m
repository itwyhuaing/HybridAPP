//
//  SWKQASearchView.m
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKQASearchView.h"
#import "SWKIMProjectShowController.h"
#import "SWKTribeShowViewController.h"
#import "TribeDetailInfoViewController.h"
#import "LoginViewController.h"
#import "SWKQuestionShowViewController.h"
#import "IMQuestionViewController.h"
#import "DataFetcher.h"
#import "HNBNetRemindView.h"

#import "HNBWKWebView.h"

#import <WebKit/WebKit.h>

#define NAVIGATIONBAR_HEIGHT 50
#define DISTANCE_TO_EDGE 10
#define SEARCH_HEIGHT 30
#define SEARCH_ICON_WIDTH 11.5
#define SEARCH_ICON_HEIGHT 13
#define BACK_BUTTON_SIZE   20
#define CANCLE_BUTTON_WIDTH 40
#define CLEAR_BUTTON_SIZE 15

@interface SWKQASearchView ()<UIWebViewDelegate,UISearchBarDelegate,UITextFieldDelegate,UITableViewDelegate,HNBNetRemindViewDelegate,WKNavigationDelegate>

@property (strong, nonatomic) UIView *SearchBarView;
@property (strong, nonatomic) UIButton *cancleButton;
@property (strong, nonatomic) UIButton *clearButton;
@property (strong, nonatomic) NSMutableArray * searchHistory;
@property (strong, nonatomic) NSMutableArray * searchSuggest;
@property (strong, nonatomic) NSString * currentUrl;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIView *inPutView;
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,strong) HNBWKWebView *wkWebView;

@end


@implementation SWKQASearchView

#pragma mark ------ init - dealloc

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor beigeColor];
        _searchManager = [[QASearchManager alloc] init];
        _searchSuggest = [[NSMutableArray alloc] init];
        _searchHistory = [[NSMutableArray alloc] initWithArray:[_searchManager getSearchHistoryArray]];
        
        [self setSearchBar];
        [self addSearchWebView:frame];
        
        self.backgroundColor = [UIColor DDNormalBackGround];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 20, frame.size.width, frame.size.height-NAVIGATIONBAR_HEIGHT - 20)];
        self.tableView.delegate = (id)self;
        self.tableView.dataSource = (id)self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        _currentUrl =  @"https://m.hinabian.com/search/qa";
    }
    return self;
}
#pragma mark ------ private Method

-(void) webback
{
    if ([self.wkWebView webCanGoBack]) {
        [self.wkWebView webGoBack];
    }
    else
    {
        [self.superController.navigationController popViewControllerAnimated:YES];
        
    }
}
- (void) addSearchWebView:(CGRect)frame
{

    self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT + 20, SCREEN_WIDTH,frame.size.height-NAVIGATIONBAR_HEIGHT - 20)
                                                delegate:self
                                               superView:self
                                                     req:nil
                                                  config:nil];
    
    
}

- (void) setSearchBar
{
    UIView *SearchBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    SearchBarView.backgroundColor = [UIColor DDNavBarBlue];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE, (NAVIGATIONBAR_HEIGHT-BACK_BUTTON_SIZE) / 2, BACK_BUTTON_SIZE, BACK_BUTTON_SIZE)];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"btn_fanhui"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(webback) forControlEvents:UIControlEventTouchUpInside];
    _backButton.hidden = TRUE;
    [SearchBarView addSubview:_backButton];
    
    _inPutView = [[UIView alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE, (NAVIGATIONBAR_HEIGHT - SEARCH_HEIGHT) / 2, SCREEN_WIDTH -DISTANCE_TO_EDGE*3-CANCLE_BUTTON_WIDTH, SEARCH_HEIGHT)];
    _inPutView.backgroundColor = [UIColor whiteColor];
    _inPutView.layer.cornerRadius = 5;
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE, (SEARCH_HEIGHT - SEARCH_ICON_HEIGHT)/2, SEARCH_ICON_WIDTH, SEARCH_ICON_HEIGHT)];
    [searchImage setImage:[UIImage imageNamed:@"search_search_icon"]];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE+SEARCH_ICON_WIDTH + 5, 0, _inPutView.frame.size.width-DISTANCE_TO_EDGE-SEARCH_ICON_WIDTH-5, SEARCH_HEIGHT)];
    _searchTextField.placeholder = @"搜索问题";
    _searchTextField.delegate = (id)self;
    [_searchTextField setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _clearButton = [[UIButton alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE+SEARCH_ICON_WIDTH + 5+_searchTextField.frame.size.width - CLEAR_BUTTON_SIZE - 5, (SEARCH_HEIGHT - CLEAR_BUTTON_SIZE)/2, CLEAR_BUTTON_SIZE, CLEAR_BUTTON_SIZE)];
    [_clearButton setBackgroundImage:[UIImage imageNamed:@"search_clear_icon"] forState:UIControlStateNormal];
    [_clearButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    _clearButton.hidden = TRUE;
    
    [_inPutView addSubview:_searchTextField];
    [_inPutView addSubview:searchImage];
    [_inPutView addSubview:_clearButton];
    
    _cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(DISTANCE_TO_EDGE*2 +_inPutView.frame.size.width, (NAVIGATIONBAR_HEIGHT - SEARCH_HEIGHT) / 2, CANCLE_BUTTON_WIDTH, SEARCH_HEIGHT)];
    [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI24PX]];
    [_cancleButton addTarget:self action:@selector(preesedCancle) forControlEvents:UIControlEventTouchUpInside];
    
    [SearchBarView addSubview:_inPutView];
    [SearchBarView addSubview:_cancleButton];
    
    [self addSubview:SearchBarView];
    [_searchTextField becomeFirstResponder];
    
    
}

/* 按下clear */
- (void) clearText
{
    _searchTextField.text = @"";
    _clearButton.hidden = TRUE;
    _tableView.hidden = FALSE;
    [_tableView reloadData];
}

/* 按下取消 */
- (void) preesedCancle
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:SEARCH_CANCLE_NOTIFICATION object:nil];
    [_superController.navigationController popViewControllerAnimated:NO];
}

/* 搜索按下 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text isEqualToString:@""]) {
        [searchBar resignFirstResponder];
        return;
    }
    [searchBar resignFirstResponder];
    _tableView.hidden = TRUE;
    
    NSString * url = nil;
    url = [NSString stringWithFormat:@"https://m.hinabian.com/search/qa?words=%@",searchBar.text];
    
    
    NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *req = [NSURLRequest requestWithURL:[[NSURL alloc] withOutNilString:encodedString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    [self.wkWebView webLoadRequest:req];
    
}

/* 判断搜索种类  0 全类搜索  1 帖子搜索  2 问答搜索 */
- (NSInteger) chargeSearchState
{
    if ([_currentUrl rangeOfString:@"words"].location != NSNotFound)
    {
        if ([_currentUrl rangeOfString:@"theme"].location != NSNotFound) {
            return 1;
        }
        else if ([_currentUrl rangeOfString:@"qa"].location != NSNotFound)
        {
            return 2;
        }
    }
    return 0;
}

- (void)selectRowAtIndexByButton:(UIButton *)sender
{
    NSInteger index = sender.tag;
    if (/*_searchSuggest.count > 0 &&*/ ![_searchTextField.text isEqualToString:@""])
    {
        [HNBClick event:@"118003" Content:nil];
        NSString * url = [NSString stringWithFormat:@"https://m.hinabian.com/search/qa?words=%@",_searchSuggest[index]];
        NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *req = [NSURLRequest requestWithURL:[[NSURL alloc] withOutNilString:encodedString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        [self.wkWebView webLoadRequest:req];
        _tableView.hidden = TRUE;
        _searchTextField.text = _searchSuggest[index];
        [_searchManager setSearchHistoryText:_searchSuggest[index]];
        _searchHistory = [[NSMutableArray alloc] initWithArray:[_searchManager getSearchHistoryArray]];
        [_searchTextField resignFirstResponder];
        _clearButton.hidden = FALSE;
    }
    else
    {
        if (index ==0) {
            
        }
        else if (index == _searchHistory.count+1)
        {
            [_searchManager removeAllArray];
            _searchHistory = [[NSMutableArray alloc] initWithArray:[_searchManager getSearchHistoryArray]];
            [_tableView reloadData];
        }
        else
        {
            [HNBClick event:@"118001" Content:nil];
            NSArray* reversedArray = [[_searchHistory reverseObjectEnumerator] allObjects];
            NSString * url = [NSString stringWithFormat:@"https://m.hinabian.com/search/qa?words=%@",reversedArray[index - 1]];
            NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURLRequest *req = [NSURLRequest requestWithURL:[[NSURL alloc] withOutNilString:encodedString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
            [self.wkWebView webLoadRequest:req];
            _tableView.hidden = TRUE;
            _searchTextField.text = reversedArray[index-1];
            [_searchTextField resignFirstResponder];
            [_searchManager setSearchHistoryText:reversedArray[index-1]];
            _searchHistory = [[NSMutableArray alloc] initWithArray:[_searchManager getSearchHistoryArray]];
            _clearButton.hidden = FALSE;
            [DataFetcher doGetQASearchRelationWords:reversedArray[index-1] withSucceedHandler:^(id JSON) {
                _searchSuggest = [JSON valueForKey:@"data"];
                
            } withFailHandler:^(id error) {
                
            }];
        }
        
    }
    
}

- (void)jumpIntoTheme:(NSArray *)inputArry
{
    if (inputArry.count < 3) {
        return;
    }
    NSString * url = [NSString  stringWithFormat:@"%@/%@",H5URL,inputArry[0]];
    NSString * url_lz = [NSString  stringWithFormat:@"%@/%@",H5URL,inputArry[2]];

    NSString *isNativeString = [HNBUtils sandBoxGetInfo:[NSString class] forKey:TRIBEDETAILTHEME_NATIVEUI_WEB];
    if ([isNativeString isEqualToString:@"1"]) {

        TribeDetailInfoViewController *vc = [[TribeDetailInfoViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        [self.superController.navigationController pushViewController:vc animated:YES];
        
    } else {
    
        SWKTribeShowViewController *vc = [[SWKTribeShowViewController alloc] init];
        vc.URL = [[NSURL alloc] withOutNilString:url];
        vc.T_ID = inputArry[1];
        vc.LZURL = [[NSURL alloc] withOutNilString:url_lz];
        [self.superController.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)jumpIntoQuestion:(NSArray *)inputArry
{
    NSLog(@"jumpIntoQuestion");
    NSString * url = [NSString  stringWithFormat:@"%@%@",H5URL,inputArry[0]];
    SWKQuestionShowViewController *vc = [[SWKQuestionShowViewController alloc] init];
    vc.URL = [[NSURL alloc] withOutNilString:url];
    vc.Q_ID = inputArry[1];
    [self.superController.navigationController pushViewController:vc animated:YES];
    
}

- (void) jumpIntoProject:(NSArray *)inputArry
{
    if (inputArry.count < 2) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * url = [NSString stringWithFormat:@"%@:%@",inputArry[0],inputArry[1]];
    SWKIMProjectShowController * vc = [[SWKIMProjectShowController alloc] init];
    vc.URL = [NSURL URLWithString:url];
    [self.superController.navigationController pushViewController:vc animated:YES];
}

- (void) jumpIntoQuestionPost
{
    //判断登录
    if (![HNBUtils isLogin]) {
        LoginViewController *vc = [[LoginViewController alloc] init];
        [self.superController.navigationController pushViewController:vc animated:YES];
        return;
    }
    IMQuestionViewController *vc = [[IMQuestionViewController alloc] init];
    [self.superController.navigationController pushViewController:vc animated:YES];
    
}

- (void)webViewDidSart{
    
    [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:SCREEN_STATUSHEIGHT +SCREEN_NAVHEIGHT];
    
}

- (void)webViewDidFinish{
    
    [[HNBLoadingMask shareManager] dismiss];
}

- (void)webViewDidError{
    
    CGRect rect = [HNBLoadingMask shareManager].frame;
    rect.origin.y = SCREEN_STATUSHEIGHT + SCREEN_NAVHEIGHT;
    HNBNetRemindView *showFailNetReqView = [[HNBNetRemindView alloc] init];
    [showFailNetReqView loadWithFrame:rect
                            superView:self
                             showType:HNBNetRemindViewShowFailNetReq
                             delegate:self];
    
}


#pragma mark ------ UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [HNBClick event:@"118002" Content:nil];
    if ([textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        return YES;
    }
    _tableView.hidden = TRUE;
    [textField resignFirstResponder];
    [_searchManager setSearchHistoryText:textField.text];
    _searchHistory = [[NSMutableArray alloc] initWithArray:[_searchManager getSearchHistoryArray]];
    NSString * url = nil;
    url = [NSString stringWithFormat:@"https://m.hinabian.com/search/qa?words=%@",textField.text];
    
    NSString* encodedString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *req = [NSURLRequest requestWithURL:[[NSURL alloc] withOutNilString:encodedString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];

    [self.wkWebView webLoadRequest:req];;
    [DataFetcher cancleAllRequest];

    return YES;
}

/* 做词汇关联操作 */
-(void)textFieldChanged:(UITextField *)textField
{
    if([textField.text isEqualToString:@""])
    {
        _clearButton.hidden = TRUE;
    }
    else
    {
        _clearButton.hidden = FALSE;
    }
    NSString *word = textField.text;
    [DataFetcher doGetQASearchRelationWords:word withSucceedHandler:^(id JSON) {
        _searchSuggest = [JSON valueForKey:@"data"];
        _tableView.hidden = FALSE;
        [_tableView reloadData];
        
    } withFailHandler:^(id error) {
        
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSString *word = textField.text;
    if (![textField.text isEqualToString:@""]) {
        [DataFetcher doGetQASearchRelationWords:word withSucceedHandler:^(id JSON) {
            _searchSuggest = [JSON valueForKey:@"data"];
            _tableView.hidden = FALSE;
            [_tableView reloadData];
            
        } withFailHandler:^(id error) {
            
        }];
    }
}

#pragma mark ------ WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    NSString *httpsurl = navigationAction.request.URL.absoluteString;
    _currentUrl = httpsurl;
    // 说明协议头是ios
    if ([@"ios" isEqualToString:navigationAction.request.URL.scheme]) {
        NSString *url = navigationAction.request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [navigationAction.request.URL.absoluteString substringFromIndex:range.location + 1];
        range = [method rangeOfString:@":"];
        
        if (range.length > 0) {
            NSString * methodTemp = [method substringToIndex:range.location];
            methodTemp = [methodTemp stringByAppendingString:@":"];
            NSLog(@"%@",methodTemp);
            
            NSString * argument = [method substringFromIndex:range.location + 1];
            NSArray * tmpArgunment = [HNBUtils getAllParameterForJS:argument];
            NSLog(@"%@",tmpArgunment);
            
            SEL selector = NSSelectorFromString(methodTemp);
            if ([self respondsToSelector:selector]) {
                [self performSelector:selector withObject:tmpArgunment];
            }
        }
        else
        {
            SEL selector = NSSelectorFromString(method);
            
            if ([self respondsToSelector:selector]) {
                [self performSelector:selector];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
    [self webViewDidSart];
    
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    [self webViewDidFinish];
    
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
    [[HNBLoadingMask shareManager] dismiss];
    [self webViewDidError];
    
}


#pragma mark ------ UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (/*_searchSuggest.count > 0 &&*/ ![_searchTextField.text isEqualToString:@""]) {
        return _searchSuggest.count;
    }
    if (_searchHistory.count>0) {
        return _searchHistory.count+2;
    }else{
        return 1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (/*_searchSuggest.count > 0 &&*/ ![_searchTextField.text isEqualToString:@""])
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
        UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        tmpButton.backgroundColor = [UIColor clearColor];
        [tmpButton addTarget:self action:@selector(selectRowAtIndexByButton:) forControlEvents:UIControlEventTouchUpInside];
        [tmpButton setTitle:_searchSuggest[indexPath.row] forState:UIControlStateNormal];
        [tmpButton setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1] forState:UIControlStateNormal];
        tmpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        tmpButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
        tmpButton.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, tmpButton.frame.size.height - 1, tmpButton.frame.size.width, 0.5f);
        bottomBorder.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
        [tmpButton.layer addSublayer:bottomBorder];
        [cell addSubview:tmpButton];
        return cell;
        
    }
    else
    {
        if(indexPath.row ==0){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            cell.textLabel.text = @"历史搜索";
            cell.textLabel.textColor = [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == _searchHistory.count+1){
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            tmpButton.backgroundColor = [UIColor clearColor];
            [tmpButton addTarget:self action:@selector(selectRowAtIndexByButton:) forControlEvents:UIControlEventTouchUpInside];
            [tmpButton setTitle:@"清除历史记录" forState:UIControlStateNormal];
            [tmpButton setTitleColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] forState:UIControlStateNormal];
            tmpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            tmpButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
            tmpButton.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, tmpButton.frame.size.height - 1, tmpButton.frame.size.width, 0.5f);
            bottomBorder.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
            [tmpButton.layer addSublayer:bottomBorder];
            [cell addSubview:tmpButton];
            
            return cell;
        }else{
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
            NSArray* reversedArray = [[_searchHistory reverseObjectEnumerator] allObjects];
            UIButton *tmpButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            tmpButton.backgroundColor = [UIColor clearColor];
            [tmpButton addTarget:self action:@selector(selectRowAtIndexByButton:) forControlEvents:UIControlEventTouchUpInside];
            [tmpButton setTitle:reversedArray[indexPath.row-1] forState:UIControlStateNormal];
            [tmpButton setTitleColor:[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1] forState:UIControlStateNormal];
            tmpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            tmpButton.contentEdgeInsets = UIEdgeInsetsMake(0,20, 0, 0);
            tmpButton.tag = indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CALayer *bottomBorder = [CALayer layer];
            bottomBorder.frame = CGRectMake(0.0f, tmpButton.frame.size.height - 1, tmpButton.frame.size.width, 0.5f);
            bottomBorder.backgroundColor = [UIColor DDIMAssessQuestionnaireHeadBgViewColor].CGColor;
            [tmpButton.layer addSublayer:bottomBorder];
            [cell addSubview:tmpButton];
            return cell;
        }
    }
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark ------ ReqNetErrorTipViewDelegate

- (void)clickOnNetRemindView:(HNBNetRemindView *)remindView{
    
    switch (remindView.tag) {
        case HNBNetRemindViewShowPoorNet:
        {
            
        }
            break;
        case HNBNetRemindViewShowFailNetReq:
        {
            
            [remindView removeFromSuperview];
            [self.wkWebView webLoadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_currentUrl]]];
            [[HNBLoadingMask shareManager] loadingMaskWithSuperView:self loadingMaskType:LoadingMaskTypeExtendTabBar yoffset:0.0];
            
        }
            break;
        case HNBNetRemindViewShowFailReleatedData:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

@end
