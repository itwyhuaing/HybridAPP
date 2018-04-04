//
//  ChoseLabelsViewController.m
//  hinabian
//
//  Created by 余坚 on 15/7/8.
//  Copyright (c) 2015年 &#20313;&#22362;. All rights reserved.
//

#import "ChoseLabelsViewController.h"
#import "RDVTabBarController.h"
#import "HKKTagWriteView.h"
#import "DataFetcher.h"
#import "Label.h"
#import "LabelCate.h"
#import "HNBToast.h"

@interface ChoseLabelsViewController ()<UIScrollViewDelegate, HKKTagWriteViewDelegate>
@property (nonatomic, strong)  HKKTagWriteView *tagWriteView;
@property (nonatomic, strong)  UIScrollView * scrollView;
@property(nonatomic,strong) NSTimer *mytimer;
@property(nonatomic,strong)NSArray * LabelCate;
@property(nonatomic,strong)NSMutableArray * LabelBeSelected;
@property(nonatomic,strong)NSMutableArray * LabelButton;

@end

#define TAGWRITEVIEW_DISTANCE_FROM_TOP 5
#define ITEM_DISTANCE_EDGE 15
#define TAGWRITEVIEW_HEIGHT 40*SCREEN_SCALE
/*圆形效果
 #define BUTTON_ITEM_SIZE    30
 */
//椭圆效果
//#define BUTTON_ITEM_HEIGHT  30*SCREEN_SCALE
//#define BUTTON_ITEM_WIDTH   BUTTON_ITEM_HEIGHT*2.8
#define BUTTON_ITEM_HEIGHT  33*SCREEN_SCALE_IPHONE6
#define BUTTON_ITEM_WIDTH   90*SCREEN_SCALE_IPHONE6
#define SCREEN_SCALE_IPHONE6    (SCREEN_WIDTH / SCREEN_WIDTH_6)
//

#define DISTANCE_FROM_EACH 10

#define COUNT_IN_ONE_ROW 3

#define LABEL_CATE_NAME_HEIGHT 44

@implementation ChoseLabelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择标签";
    self.view.backgroundColor = [UIColor DDNormalBackGround];
    
    NSLog(@"%f",SCREEN_SCALE);
    
    float widthIncrement = (SCREEN_WIDTH - (BUTTON_ITEM_WIDTH * COUNT_IN_ONE_ROW)) / (COUNT_IN_ONE_ROW+1);
    // Do any additional setup after loading the view.
    self.LabelBeSelected = [[NSMutableArray alloc] init];
    self.LabelButton = [[NSMutableArray alloc] init];
    /* 显示栏 */
    self.tagWriteView.delegate = (id)self.view;
    self.tagWriteView = [[HKKTagWriteView alloc] initWithFrame:CGRectMake(widthIncrement, TAGWRITEVIEW_DISTANCE_FROM_TOP, SCREEN_WIDTH - widthIncrement*2, TAGWRITEVIEW_HEIGHT)];
    [self.tagWriteView setBackgroundColor:[UIColor clearColor]];
    [self.tagWriteView setTagBackgroundColor:[UIColor DDNavBarBlue]];
    [self.tagWriteView setTag:11];
    [[self.tagWriteView layer]setCornerRadius:10.0];
    
    //分割线
    UIView * separatorLine = [[UIView alloc] initWithFrame:CGRectMake(-20, TAGWRITEVIEW_DISTANCE_FROM_TOP + TAGWRITEVIEW_HEIGHT, SCREEN_WIDTH + 20, 0.5)];
    separatorLine.backgroundColor = [UIColor clearColor];
    separatorLine.layer.borderWidth = 0.5;
    separatorLine.layer.borderColor = [UIColor black75PercentColor].CGColor;
    
    [self.view addSubview:self.tagWriteView];
    [self.view addSubview:separatorLine];
    /* 布局UIScrollView */
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.scrollView.delegate = (id)self;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TAGWRITEVIEW_DISTANCE_FROM_TOP*2 + TAGWRITEVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - TAGWRITEVIEW_HEIGHT - TAGWRITEVIEW_DISTANCE_FROM_TOP*3 - rectNav.size.height - rectStatus.size.height)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [[self.scrollView layer]setCornerRadius:10.0];
    [self.view addSubview:self.scrollView];
    
    [self addDataToScrollView];
    
    if(_labelsArray != nil) {
        [self.tagWriteView addTags:_labelsArray];
    }
    
    self.LabelCate = [LabelCate MR_findAllSortedBy:@"timestamp" ascending:YES];
    
    [self checkButtonIsSelected:self.labelsArray];
    /* 定时器 */
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onTimes) userInfo:nil repeats:YES];
}

- (void) addDataToScrollView
{
    NSArray * labelsArry = [Label MR_findAllSortedBy:@"timestamp" ascending:YES];
    float widthIncrement = (self.scrollView.bounds.size.width - (BUTTON_ITEM_WIDTH * COUNT_IN_ONE_ROW)) / (COUNT_IN_ONE_ROW+1);
    
    NSArray * labelCateArry = [LabelCate MR_findAllSortedBy:@"timestamp" ascending:YES];
    int count = 0;
    float heightRightNow = 0;
    for (int index = 0; index < labelCateArry.count; index++ ) {
        LabelCate * f = labelCateArry[index];
        NSArray *labelWithCate = [Label MR_findByAttribute:@"cate" withValue:f.catename andOrderBy:@"timestamp" ascending:YES];
        //NSLog(@"LabelCate - > catename ====== > %@",f.catename);
        //标签名
        UILabel * labelCateNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthIncrement, heightRightNow, SCREEN_WIDTH - widthIncrement, LABEL_CATE_NAME_HEIGHT)];
        labelCateNameLabel.text = f.catename;
        [labelCateNameLabel setTextColor:[UIColor colorWithWhite:0.60 alpha:1.0]];
        labelCateNameLabel.font = [UIFont systemFontOfSize:FONT_UI22PX *SCREEN_SCALE];
        
        //分割线
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, heightRightNow +3*SCREEN_SCALE, SCREEN_WIDTH, 1)];
        [imgView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
        if (index != 0) {//第一行不添加分割线
            [self.scrollView addSubview:imgView];
        }
        
        [self.scrollView addSubview:labelCateNameLabel];
        
        heightRightNow += LABEL_CATE_NAME_HEIGHT;
        for (int i = 0; i < labelWithCate.count; i++) {
            Label * f = labelWithCate[i];
            
            UIButton * tmpButton = [[UIButton alloc] init];
            tmpButton.frame = CGRectMake(
                                         ((i % COUNT_IN_ONE_ROW) + 1)*widthIncrement + (i % COUNT_IN_ONE_ROW)* BUTTON_ITEM_WIDTH,
                                         (i / COUNT_IN_ONE_ROW)*DISTANCE_FROM_EACH + (i / COUNT_IN_ONE_ROW)* BUTTON_ITEM_HEIGHT + heightRightNow,
                                         BUTTON_ITEM_WIDTH,
                                         BUTTON_ITEM_HEIGHT
                                         );
            tmpButton.backgroundColor = [UIColor clearColor];
            [[tmpButton layer]setCornerRadius:(BUTTON_ITEM_HEIGHT/ 2)];
            tmpButton.clipsToBounds = YES;
            [tmpButton setTitle:f.name forState:UIControlStateNormal];
            tmpButton.titleLabel.font = [UIFont systemFontOfSize:FONT_UI24PX * SCREEN_SCALE];
            
            UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(8*SCREEN_SCALE, 0, BUTTON_ITEM_WIDTH/6.2*5, BUTTON_ITEM_HEIGHT)];
            buttonLabel.font = [UIFont systemFontOfSize:FONT_UI24PX * SCREEN_SCALE];
            buttonLabel.text = f.name;
            buttonLabel.textAlignment = NSTextAlignmentCenter;
            buttonLabel.textColor = [UIColor DDIMHundredQuestionLabelColor];
            buttonLabel.layer.borderColor = [UIColor clearColor].CGColor;
            buttonLabel.layer.borderWidth = 0.01;
            
            
            if (buttonLabel.text.length > 5) {
                /*如果标签长度大于5，换两行*/
                buttonLabel.numberOfLines = 2;
                buttonLabel.font = [UIFont systemFontOfSize:FONT_UI22PX * SCREEN_SCALE];
            }
            
            [tmpButton setTitleColor:[UIColor clearColor
                                      ] forState:UIControlStateNormal];
            tmpButton.layer.borderColor = [UIColor DDNavBarBlue].CGColor;
            tmpButton.layer.borderWidth = 0.5;
            [tmpButton addTarget:self action:@selector(touchLabelsButton:) forControlEvents:UIControlEventTouchUpInside];
            [tmpButton addSubview:buttonLabel];
            [self.scrollView addSubview:tmpButton];
            [_LabelButton addObject:tmpButton];
            
        }
        int size = 0;
        if (labelWithCate.count % COUNT_IN_ONE_ROW == 0) {
            size = (int)labelWithCate.count / COUNT_IN_ONE_ROW;
        }
        else
        {
            size = (int)labelWithCate.count / COUNT_IN_ONE_ROW + 1;
        }
        heightRightNow += size * DISTANCE_FROM_EACH + size * BUTTON_ITEM_HEIGHT;
        count += labelWithCate.count;
        
    }
    
    int row = (int)(labelsArry.count / COUNT_IN_ONE_ROW);
    float tmpContentHeight = (row + 3) * (BUTTON_ITEM_HEIGHT) + row * ITEM_DISTANCE_EDGE + labelCateArry.count * LABEL_CATE_NAME_HEIGHT;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tmpContentHeight);
}

-(void)touchLabelsButton:(UIButton *)sender
{
    if (self.LabelBeSelected.count >= 3) {
        
    }
    if ([sender.subviews count] > 2) {;
        
        UIView * tmpview = [sender.subviews objectAtIndex:2];
        [tmpview removeFromSuperview];
        [sender setBackgroundColor:[UIColor clearColor]];
        UILabel *tmpLabel = [sender.subviews objectAtIndex:1];
        tmpLabel.textColor = [UIColor DDIMHundredQuestionLabelColor];
        [self.tagWriteView removeTags:@[sender.titleLabel.text]];
        [self.LabelBeSelected removeObject:sender];
    }
    else
    {
        if ([self.tagWriteView tagsIsAlreadyFull]) {
            [[HNBToast shareManager] toastWithOnView:nil msg:@"标签最多添加3个" afterDelay:1.0 style:HNBToastHudFailure];
            return;
        }
        UILabel *tmpLabel = [sender.subviews objectAtIndex:1];
        tmpLabel.textColor = [UIColor whiteColor];
        [sender setBackgroundColor:[UIColor DDNavBarBlue]];
        
        [self addMaskingImage:sender];
        [self.tagWriteView addTags:@[sender.titleLabel.text]];
        [self.LabelBeSelected addObject:sender];
    }
    
    
}
-(void)addMaskingImage:(UIButton *)originalButton
{
    /* 蒙版层 */
    UIImageView * maskImageView = [[UIImageView alloc] init];
    maskImageView.backgroundColor = [UIColor clearColor];
    maskImageView.frame = CGRectMake(0, 0, originalButton.frame.size.width, originalButton.frame.size.height);
    maskImageView.layer.cornerRadius = originalButton.frame.size.height / 2;
    [originalButton addSubview:maskImageView];
}


/* 初始化处理 如果标签已选择则图片加上蒙板 */

-(void)checkButtonIsSelected:(NSArray *) nationArry
{
    int index = 0;
    for (UIButton * tmpButton in self.LabelButton) {
        if ([nationArry containsObject:tmpButton.titleLabel.text]) {
            if(index < (int)self.LabelButton.count)
            {
                UILabel *tmpLabel = [tmpButton.subviews objectAtIndex:1];
                tmpLabel.textColor = [UIColor whiteColor];
                [self addMaskingImage:tmpButton];
                [tmpButton setBackgroundColor:[UIColor DDNavBarBlue]];
                [self.LabelBeSelected addObject:tmpButton];
            }
        }
        index++;
    }
}

/* 定时器处理函数 */

-(void)onTimes{
    UIButton * tmpRemoveButton = Nil;
    for (UIButton * tmpButton in self.LabelBeSelected)
    {
        NSString * compareString = tmpButton.titleLabel.text;
        if (![self.tagWriteView.tags containsObject:compareString])
        {
            UIView * tmpview = [tmpButton.subviews objectAtIndex:2];
            [tmpview removeFromSuperview];
            UILabel *tmpLabel = [tmpButton.subviews objectAtIndex:1];
            tmpLabel.textColor = [UIColor DDIMHundredQuestionLabelColor];
            tmpButton.backgroundColor = [UIColor clearColor];
            tmpRemoveButton = tmpButton;
            break;
        }
    }
    if (tmpRemoveButton) {
        [self.LabelBeSelected removeObject:tmpRemoveButton];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *sureBtn  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    sureBtn.backgroundColor = [UIColor clearColor];
    [sureBtn setImage:[UIImage imageNamed:@"choose_navbar_btn_default"] forState:UIControlStateNormal];
//    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [sureBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(changeSubmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItem = barButton;
    
    [self.navigationItem hidesBackButton];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"btn_fanhui"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back_main);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

-(void) back_main
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeSubmit
{
    NSArray * tmpArry = self.tagWriteView.tags;
    NSString * tmpNationCN = @"";
    for (int index = 0; index < tmpArry.count; index++) {
        tmpNationCN = [tmpNationCN stringByAppendingString:tmpArry[index]];
        if (index != (tmpArry.count - 1)) {
            tmpNationCN = [tmpNationCN stringByAppendingString:@","];
        }
        
    }
    self.labelsString = tmpNationCN;
    [self.navigationController popViewControllerAnimated:YES];
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
