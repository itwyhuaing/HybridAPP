//
//  CardTableView.h
//  hinabian
//
//  Created by hnbwyh on 2018/3/28.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

// 海外公司注册、海外银行服务
typedef enum : NSUInteger {
    CardTableContentTypeOverseaBank = 1000,
    CardTableContentTypeOverseaCompany,
} CardTableContentType;

// 头部子模块视图标记
typedef enum : NSUInteger {
    HeaderSubViewBgImageV = 100,
    HeaderSubViewIconImageV,
    HeaderSubViewThemTitle,
} HeaderSubViewTag;

#define kTABLEHEADERHEIGHT (183.0*SCREEN_WIDTHRATE_6)

@class CardTableView;
@protocol CardTableViewDelegate <NSObject>
@optional

- (void)didClickCardTableHeaderBackBtn:(UIButton *)btn;

-(void)cardTableView:(CardTableView *)v didSelectedIndexPath:(NSIndexPath *)index;

- (void)scrollCardTableViewWithOffsetY:(CGFloat)offsetY;

@end


@interface CardTableView : UIView

@property (nonatomic,weak) id <CardTableViewDelegate> delegate;

- (void)modifyTableHeaderWithType:(CardTableContentType)type;

- (void)refreshTableWithDataSource:(NSArray *)dataSource;

- (UITableView *)getCurrentTableView;

@end
