//
//  SingleProjVisaView.h
//  hinabian
//
//  Created by 何松泽 on 2017/8/21.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

@interface BottomCellView : UIView

@property (nonatomic, strong) UILabel   *valueLabel;

@property (nonatomic, strong) UILabel   *titleLabel;

@property (nonatomic, strong) UILabel   *originalLabel;

@property (nonatomic, strong) UIView    *line;

- (void)setValueString:(NSString *)valueString
            unitString:(NSString *)unitString
     originValueString:(NSString *)originValueString
           titleString:(NSString *)titleString;

@end

#import <UIKit/UIKit.h>

@class IMHomeProjModel;
@class IMHomeVisaModel;

@interface SingleProjVisaView : UIView

- (void)setProjModel:(IMHomeProjModel *)model;
- (void)setVisaModel:(IMHomeVisaModel *)model;

@end
