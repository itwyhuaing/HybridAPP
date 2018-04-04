//
//  HNBQuestionButtonView.m
//  hinabian
//
//  Created by 何松泽 on 2017/11/29.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import "HNBQuestionButtonView.h"
#import "HNBIMAssessButton.h"
#import "IMNationCityModel.h"

@interface HNBQuestionButtonView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) float buttonDistance;

@end

@implementation HNBQuestionButtonView

+ (instancetype)questionViewWithFrame:(CGRect)frame ButtonLines:(HNBQuestionButtonViewLine)buttonLine dataArr:(NSArray *)dataArr delegate:(id<HNBQuestionButtonViewDelegate>)delegate {
    
    HNBQuestionButtonView *hnbQuestionView = [[self alloc] initWithFrame:frame dataArr:dataArr line:buttonLine];
    hnbQuestionView.line = buttonLine;
    hnbQuestionView.delegate = delegate;
    hnbQuestionView.dataArray = dataArr;
    return hnbQuestionView;
}

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSArray *)dataArr line:(HNBQuestionButtonViewLine)line{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = dataArr;
        self.line = line;
        
        if (line == HNBQuestionButtonLineOne) {
            self.buttonDistance = 60.f;
        }else if (line == HNBQuestionButtonLineTwo) {
            self.buttonDistance = 35.f;
        }else if (line == HNBQuestionButtonLineThree) {
            self.buttonDistance = 19.f;
        }else {
            self.buttonDistance = 0.f;
        }
        
        [self setupMainView];
//        [self setButtonWithArray:_dataArray];
    }
    return self;
}

- (void)setupMainView {
    CGRect rect = CGRectZero;
    rect.size.width = self.frame.size.width;
    rect.size.height = self.frame.size.height;
    
    UIScrollView *verScrollView = [[UIScrollView alloc] initWithFrame:rect];
    verScrollView.backgroundColor = [UIColor whiteColor];
    verScrollView.showsVerticalScrollIndicator = false;
    verScrollView.contentSize = CGSizeMake(rect.size.width,rect.size.height);
    verScrollView.scrollEnabled = FALSE;
    self.scrollView = verScrollView;
    [self addSubview:_scrollView];
}

- (void)setButtonWithArray:(NSArray *)datas titleKey:(NSString *)title valueKey:(NSString *)value{
    
    for (NSInteger index = 0; index < datas.count; index++) {
        float buttonWidth = (SCREEN_WIDTH - _buttonDistance*(_line + 1))/_line;
        CGRect rect = CGRectZero;
        rect.origin.x   = ((index % _line) + 1)*_buttonDistance + (index % _line)* buttonWidth;
        rect.origin.y   = (index / _line + 1)*19 + (index / _line)* 45;
        rect.size.width = buttonWidth;
        rect.size.height= 45;
        
        if (index == datas.count - 1) {
            if (CGRectGetMaxY(rect) > self.frame.size.height) {
                _scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(rect) + 10);
                _scrollView.scrollEnabled = YES;
            }
        }
        
        HNBIMAssessButton * tmpButton = [[HNBIMAssessButton alloc] initWithFrame:rect];
//        tmpButton.title = [datas[index] valueForKey:@"name"]; /*标题*/
//        tmpButton.tag = [[datas[index] valueForKey:@"value"] longValue]; /*选项值*/
        tmpButton.title = [datas[index] valueForKey:title];
        tmpButton.idTag = [NSString stringWithFormat:@"%d",[[datas[index] valueForKey:value] integerValue]];
        [tmpButton setOriginalBtn];
        [tmpButton addTarget:self action:@selector(choseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:tmpButton];
    }
}

- (void)setIMEDNationButtonWithArray:(NSArray *)datas {
    for (NSInteger index = 0; index < datas.count; index++) {
        float buttonWidth = (SCREEN_WIDTH - _buttonDistance*(_line + 1))/_line;
        CGRect rect = CGRectZero;
        rect.origin.x   = ((index % _line) + 1)*_buttonDistance + (index % _line)* buttonWidth;
        rect.origin.y   = (index / _line + 1)*19 + (index / _line)* 45;
        rect.size.width = buttonWidth;
        rect.size.height= 45;
        
        if (index == datas.count - 1) {
            if (CGRectGetMaxY(rect) > self.frame.size.height) {
                _scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(rect) + 10);
                _scrollView.scrollEnabled = YES;
            }
        }
        
        HNBIMAssessButton * tmpButton = [[HNBIMAssessButton alloc] initWithFrame:rect];
        IMNationCityModel *model = datas[index];
        tmpButton.title = model.shortName; /*标题*/
        tmpButton.idTag = model.fID; /*选项值*/
        [tmpButton setOriginalBtn];
        [tmpButton addTarget:self action:@selector(choseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:tmpButton];
    }
}

- (void)refreshCityButtonWithArray:(NSArray *)datas {
    
    NSArray *subArr = [_scrollView.subviews copy];
    for (UIButton *tempBtn in subArr) {
        [tempBtn removeFromSuperview];
    }
    
    for (NSInteger index = 0; index < datas.count; index++) {
        float buttonWidth = (SCREEN_WIDTH - _buttonDistance*(_line + 1))/_line;
        CGRect rect = CGRectZero;
        rect.origin.x   = ((index % _line) + 1)*_buttonDistance + (index % _line)* buttonWidth;
        rect.origin.y   = (index / _line + 1)*19 + (index / _line)* 45;
        rect.size.width = buttonWidth;
        rect.size.height= 45;
        
        if (index == datas.count - 1) {
            if (CGRectGetMaxY(rect) > self.frame.size.height) {
                _scrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(rect) + 10);
                _scrollView.scrollEnabled = YES;
            }
        }
        
        HNBIMAssessButton * tmpButton = [[HNBIMAssessButton alloc] initWithFrame:rect];
        tmpButton.title = [datas[index] valueForKey:@"f_name_cn"];
        tmpButton.idTag = [NSString stringWithFormat:@"%ld",[[datas[index] valueForKey:@"f_id"] integerValue]];
        [tmpButton setOriginalBtn];
        [tmpButton addTarget:self action:@selector(choseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:tmpButton];
    }
}

- (void)choseButton:(HNBIMAssessButton *)hnbButton {
    if (_delegate && [_delegate respondsToSelector:@selector(hnbQuestionChoose:)]) {
        [_delegate hnbQuestionChoose:hnbButton];
    }
}




@end
