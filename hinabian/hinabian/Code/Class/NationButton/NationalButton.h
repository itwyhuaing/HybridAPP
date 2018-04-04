//
//  NationalButton.h
//  hinabian
//
//  Created by 何松泽 on 2017/6/9.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NationalButton : UIButton

@property (nonatomic, strong)NSString *idTag;           //国家ID，区分Button
@property (nonatomic, strong)UILabel  *nationLabel;     //国家名称
@property (nonatomic, strong)UILabel  *describeLabel;   //国家描述

- (instancetype)initWithProjectFrame:(CGRect)frame;
- (void)setOriginalBtn;
- (void)setSelectedBtn;


@end
