//
//  NationCodesView.h
//  hinabian
//
//  Created by hnbwyh on 16/9/2.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NATIONCODE_LIST_TABLE_HEIGHT 300
#define NATIONCODE_LIST_TABLE_CELLHEIGHT 44

@class NationCodesView;

@protocol NationCodesViewDelegate <NSObject>
@optional
- (void)nationCodesView:(NationCodesView *)ncview didSelectedNationCode:(NSString *)selectedCode;

@end



@interface NationCodesView : UIView

@property (nonatomic,weak) id<NationCodesViewDelegate> delegate;

/**
 * 国家码
 */
@property (nonatomic,copy) NSString *lastNationCode;
@property (nonatomic,copy) NSString *currentNationCode;

/**
 * 创建
 */

-(instancetype)initWithDelegate:(id<NationCodesViewDelegate>)delegate;

/**
 * 外部调用 - 展示
 */
- (void)showNationCodesTableView;


@end
