//
//  HNBQuestionButtonView.h
//  hinabian
//
//  Created by 何松泽 on 2017/11/29.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HNBQuestionButtonLineOne = 1,
    HNBQuestionButtonLineTwo = 2,
    HNBQuestionButtonLineThree = 3,
} HNBQuestionButtonViewLine;

@class HNBQuestionButtonView;
@class HNBIMAssessButton;

@protocol HNBQuestionButtonViewDelegate<NSObject>

@optional
/**
 * 点击按钮
 */
- (void)hnbQuestionChoose:(HNBIMAssessButton *)hnbBtn;
@end

@interface HNBQuestionButtonView : UIView

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) HNBQuestionButtonViewLine line;
@property (nonatomic, weak) id<HNBQuestionButtonViewDelegate> delegate;

+ (instancetype)questionViewWithFrame:(CGRect)frame ButtonLines:(HNBQuestionButtonViewLine)buttonLine dataArr:(NSArray *)dataArr delegate:(id<HNBQuestionButtonViewDelegate>)delegate;

- (void)setButtonWithArray:(NSArray *)datas titleKey:(NSString *)title valueKey:(NSString *)value;
- (void)setIMEDNationButtonWithArray:(NSArray *)datas;
- (void)refreshCityButtonWithArray:(NSArray *)datas;

@end



