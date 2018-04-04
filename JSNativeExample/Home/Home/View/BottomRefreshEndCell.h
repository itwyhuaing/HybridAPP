//
//  BottomRefreshEndCell.h
//  hinabian
//
//  Created by hnbwyh on 16/6/1.
//  Copyright © 2016年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellNibName_BottomRefreshEndCell = @"BottomRefreshEndCell";
@interface BottomRefreshEndCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageViewWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageViewHeight;

- (void)setCellItem;

@end
