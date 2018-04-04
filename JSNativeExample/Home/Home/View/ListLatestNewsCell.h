//
//  ListLatestNewsCell.h
//  hinabian
//
//  Created by hnbwyh on 2017/10/30.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HListLatestNewsCellHeight ((140.0/2.0) * SCREEN_WIDTHRATE_6)

static NSString *cell_ListLatestNewsCell = @"ListLatestNewsCell";
@interface ListLatestNewsCell : UITableViewCell

- (void)setModel:(id)model;

@end
