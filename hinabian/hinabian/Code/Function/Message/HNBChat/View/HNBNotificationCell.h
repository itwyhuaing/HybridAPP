//
//  HNBNotificationCell.h
//  hinabian
//
//  Created by 何松泽 on 2018/1/25.
//  Copyright © 2018年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LabelWidth  240*SCREEN_WIDTHRATE_6
#define DefaultLabelHeight  15

static NSString *cellNib_HNBNotificationCell = @"HNBNotificationCell";

@class IMNotificationModel;
@interface HNBNotificationCell : UITableViewCell

- (void)setCellModel:(IMNotificationModel *)model;


@end
