//
//  HNBIMAssessButton.h
//  hinabian
//
//  Created by 何松泽 on 2017/10/24.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNBIMAssessButton : UIButton

@property (nonatomic, strong)NSString *idTag;           //ID，区分Button
@property (nonatomic, strong)NSString *title;           //标题
@property (nonatomic, strong)NSString *describe;        //描述
@property (nonatomic, strong)UIColor *titleColor;       //标题颜色
@property (nonatomic, strong)UIColor *describeColor;    //描述颜色
@property (nonatomic, strong)UIFont *titleFont;         //标题颜色
@property (nonatomic, strong)UIFont *describeFont;     //描述字体

- (instancetype)initWithDescribeFrame:(CGRect)frame;
- (void)setOriginalBtn;
- (void)setSelectedBtn;

@end
