//
//  InputTextViewController.m
//  hinabian
//
//  Created by 何松泽 on 15/10/26.
//  Copyright © 2015年 &#20313;&#22362;. All rights reserved.
//

#import "InputTextViewController.h"
#import "RDVTabBarController.h"
#import "DataFetcher.h"

@interface InputTextViewController ()<UITextViewDelegate>

@property (strong, nonatomic) UITextView *inputTextView;
@property (strong, nonatomic) UITextView *placeHoldTextView;

@end

@implementation InputTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"回复";
    
    //self.navigationItem.hidesBackButton = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    //init mainView
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (float)SCREEN_WIDTH, (float)SCREEN_HEIGHT)];
    [self.mainView setBackgroundColor:[UIColor DDBackgroundLightGray]];
    [self.mainView setTag:10];
    [self.view addSubview:self.mainView];
    
    self.placeHoldTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 10*2, SCREEN_HEIGHT / 3)];
    self.placeHoldTextView.backgroundColor = [UIColor clearColor];
    self.placeHoldTextView.font = [UIFont systemFontOfSize:14];
    self.placeHoldTextView.text = @"请输入回复";
    [self.view addSubview:self.placeHoldTextView];

    self.inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 10*2, SCREEN_HEIGHT / 3)];
    self.inputTextView.backgroundColor = [UIColor whiteColor];
    self.inputTextView.layer.borderColor = [UIColor DDInputLightGray].CGColor;
    self.inputTextView.layer.borderWidth =1.0;
    self.inputTextView.layer.cornerRadius = 6;
    self.inputTextView.layer.masksToBounds = YES;
    self.inputTextView.delegate = (id)self;
    self.inputTextView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.inputTextView];
    
    /* 设置聚焦 */
    [self.inputTextView becomeFirstResponder];
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
    [v setTitle:@"发表" forState:UIControlStateNormal];
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
    if ([self.inputTextView.text isEqual:@""]) {
        return;
    }
    
    [DataFetcher doReplyPost:@"1" TID:self.T_ID CID:@"" content:self.inputTextView.text ImageList:nil withSucceedHandler:^(id JSON) {
        int errCode = [[JSON valueForKey:@"state"] intValue];
        NSLog(@"errCode = %d",errCode);
        if (errCode == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withFailHandler:^(id error) {
        
    }];
    
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if(![text isEqualToString:@""])
    {
        [_placeHoldTextView setHidden:YES];
    }
    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
        [_placeHoldTextView setHidden:NO];
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    
    return YES;
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
