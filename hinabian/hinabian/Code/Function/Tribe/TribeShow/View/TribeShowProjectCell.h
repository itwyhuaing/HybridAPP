//
//  TribeShowProjectCell.h
//  hinabian
//
//  Created by hnbwyh on 17/4/18.
//  Copyright © 2017年 &#20313;&#22362;. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TribeShowProjectModel;

static NSString *cellNilName_TribeShowProjectCell = @"TribeShowProjectCell";
@interface TribeShowProjectCell : UITableViewCell

- (void)setTribeShowProCellWithModel:(TribeShowProjectModel *)infoModel indexPath:(NSIndexPath *)indexPath;

@end
