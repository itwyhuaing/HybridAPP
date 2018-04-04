//
//  HNBTribeShowActionSheet.m
//  hinabian
//
//  Created by 余坚 on 16/6/13.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import "HNBTribeShowActionSheet.h"

#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]
#define ANIMATE_DURATION                        0.25f
#define TOOL_BAR_BUTTON_HEIGHT   30
#define TOOL_BAR_BUTTON_WIDTH    40
#define TOOL_BAR_HEIGHT    44
#define TOOL_BAR_LABEL_HEIGHT    30
#define TOOL_BAR_LABEL_WIDTH    70

@interface HNBTribeShowActionSheet()<UIPickerViewDelegate>
{
    NSString * currentPage;
    NSString * totlePage;
}
@property (nonatomic, strong) NSMutableArray *pickerArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UILabel * pageLabel;
@end

@implementation HNBTribeShowActionSheet

-(id)initWithView:(NSInteger)totle currentPage:(NSInteger)current AndHeight:(float)height{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //生成HNBCustomActionSheet
        self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - 200), SCREEN_WIDTH, height)];
        self.backGroundView.backgroundColor = [UIColor whiteColor];
        
        _pickerArray = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < totle; i++) {
            NSString * tmpPage = [NSString stringWithFormat:@"第%ld页",(i+1)];
            [_pickerArray addObject:tmpPage];
        }
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 200)];
        _pickerView.delegate = (id)self;
        _pickerView.dataSource = (id)self;
        _pickerView.showsSelectionIndicator = YES;
        if (current >= 1) {
            [_pickerView selectRow:(current-1) inComponent:0 animated:YES];
        }
        currentPage = [NSString stringWithFormat:@"%ld",current];
        totlePage = [NSString stringWithFormat:@"%ld",totle];
        
//        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//        toolBar.barStyle = UIBarStyleDefault;
//        
//        
//        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
//        UIBarButtonItem *right1Button = [[UIBarButtonItem alloc] initWithTitle:@">" style: UIBarButtonItemStylePlain target: self action: @selector(done)];
//        UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
//        UIBarButtonItem *left1Button  = [[UIBarButtonItem alloc] initWithTitle:@"<" style: UIBarButtonItemStylePlain target: self action: @selector(docancel)];
//        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
//        NSArray *array = [[NSArray alloc] initWithObjects: leftButton,left1Button,fixedButton,right1Button, rightButton, nil];
//        [toolBar setItems: array];
        UIView * toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOL_BAR_HEIGHT)];
        toolBarView.backgroundColor = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:250/255.0f alpha:0.5];
        
        UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(10, (TOOL_BAR_HEIGHT - TOOL_BAR_BUTTON_HEIGHT)/2, TOOL_BAR_BUTTON_WIDTH, TOOL_BAR_BUTTON_HEIGHT)];
        [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancleButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [cancleButton setTitleColor:[UIColor DDNavBarBlue]forState:UIControlStateNormal];
        [cancleButton addTarget:self action:@selector(docancel) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *firstPageButton = [[UIButton alloc] initWithFrame:CGRectMake(10 + TOOL_BAR_BUTTON_WIDTH + 20, (TOOL_BAR_HEIGHT - TOOL_BAR_BUTTON_HEIGHT)/2, TOOL_BAR_BUTTON_WIDTH, TOOL_BAR_BUTTON_HEIGHT)];
        [firstPageButton setTitle:@"首页" forState:UIControlStateNormal];
        [firstPageButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [firstPageButton setTitleColor:[UIColor DDSideChatTextDark]forState:UIControlStateNormal];
        [firstPageButton addTarget:self action:@selector(firstPage) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - TOOL_BAR_BUTTON_WIDTH, (TOOL_BAR_HEIGHT - TOOL_BAR_BUTTON_HEIGHT)/2, TOOL_BAR_BUTTON_WIDTH, TOOL_BAR_BUTTON_HEIGHT)];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [okButton setTitleColor:[UIColor DDNavBarBlue]forState:UIControlStateNormal];
        [okButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lastPageButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - TOOL_BAR_BUTTON_WIDTH*2 - 20 , (TOOL_BAR_HEIGHT - TOOL_BAR_BUTTON_HEIGHT)/2, TOOL_BAR_BUTTON_WIDTH, TOOL_BAR_BUTTON_HEIGHT)];
        [lastPageButton setTitle:@"末页" forState:UIControlStateNormal];
        [lastPageButton.titleLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        [lastPageButton setTitleColor:[UIColor DDSideChatTextDark]forState:UIControlStateNormal];
        [lastPageButton addTarget:self action:@selector(lastPage) forControlEvents:UIControlEventTouchUpInside];
        
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TOOL_BAR_LABEL_WIDTH, TOOL_BAR_LABEL_HEIGHT)];
        _pageLabel.text = [NSString stringWithFormat:@"%@/%@",currentPage,totlePage];
        [_pageLabel setFont:[UIFont systemFontOfSize:FONT_UI32PX]];
        _pageLabel.textColor = [UIColor coolGrayColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.center = CGPointMake(SCREEN_WIDTH / 2, TOOL_BAR_HEIGHT / 2);
        
        
        
        [toolBarView addSubview:cancleButton];
        [toolBarView addSubview:okButton];
        [toolBarView addSubview:_pageLabel];
        [toolBarView addSubview:lastPageButton];
        [toolBarView addSubview:firstPageButton];
        
        
        //给HNBCustomActionSheet添加响应事件(如果不加响应事件则传过来的view不显示)
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
        [self.backGroundView addGestureRecognizer:tapGesture1];
        
        
        [self addSubview:self.backGroundView];
        [self.backGroundView addSubview:toolBarView];
        [self.backGroundView addSubview:_pickerView];
        
        [UIView animateWithDuration:ANIMATE_DURATION animations:^{
            [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-height, [UIScreen mainScreen].bounds.size.width, height)];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerArray.count;
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pageLabel.text = [NSString stringWithFormat:@"%ld/%@",(row+1),totlePage];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

-(void)showInView:(UIView *)view{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    
}

- (void)tappedBackGroundView
{
    //
}

-(void)done{
    
    if ([_doneDelegate respondsToSelector:@selector(done:)])
    {
        NSInteger selectedContinentIndex = [_pickerView selectedRowInComponent:0];
        [self.doneDelegate done:[NSString stringWithFormat:@"%ld",selectedContinentIndex]];
    }
    [self tappedCancel];
}

-(void)lastPage{
    if ([_doneDelegate respondsToSelector:@selector(jumpToLastPage)])
    {
        [self.doneDelegate jumpToLastPage];
    }
    [self tappedCancel];
}

-(void)firstPage{
    if ([_doneDelegate respondsToSelector:@selector(jumpToFirstPage)])
    {
        [self.doneDelegate jumpToFirstPage];
    }
    [self tappedCancel];
}

-(void)docancel
{
    [self tappedCancel];
}

@end

