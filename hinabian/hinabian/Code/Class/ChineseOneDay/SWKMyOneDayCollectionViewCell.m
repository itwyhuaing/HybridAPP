//
//  SWKMyOneDayCollectionViewCell.m
//  hinabian
//
//  Created by hnbwyh on 16/8/17.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "SWKMyOneDayCollectionViewCell.h"
#import "InputTextViewController.h"
#import "DataFetcher.h"
//#import "UMSocial.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "InputTextViewController.h"
#import "SWKSingleReplyViewController.h"
#import "UserInfoController2.h"
#import "LoginViewController.h"
#import "PersonalInfo.h"


#define RESOLUTION          SCREEN_HEIGHT/568
#define XIBVIEW_HEIGHT      130*RESOLUTION
#define BUTTON_RADIUS       30*RESOLUTION
#define DIRECTION_RADIUS    20*RESOLUTION
#define XIBVIEW_Y           80*RESOLUTION

@interface SWKMyOneDayCollectionViewCell ()

@end

@implementation SWKMyOneDayCollectionViewCell

#pragma mark ------ init - dealloc


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        insets  = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //等待加载背景
        self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.bgImageView.center = CGPointMake(frame.size.width/2,frame.size.height/2);
        self.bgImageView.image = [UIImage imageNamed:@"loading_web"];
        [self addSubview:self.bgImageView];

        self.wkWebView = [[HNBWKWebView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                    delegate:(id)self
                                                   superView:self
                                                         req:nil
                                                      config:nil];
        self.wkWebView.scrollView.delegate = (id)self;
        
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self initButtonView];
        [self initInputView];
        
        UIButton *btn;
        for (int i = 1; i<=5; i++) {
            btn = (UIButton *)[_buttonView viewWithTag:i];
            [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}

#pragma mark ------ private Method

- (void) jumpIntoFloor:(NSArray *)inPutArry
{
    NSString * urlstring = [NSString  stringWithFormat:@"%@/%@",H5URL,inPutArry[0]];
    NSURL * URL = [[NSURL alloc] withOutNilString:urlstring];
    
    SWKSingleReplyViewController *vc = [[SWKSingleReplyViewController alloc] init];
    vc.URL = URL;
    vc.T_ID = self.T_ID;
    [self.superController.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"jumpIntoFloor");
}

- (void)jumpIntoUserInfo:(NSArray *)inputArry
{
    if (inputArry.count < 1) {
        return;
    }
    if([inputArry[0] isEqualToString:@""])
    {
        return;
    }
    NSString * id = inputArry[0];
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if (tmpPersonalInfoArry.count != 0) {
        UserInfo = tmpPersonalInfoArry[0];
    }
    
    if (![UserInfo.id isEqualToString:id] || UserInfo == NULL) {
        // 原生
        UserInfoController2 *vc = [[UserInfoController2 alloc] init];
        vc.personid = id;
        [self.superController.navigationController pushViewController:vc animated:YES];
    }

}

- (void)initInputView
{
    CGFloat widthDistance = 5*self.frame.size.width/100;
    
    _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-49-44, self.frame.size.width, 44)];
    _inputView.backgroundColor = [UIColor DDNormalBackGround];
    _inputView.hidden = TRUE;
    
    CGFloat inputHeight = (_inputView.frame.size.height-25)/2;
    
    _inputTextView = [[UITextView alloc]initWithFrame:CGRectMake(widthDistance, inputHeight, 75*self.frame.size.width/100, 30)];
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    _inputTextView.layer.borderWidth =1.0;
    _inputTextView.layer.cornerRadius = 6;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.delegate = (id)self;
    _inputTextView.font = [UIFont systemFontOfSize:16];
    _inputTextView.alpha = 1.0f;
    
    _placeholderTextView = [[UITextView alloc]initWithFrame:CGRectMake(widthDistance, inputHeight, 75*self.frame.size.width/100, 30)];
    _placeholderTextView.backgroundColor = [UIColor whiteColor];
    _placeholderTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    _placeholderTextView.layer.borderWidth =1.0;
    _placeholderTextView.layer.cornerRadius = 6;
    _placeholderTextView.layer.masksToBounds = YES;
    _placeholderTextView.delegate = (id)self;
    _placeholderTextView.font = [UIFont systemFontOfSize:16];
    _placeholderTextView.text = @"在这里说点什么吧";
    _placeholderTextView.textColor = [UIColor lightGrayColor];
    
    [_inputView addSubview:_placeholderTextView];
    [_inputView addSubview:_inputTextView];
    
    
    UIImage *image = [UIImage imageNamed:@"OneDay_btn_sure"];
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 45- widthDistance, inputHeight, 45, 30)];
    _sendButton.layer.cornerRadius = 5;
    [_sendButton setBackgroundImage:image forState:UIControlStateNormal];
    
    [_inputView addSubview:self.sendButton];

    [self addSubview:_inputView];
}

- (void)initButtonView
{
    UIImage *image;
    //按钮之间的距离
    float distance = (self.frame.size.width - 3*BUTTON_RADIUS*2-2*DIRECTION_RADIUS*2)/6;
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HNBOneDayCommandButton" owner:self options:nil];
    _buttonView = [[UIView alloc]init];
    _buttonView = [nib objectAtIndex:0];
    _buttonView.backgroundColor = [UIColor clearColor];
    _buttonView.frame = CGRectMake(0, self.frame.size.height-XIBVIEW_Y, self.frame.size.width, XIBVIEW_HEIGHT);
    
    UIButton *btn;
    for (int i = 1; i<=5; i++) {
        btn = (UIButton *)[_buttonView viewWithTag:i];
        switch (i) {
            case LEFT_BUTTON:
            {
                btn.frame = CGRectMake(distance, (BUTTON_RADIUS - DIRECTION_RADIUS)*RESOLUTION, DIRECTION_RADIUS*2, DIRECTION_RADIUS*2);
                image = [UIImage imageNamed:@"OneDay_btn_left"];
                break;
            }
            case RIGHT_BUTTON:
            {
                btn.frame = CGRectMake(self.frame.size.width-distance-DIRECTION_RADIUS*2, (BUTTON_RADIUS - DIRECTION_RADIUS)*RESOLUTION, DIRECTION_RADIUS*2, DIRECTION_RADIUS*2);
                image = [UIImage imageNamed:@"OneDay_btn_right"];
                break;
            }
            case ZAN_BUTTON:
            {
                btn.frame = CGRectMake((self.frame.size.width/2 - BUTTON_RADIUS*3 - distance), 0, BUTTON_RADIUS*2, BUTTON_RADIUS*2);
                btn.layer.cornerRadius = BUTTON_RADIUS;
                
                zanLabel = [[UILabel alloc]init];
                zanLabel.frame = CGRectMake(btn.frame.size.width*3/5, btn.frame.origin.y+3, 24, 12);
                zanLabel.textColor = [UIColor whiteColor];
                zanLabel.font = [UIFont systemFontOfSize:10.0f];
                zanLabel.textAlignment = NSTextAlignmentCenter;
                
                [zanLabel.layer setCornerRadius:5.0f]; //设置矩形四个圆角半径
                [zanLabel.layer setBackgroundColor:[UIColor colorWithRed:4/255.0f green:102/255.0f blue:159/255.0f alpha:1].CGColor];
                [btn addSubview:zanLabel];
                
                if (_isZan) {
                    image = [UIImage imageNamed:@"OneDay_btn_afterzan"];
                }else{
                    image = [UIImage imageNamed:@"OneDay_btn_beforezan"];
                }
                break;
            }
            case COMMAND_BUTTON:
            {
                btn.frame = CGRectMake((self.frame.size.width/2 - BUTTON_RADIUS), 0, BUTTON_RADIUS*2, BUTTON_RADIUS*2);
                btn.layer.cornerRadius = BUTTON_RADIUS;
                
                commentLabel = [[UILabel alloc]init];
                commentLabel.frame = CGRectMake(btn.frame.size.width*3/5, btn.frame.origin.y+3, 24, 12);
                commentLabel.textColor = [UIColor whiteColor];
                commentLabel.font = [UIFont systemFontOfSize:10.0f];
                commentLabel.textAlignment = NSTextAlignmentCenter;
                
                [commentLabel.layer setCornerRadius:5.0f]; //设置矩形四个圆角半径
                [commentLabel.layer setBackgroundColor:[UIColor colorWithRed:4/255.0f green:102/255.0f blue:159/255.0f alpha:1].CGColor];
                [btn addSubview:commentLabel];
                
                image = [UIImage imageNamed:@"OneDay_btn_command"];
                break;
            }
            case SHARE_BUTTON:
            {
                btn.frame = CGRectMake((self.frame.size.width/2 + BUTTON_RADIUS + distance), 0, BUTTON_RADIUS*2, BUTTON_RADIUS*2);
                image = [UIImage imageNamed:@"OneDay_btn_share"];
                break;
            }
            default:
                break;
        }
        image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:_buttonView];
    _buttonView.hidden = TRUE;
}


/**
 *  @author 小泽, 15-11-11 10:11:10
 *
 *  防止连击
 *
 *  @param sender 点击的按钮
 */
- (void)buttonClicked:(id)sender
{
    if (sender == (UIButton *)[_buttonView viewWithTag:1]||sender == (UIButton *)[_buttonView viewWithTag:5]){
        //先将未到时间执行前的任务取消。
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnTouch:)object:sender];
        [self performSelector:@selector(btnTouch:)withObject:sender afterDelay:0.3f];
    }else{
        [[self class]cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnTouch:)object:sender];
        [self performSelector:@selector(btnTouch:)withObject:sender afterDelay:0.2f];
    }
}

- (void)btnTouch:(id)sender
{
    UIButton *btn = sender;
    if (btn ==(UIButton *)[_buttonView viewWithTag:2]){
        
        if (![HNBUtils isLogin]) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.superController.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        [UIView animateWithDuration:0.1f animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                btn.transform = CGAffineTransformMakeScale(1.0,1.0);
            }];
        }];
        if (_isZan) {
            [DataFetcher doCancelPraiseTheme:@"123" TID:_T_ID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    [sender setBackgroundImage:[UIImage imageNamed:@"OneDay_btn_beforezan"] forState:UIControlStateNormal];
                    _isZan = false;
                    NSInteger tmpPraise = [praiseNum integerValue];
                    tmpPraise--;
                    /*防止出现负数处理*/
                    if (tmpPraise < 0) {
                        zanLabel.hidden = YES;
                    }
                    praiseNum = [NSString stringWithFormat:@"%ld",(long)tmpPraise];
                    [zanLabel setText:praiseNum];
                    
                }
                
            } withFailHandler:^(id error) {

            }];
            
        }else{
            [DataFetcher doPraiseTheme:@"123" TID:_T_ID withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    NSLog(@"发送成功");
                    
                    [sender setBackgroundImage:[UIImage imageNamed:@"OneDay_btn_afterzan"] forState:UIControlStateNormal];
                    _isZan = true;
                    NSInteger tmpPraise = [praiseNum integerValue];
                    tmpPraise++;
                    /*防止出现负数处理*/
                    if (tmpPraise < 0) {
                        zanLabel.hidden = YES;
                    }
                    praiseNum = [NSString stringWithFormat:@"%ld",(long)tmpPraise];
                    [zanLabel setText:praiseNum];
                    
                }
                
            } withFailHandler:^(id error) {
                
            }];
        }
        
    }else if (btn ==(UIButton *)[_buttonView viewWithTag:3]){
        if (![HNBUtils isLogin]) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.superController.navigationController pushViewController:vc animated:YES];
            return;
        }
        InputTextViewController * vc = [[InputTextViewController alloc] init];
        vc.T_ID = self.T_ID;
        [self.superController.navigationController pushViewController:vc animated:YES];
    }else if (btn ==(UIButton *)[_buttonView viewWithTag:4]){
        [self shareContent];
    }
    
}

-(void) shareContent
{
//    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareURL;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareFriendTitle;
//    
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    [UMSocialSnsService presentSnsIconSheetView:self.superController
//                                         appKey:UMKEY
//                                      shareText:shareDesc
//                                     shareImage:[HNBUtils getImageFromURL:shareImageUrl]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone,nil]
//                                       delegate:(id)self];
    
    
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

#pragma mark ------ TEXTVIEW DELEGATE

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeholderTextView.hidden = FALSE;
    
    if (![_inputTextView.text isEqualToString: @""]) {
        _placeholderTextView.hidden = TRUE;
    }else{
        _placeholderTextView.hidden = FALSE;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (![_inputTextView.text isEqualToString: @""]) {
        _placeholderTextView.hidden = TRUE;
    }else{
        _placeholderTextView.hidden = FALSE;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _buttonView.hidden = FALSE;
    _inputView.hidden  = TRUE;
}


#pragma mark ANIMATE

//buttonView滚动隐去效果
-(void)buttonViewAnimate
{
    [UIView animateWithDuration:0.5 animations:^{
        _buttonView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark ------ SCROLLVIEW DELEGATE

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_inputTextView resignFirstResponder];
    if (myTimer.valid) {
        [myTimer invalidate];
        myTimer = nil;
    }
    oldContentOffsetY = scrollView.contentOffset.y;
    if (disContentOffsetY>0) {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(buttonViewAnimate) userInfo:nil repeats:NO];
    }else{
        
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (disContentOffsetY>0) {
        if (myTimer != nil) {
            [myTimer invalidate];
            myTimer = nil;
        }
        myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(buttonViewAnimate) userInfo:nil repeats:NO];
    }else
    {
        _buttonView.alpha = 1.0;
    }
    
}


/*
 滚动中，buttonView隐藏起来
 记录现在翻滚和上一次翻滚距离相差多少，判断上翻下翻
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    disContentOffsetY = scrollView.contentOffset.y - oldContentOffsetY;
    if (disContentOffsetY>0) {
        [UIView animateWithDuration:0.2 animations:^{
            _buttonView.alpha = 0;
        }];
        
    }
}

#pragma mark ------ WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    // 说明协议头是ios
    if ([@"ios" isEqualToString:navigationAction.request.URL.scheme]) {
        NSString *url = navigationAction.request.URL.absoluteString;
        NSRange range = [url rangeOfString:@":"];
        NSString *method = [navigationAction.request.URL.absoluteString substringFromIndex:range.location + 1];
        NSLog(@"%@",method);
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

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                            viewPortTag.id='viewport';  \
                            viewPortTag.name = 'viewport';  \
                            viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
                            document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)webView.bounds.size.width];
    
    [self.wkWebView evaluateJavaScriptFromString:javascript hanleComplete:nil];
    webView.alpha = 1.0f;
    
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_THEME_ID" hanleComplete:^(NSString *resultString) {
        _T_ID = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_IS_PRAISE" hanleComplete:^(NSString *resultString) {
        if ([resultString isEqualToString:@"1"]) {
            _isZan = TRUE;
            UIButton * btn;
            btn = (UIButton *)[_buttonView viewWithTag:ZAN_BUTTON];
            [btn setBackgroundImage:[UIImage imageNamed:@"OneDay_btn_afterzan"] forState:UIControlStateNormal];
        }
        else
        {
            _isZan = FALSE;
            UIButton * btn;
            btn = (UIButton *)[_buttonView viewWithTag:ZAN_BUTTON];
            [btn setBackgroundImage:[UIImage imageNamed:@"OneDay_btn_beforezan"] forState:UIControlStateNormal];
        }
        
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_TITLE" hanleComplete:^(NSString *resultString) {
        shareTitle = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_DESC" hanleComplete:^(NSString *resultString) {
        shareDesc = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_URL" hanleComplete:^(NSString *resultString) {
        shareURL = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_FRIEND_TITLE" hanleComplete:^(NSString *resultString) {
        shareFriendTitle = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_SHARE_IMG" hanleComplete:^(NSString *resultString) {
        shareImageUrl = resultString;
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_PRAISE_NUM" hanleComplete:^(NSString *resultString) {
        /*防止出现负数,(null)处理*/
        if ([resultString isEqualToString:@""] || [resultString isEqualToString:@"(null)"] || !resultString || [resultString integerValue] < 0) {
            zanLabel.hidden = YES;
        }
        praiseNum = resultString;
        [zanLabel setText:praiseNum];
    }];
    
    [self.wkWebView evaluateJavaScriptFromString:@"window.APP_COMMENT_NUM" hanleComplete:^(NSString *resultString) {
        /*防止出现负数,(null)处理*/
        if ([resultString isEqualToString:@""] || [resultString isEqualToString:@"(null)"] || !resultString || [resultString integerValue] < 0) {
            commentLabel.hidden = YES;
        }
        commentNum = resultString;
        [commentLabel setText:commentNum];
    }];
    
    _buttonView.hidden = FALSE;
    
}

@end
