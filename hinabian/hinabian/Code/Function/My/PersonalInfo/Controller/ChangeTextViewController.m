//
//  ChangeTextViewController.m
//  dada
//
//  Created by 余坚 on 15/2/4.
//  Copyright (c) 2015年 Dongxiang Cai. All rights reserved.
//

#import "ChangeTextViewController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"
#import "PersonalInfo.h"
#import "HNBToast.h"

#define BGVIEW_HEIGHT           40 // 昵称白色背景高度
#define GAP                     12 // 昵称布局间距
#define LIMITED_COUNT           30 // 兴趣爱好字数限制
#define LIMITED_SIGNATURE       60 // 签名字数限制
#define LIMITED_BRIEFINFO_COUNT 70 // 自我介绍字数限制

@interface ChangeTextViewController () <UITextViewDelegate>
{
    BOOL isTextField;
}
@property(nonatomic, copy) NSString *oldString;
@property(nonatomic, strong)UITextField * putInText;
@property (strong, nonatomic) UITextView *inputTextView;
@end

@implementation ChangeTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //隐藏原生的NavigationBar
    if(_tilteString)
    {
        self.title = _tilteString;
    }
    
    
    //self.navigationItem.hidesBackButton = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    //init mainView
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    [self.mainView setBackgroundColor:[UIColor DDBackgroundLightGray]];
    [self.mainView setTag:10];
    [self.view addSubview:self.mainView];
    
    /* 布局 */
    if (isTextField) {
        
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"editView" owner:self options:nil];
//        UIView *tmpViewItem = [nib objectAtIndex:0];
//        tmpViewItem.frame = CGRectMake(0, 10, SCREEN_WIDTH, 40);
//        self.putInText = (UITextField *)[tmpViewItem viewWithTag:1];
//        self.putInText.text = _changeString;
//        self.putInText.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [self.mainView addSubview:tmpViewItem];
//        [self.putInText becomeFirstResponder];
        
        CGRect rect = CGRectZero;
        rect.size = CGSizeMake(SCREEN_WIDTH, BGVIEW_HEIGHT);
        rect.origin.x = 0.f;
        rect.origin.y = GAP;
        UIView *bgView = [[UIView alloc] initWithFrame:rect];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.mainView addSubview:bgView];
        UITextField *tmpField = [[UITextField alloc] initWithFrame:CGRectMake(GAP, GAP/2.0, SCREEN_WIDTH - GAP * 2.0, BGVIEW_HEIGHT - GAP)];
        [bgView addSubview:tmpField];
        self.putInText = tmpField;
        self.putInText.text = _changeString;
        self.putInText.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.putInText becomeFirstResponder];
    }
    else
    {
        self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 10*2, SCREEN_HEIGHT / 3)];
        self.inputTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
        self.inputTextView.layer.borderWidth =1.0;
        self.inputTextView.layer.cornerRadius = 6;
        self.inputTextView.layer.masksToBounds = YES;
        self.inputTextView.delegate = (id)self;
        _oldString = _changeString;
        self.inputTextView.text = [self getLimitedStringFromString:_changeString type:_tilteString];
        self.inputTextView.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.inputTextView];
        /* 设置聚焦 */
        [self.inputTextView becomeFirstResponder];
    }
    
    
}

-(void)setIsTextField:(BOOL)inPutBool
{
    isTextField = inPutBool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *v  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 66)];
    v.backgroundColor = [UIColor clearColor];
    [v setTitle:@"保存" forState:UIControlStateNormal];
    [v.titleLabel setFont:[UIFont boldSystemFontOfSize:NAV_TITLE_FONT_SIZE]];
    [v setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [v setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [v addTarget:self action:@selector(changeSubmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.navigationItem.rightBarButtonItem = barButton;

    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
}


-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSubmit
{
    if ([self.putInText.text isEqual:nil]) {
        //NSLog(@"不能为空");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if ([self.putInText.text isEqual:_changeString]) {
        //NSLog(@"未修改");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSArray * tmpPersonalInfoArry = [PersonalInfo MR_findAll];
    PersonalInfo * UserInfo = nil;
    if ([_tilteString isEqual: @"昵称"]) {
        if (tmpPersonalInfoArry.count != 0 && ![self.putInText.text isEqualToString:@""]) {
            
            UserInfo = tmpPersonalInfoArry[0];
            [DataFetcher doUpdateUserInfo:UserInfo.id NickName:self.putInText.text Motto:nil Indroduction:nil Hobby:nil Im_state:nil Im_nation:nil withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    /* 修改本地数据库昵称 */
                    UserInfo.name = self.putInText.text;
                    //[UserInfo save];
                    _changeString = self.putInText.text;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }  withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];


        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:@"昵称为空" afterDelay:1.0 style:HNBToastHudFailure];
        }
        
    }
    else if ([_tilteString isEqual: @"签名"] )
    {
        if (tmpPersonalInfoArry.count != 0 && ![self.inputTextView.text isEqualToString:@""]) {
            
            UserInfo = tmpPersonalInfoArry[0];
            [DataFetcher doUpdateUserInfo:UserInfo.id NickName:nil Motto:self.inputTextView.text Indroduction:nil Hobby:nil Im_state:nil Im_nation:nil withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    /* 修改本地数据库签名 */
                    UserInfo.motto = self.inputTextView.text;
                    //[UserInfo save];
                    _changeString = self.inputTextView.text;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }  withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:@"签名为空" afterDelay:1.0 style:HNBToastHudFailure];
        }

    }
    else if ([_tilteString isEqual: @"自我介绍"])
    {
        if (tmpPersonalInfoArry.count != 0 && ![self.inputTextView.text isEqualToString:@""]) {
            
            UserInfo = tmpPersonalInfoArry[0];
            [DataFetcher doUpdateUserInfo:UserInfo.id NickName:nil Motto:nil Indroduction:self.inputTextView.text Hobby:nil Im_state:nil Im_nation:nil withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    /* 修改本地数据库自我介绍 */
                    UserInfo.indroduction = self.inputTextView.text;
                    //[UserInfo save];
                    _changeString = self.inputTextView.text;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }  withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:@"自我介绍为空" afterDelay:1.0 style:HNBToastHudFailure];
        }
    }
    else if ([_tilteString isEqual: @"兴趣爱好"])
    {
        if (tmpPersonalInfoArry.count != 0 && ![self.inputTextView.text isEqualToString:@""]) {
            
            UserInfo = tmpPersonalInfoArry[0];
            [DataFetcher doUpdateUserInfo:UserInfo.id NickName:nil Motto:nil Indroduction:nil Hobby:self.inputTextView.text Im_state:nil Im_nation:nil withSucceedHandler:^(id JSON) {
                int errCode = [[JSON valueForKey:@"state"] intValue];
                NSLog(@"errCode = %d",errCode);
                if (errCode == 0) {
                    /* 修改本地数据库兴趣爱好 */
                    UserInfo.hobby = self.inputTextView.text;
                    //[UserInfo save];
                    _changeString = self.inputTextView.text;
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }  withFailHandler:^(NSError* error) {
                NSLog(@"errCode = %ld",(long)error.code);
            }];
            
            
        }
        else
        {
            //显示HUD
            [[HNBToast shareManager] toastWithOnView:nil msg:@"兴趣爱好为空" afterDelay:1.0 style:HNBToastHudFailure];
        }

    }

}

#pragma mark ------ 处理字数限制问题

- (NSString *)getLimitedStringFromString:(NSString *)content type:(NSString *)type{

    NSString *returnString = content;
    
//    if ([type isEqualToString:@"签名"] && content.length > 30) {
//        
//        returnString = [content substringToIndex:8];
//        
//    } else if ([type isEqualToString:@"自我介绍"] && content.length > 70) {
//        
//        returnString = [content substringToIndex:8];
//        
//    }else if ([type isEqualToString:@"兴趣爱好"] && content.length > 30){
//    
//        returnString = [content substringToIndex:8];
//        
//    }
    
    return returnString;
    
}


#pragma mark ------ UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if (_oldString.length < textView.text.length) { // 增
        // 更新
        if ([_tilteString isEqualToString:@"签名"] && textView.text.length > (CGFloat)(LIMITED_SIGNATURE)) { // 字数不多于 LIMITED_COUNT
            
            textView.text = _oldString;
            
        } else if ( [_tilteString isEqualToString:@"自我介绍"] && textView.text.length > LIMITED_BRIEFINFO_COUNT) { // 字数不多于 LIMITED_BRIEFINFO_COUNT
            textView.text = _oldString;
        }else if ([_tilteString isEqualToString:@"兴趣爱好"] && textView.text.length > LIMITED_COUNT){ // 字数不多于 LIMITED_COUNT

            textView.text = _oldString;
        }
        else{
            _oldString = textView.text;
        }
        
    } else { // 删
        _oldString = textView.text;
        
    }
    
}

@end
