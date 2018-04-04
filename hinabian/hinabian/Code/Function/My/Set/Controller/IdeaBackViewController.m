//
//  IdeaBackViewController.m
//  hinabian
//
//  Created by 何松泽 on 16/1/8.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#define DISTANCE        10
#define TEXTVIEW_HEIGHT 200*SCREEN_SCALE
#define TEXT_FONT_SIZE  12.f
#define CONNECT_TEXTFIELD_HEIGHT 35*SCREEN_SCALE

#import "IdeaBackViewController.h"
#import "RDVTabBarController.h"
#import "HNBToast.h"
#import "DataFetcher.h"

@interface IdeaBackViewController ()<UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation IdeaBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    // Do any additional setup after loading the view.
    //浏览器窗口
//    CGRect rectNav = self.navigationController.navigationBar.frame;
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    //抬头标签
    NSString *titleStr = @"欢迎您提出宝贵的意见和建议，您留下的每个字都将用来改善我们的软件。";
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(DISTANCE , DISTANCE , SCREEN_WIDTH - DISTANCE*2, 50)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.text = titleStr;
    _titleLabel.textColor = [UIColor DDButtonBlue];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self setUpTextView];
}

-(void)setUpTextView
{
    //意见输入框
    _postIdeaTextView = [[UITextView alloc]initWithFrame:CGRectMake(DISTANCE , _titleLabel.frame.size.height + DISTANCE , SCREEN_WIDTH - DISTANCE*2, TEXTVIEW_HEIGHT)];
    _postIdeaTextView.backgroundColor = [UIColor clearColor];
    _postIdeaTextView.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE*SCREEN_SCALE];
    _postIdeaTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    _postIdeaTextView.layer.borderWidth = 1.0f;
    _postIdeaTextView.returnKeyType = UIReturnKeyDefault;
    _postIdeaTextView.delegate = self;
    
    _placeHoldTextView = [[UITextView alloc] initWithFrame:CGRectMake(DISTANCE , _titleLabel.frame.size.height + DISTANCE , SCREEN_WIDTH - DISTANCE*2, TEXTVIEW_HEIGHT)];
    _placeHoldTextView.backgroundColor = [UIColor clearColor];
    _placeHoldTextView.textColor = [UIColor lightGrayColor];
    _placeHoldTextView.text = @"请输入您的反馈意见（500字以内）";
    _placeHoldTextView.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE*SCREEN_SCALE];
    
    //联系方式输入框
    _connectTextView = [[UITextView alloc]initWithFrame:CGRectMake(DISTANCE , _placeHoldTextView.frame.size.height + _placeHoldTextView.frame.origin.y + DISTANCE , SCREEN_WIDTH - DISTANCE*2, CONNECT_TEXTFIELD_HEIGHT)];
    _connectTextView.backgroundColor = [UIColor clearColor];
    _connectTextView.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE*SCREEN_SCALE];
    _connectTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    _connectTextView.layer.borderWidth = 1.0f;
    _connectTextView.returnKeyType = UIReturnKeyDone;
    _connectTextView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _connectTextView.delegate = self;
    
    _connectPlaceHoldTextView = [[UITextView alloc] initWithFrame:CGRectMake(DISTANCE , _placeHoldTextView.frame.size.height + _placeHoldTextView.frame.origin.y + DISTANCE , SCREEN_WIDTH - DISTANCE*2, CONNECT_TEXTFIELD_HEIGHT)];
    _connectPlaceHoldTextView.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE*SCREEN_SCALE];
    _connectPlaceHoldTextView.backgroundColor = [UIColor clearColor];
    _connectPlaceHoldTextView.textColor = [UIColor lightGrayColor];
    _connectPlaceHoldTextView.text = @"请输入您的联系方式QQ,手机号码或邮箱（选填）";
    
    
    [self.view addSubview:_connectPlaceHoldTextView];
    [self.view addSubview:_connectTextView];
    [self.view addSubview:_placeHoldTextView];
    [self.view addSubview:_postIdeaTextView];
    [self.view addSubview:_titleLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *temporaryBarButtonItemL = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItemL.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItemL.target = self;
    temporaryBarButtonItemL.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItemL;
    
    UIBarButtonItem *temporaryBarButtonItemR = [[UIBarButtonItem alloc]init];
    temporaryBarButtonItemR.title = @"发送";
    temporaryBarButtonItemR.target = self;
    temporaryBarButtonItemR.action =@selector(sendIdea);
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItemR;
}

- (void)sendIdea
{
    if (![_postIdeaTextView.text isEqualToString:@""]) {
        [DataFetcher doSetIdeaBack:[NSString stringWithFormat:@"%@#%@",_postIdeaTextView.text,_connectTextView.text] withSucceedHandler:^(id JSON) {
            int errCode = [[JSON valueForKey:@"state"] intValue];
            NSLog(@"errCode = %d",errCode);
            if (errCode == 0) {
                [[HNBToast shareManager] toastWithOnView:nil msg:@"发送成功" afterDelay:1.0 style:HNBToastHudSuccession];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withFailHandler:^(NSError *error) {
            NSLog(@"errCode = %ld",(long)error.code);
        }];
        
    }else{
        [[HNBToast shareManager] toastWithOnView:nil msg:@"请输入您的建议" afterDelay:1.0 style:HNBToastHudFailure];
    }
    
}

-(void) back_main
{
    if ([_connectTextView.text length]>0 || [_postIdeaTextView.text length]>0) {
        UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:@"是否放弃编辑"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alterview.delegate = (id)self;
        [alterview show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma ALERTVIEW DELEGATE
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //    textView == _connectTextView;
    if (textView == _postIdeaTextView) {
        if(![text isEqualToString:@""])
        {
            [_placeHoldTextView setHidden:YES];
        }
        if([text isEqualToString:@""]&&range.length==1&&range.location==0){
            [_placeHoldTextView setHidden:NO];
        }
        //    if ([text isEqualToString:@"\n"]) {
        //        [textView resignFirstResponder];
        //    }
        
        if (1 == range.length) {//按下回格键
            return YES;
        }
        //    if ([text isEqualToString:@"\n"]) {//按下return键
        //        //这里隐藏键盘，不做任何处理
        ////        [textView resignFirstResponder];
        //        return YES;
        //    }else {
        if ([textView.text length] < 500) {//判断字符个数
            return YES;
        }
        //    }
    }else if (textView == _connectTextView){
        if(![text isEqualToString:@""])
        {
            [_connectPlaceHoldTextView setHidden:YES];
        }
        if([text isEqualToString:@""]&&range.length==1&&range.location==0){
            [_connectPlaceHoldTextView setHidden:NO];
        }
        //    if ([text isEqualToString:@"\n"]) {
        //        [textView resignFirstResponder];
        //    }
        
        if (1 == range.length) {//按下回格键
            return YES;
        }
        //    if ([text isEqualToString:@"\n"]) {//按下return键
        //        //这里隐藏键盘，不做任何处理
        ////        [textView resignFirstResponder];
        //        return YES;
        //    }else {
        if ([textView.text length] < 50) {//判断字符个数
            return YES;
        }
    }
    
    return NO;
}
@end
